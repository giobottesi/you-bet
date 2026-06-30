require 'rails_helper'

RSpec.describe MonteCarloSimulator do
  subject(:simulator) do
    described_class.new(
      bet_type_key: bet_type_key,
      house_edge: house_edge,
      weekly_amount_cents: weekly_amount_cents,
      simulation_count: simulation_count
    )
  end

  let(:bet_type_key) { 'sports_singles' }
  let(:house_edge) { 0.06 }
  let(:weekly_amount_cents) { 5000 }
  let(:simulation_count) { 1000 }

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

    it 'computes the expected value for the first month' do
      expect(results['month_1'][:expected_value_cents]).to eq(-(weekly_amount_cents * 4 * house_edge).round)
    end

    it 'tracks the total wagered per timeframe' do
      expect(results['month_1'][:total_wagered_cents]).to eq(weekly_amount_cents * 4)
      expect(results['years_5'][:total_wagered_cents]).to eq(weekly_amount_cents * 260)
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
end
