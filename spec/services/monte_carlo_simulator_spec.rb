require 'rails_helper'

RSpec.describe MonteCarloSimulator do
  subject(:simulator) do
    described_class.new(
      bet_type_key: bet_type_key,
      house_edge: house_edge,
      weekly_amount_cents: weekly_amount_cents,
      simulation_count: simulation_count,
      rebet_fraction: rebet_fraction
    )
  end

  let(:bet_type_key) { 'sports_singles' }
  let(:house_edge) { 0.06 }
  let(:weekly_amount_cents) { 5000 }
  let(:simulation_count) { 1000 }
  let(:rebet_fraction) { MonteCarloSimulator::DEFAULT_REBET_FRACTION }

  describe '#run' do
    subject(:results) { simulator.run }

    it 'returns all five timeframes' do
      expect(results.keys).to contain_exactly('month_1', 'months_6', 'year_1', 'years_2', 'years_5')
    end

    it 'includes the five percentiles for each timeframe' do
      results.each_value do |timeframe|
        expect(timeframe[:percentiles].keys).to contain_exactly(:p5, :p25, :p50, :p75, :p95)
      end
    end

    it 'orders the percentiles ascending' do
      results.each_value do |timeframe|
        percentiles = timeframe[:percentiles].values
        expect(percentiles).to eq(percentiles.sort)
      end
    end

    it 'keeps profit_percentage between 0 and 100' do
      results.each_value do |timeframe|
        expect(timeframe[:profit_percentage]).to be_between(0, 100)
      end
    end

    it 'has a negative expected value for every timeframe' do
      results.each_value do |timeframe|
        expect(timeframe[:expected_value_cents]).to be_negative
      end
    end

    it 'compounds losses over longer periods' do
      expect(results['years_5'][:expected_value_cents]).to be < results['month_1'][:expected_value_cents]
    end

    it 'lowers the profit percentage over longer timeframes' do
      expect(results['years_5'][:profit_percentage]).to be < results['month_1'][:profit_percentage]
    end

    it 'loses more than a single-turnover edge because winnings are re-wagered' do
      expect(results['month_1'][:expected_value_cents]).to be < -(weekly_amount_cents * 4 * house_edge)
    end

    it 'trends toward losing most of the deposits over five years (gambler\'s ruin)' do
      years_5 = results['years_5']
      loss_fraction = years_5[:expected_value_cents].abs.to_f / years_5[:total_deposited_cents]
      expect(loss_fraction).to be > 0.8
    end

    it 'tracks the total deposited per timeframe' do
      expect(results['month_1'][:total_deposited_cents]).to eq(weekly_amount_cents * 4)
      expect(results['years_5'][:total_deposited_cents]).to eq(weekly_amount_cents * 260)
    end
  end

  describe 'profit sensitivity to house edge' do
    subject(:lottery_profit) { high_edge_results['year_1'][:profit_percentage] }

    let(:high_edge_results) do
      described_class.new(
        bet_type_key: 'lottery', house_edge: 0.54,
        weekly_amount_cents: weekly_amount_cents, simulation_count: simulation_count
      ).run
    end
    let(:sports_profit) { simulator.run['year_1'][:profit_percentage] }

    it 'gives a high house edge a lower profit percentage than sports singles' do
      expect(lottery_profit).to be < sports_profit
    end
  end

  describe 'recycling coefficient' do
    let(:weekly_amount_cents) { 5000 }

    def year_1_expected_value(recycling)
      described_class.new(
        bet_type_key: bet_type_key, house_edge: house_edge,
        weekly_amount_cents: weekly_amount_cents, simulation_count: simulation_count,
        rebet_fraction: recycling
      ).run['year_1'][:expected_value_cents]
    end

    it 'loses nothing when the bettor pockets the whole bankroll (r = 0)' do
      described_class.run(
        bet_type_key: bet_type_key, house_edge: house_edge,
        weekly_amount_cents: weekly_amount_cents, simulation_count: simulation_count,
        rebet_fraction: 0.0
      ).each_value do |timeframe|
        expect(timeframe[:expected_value_cents]).to eq(0)
        expect(timeframe[:profit_percentage]).to eq(0.0)
      end
    end

    it 'loses more the more of the bankroll rides' do
      expect(year_1_expected_value(1.0)).to be < year_1_expected_value(0.5)
      expect(year_1_expected_value(0.5)).to be < year_1_expected_value(0.25)
    end

    # The edge only bites the re-wagered fraction, so r × house_edge is the effective edge:
    # recycling half of a 6% edge is analytically identical to fully recycling a 3% edge.
    it 'scales the effective edge by the recycling coefficient' do
      half_recycled = described_class.run(
        bet_type_key: bet_type_key, house_edge: 0.06,
        weekly_amount_cents: weekly_amount_cents, simulation_count: simulation_count,
        rebet_fraction: 0.5
      )
      fully_recycled_half_edge = described_class.run(
        bet_type_key: bet_type_key, house_edge: 0.03,
        weekly_amount_cents: weekly_amount_cents, simulation_count: simulation_count,
        rebet_fraction: 1.0
      )

      MonteCarloSimulator::TIMEFRAMES.each_key do |timeframe_key|
        expect(half_recycled[timeframe_key][:expected_value_cents])
          .to eq(fully_recycled_half_edge[timeframe_key][:expected_value_cents])
      end
    end
  end

  # The engine is pure math with no input validation — semantic rejection (negative/zero
  # amounts) belongs at the boundary (SimulationInput / the form), not here. These specs
  # pin that the engine stays robust and well-formed on hostile inputs instead of crashing.
  describe 'edge cases' do
    subject(:results) { simulator.run }

    let(:timeframe_keys) { %w[month_1 months_6 year_1 years_2 years_5] }

    context 'with a zero weekly amount' do
      let(:weekly_amount_cents) { 0 }

      it 'runs without error and reports no loss' do
        expect(results.keys).to match_array(timeframe_keys)
        results.each_value do |timeframe|
          expect(timeframe[:expected_value_cents]).to eq(0)
          expect(timeframe[:profit_percentage]).to eq(0.0)
          expect(timeframe[:percentiles].values).to all(eq(0))
        end
      end
    end

    context 'with a negative weekly amount' do
      let(:weekly_amount_cents) { -5000 }

      it 'does not raise and still returns well-formed results' do
        expect { results }.not_to raise_error
        expect(results.keys).to match_array(timeframe_keys)
        results.each_value do |timeframe|
          percentiles = timeframe[:percentiles].values
          expect(percentiles).to eq(percentiles.sort)
        end
      end
    end

    context 'with an extreme weekly amount' do
      let(:weekly_amount_cents) { 100_000_000_00 } # R$100M/week

      it 'handles large integers without overflow or infinity' do
        expect(results.keys).to match_array(timeframe_keys)
        results.each_value do |timeframe|
          expect(timeframe[:expected_value_cents]).to be_a(Integer).and(be_negative)
          expect(timeframe[:percentiles].values).to all(be_a(Integer))
        end
      end
    end

    context 'with the house edge at 0' do
      let(:house_edge) { 0.0 }

      it 'produces a break-even expected value without raising' do
        expect(results.keys).to match_array(timeframe_keys)
        results.each_value { |timeframe| expect(timeframe[:expected_value_cents]).to eq(0) }
      end
    end

    context 'with the house edge at 1.0 (house always keeps the stake)' do
      let(:house_edge) { 1.0 }
      let(:rebet_fraction) { 1.0 } # whole bankroll rides, so a 100% edge wipes every run

      it 'loses the full wager every run' do
        results.each_value do |timeframe|
          expect(timeframe[:expected_value_cents]).to eq(-timeframe[:total_deposited_cents])
          expect(timeframe[:profit_percentage]).to eq(0.0)
          expect(timeframe[:percentiles].values).to all(eq(-timeframe[:total_deposited_cents]))
        end
      end
    end

    context 'with an unknown bet type' do
      let(:bet_type_key) { 'unknown_game' }

      it 'falls back to the neutral win probability without raising' do
        expect { results }.not_to raise_error
        expect(results.keys).to match_array(timeframe_keys)
        results.each_value do |timeframe|
          percentiles = timeframe[:percentiles].values
          expect(percentiles).to eq(percentiles.sort)
        end
      end
    end

    context 'across every known bet type' do
      it 'produces well-formed, losing results for each' do
        described_class::WIN_PROBABILITIES.each_key do |key|
          timeframes = described_class.run(
            bet_type_key: key, house_edge: 0.1,
            weekly_amount_cents: weekly_amount_cents, simulation_count: simulation_count
          )

          expect(timeframes.keys).to match_array(timeframe_keys), key
          timeframes.each_value do |timeframe|
            expect(timeframe[:percentiles].values).to eq(timeframe[:percentiles].values.sort), key
            expect(timeframe[:expected_value_cents]).to be_negative, key
          end
        end
      end
    end
  end
end
