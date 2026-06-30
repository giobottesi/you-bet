class MonteCarloSimulator
  include ActiveModel::Model
  include ActiveModel::Attributes

  TIMEFRAMES = {
    'month_1' => 4,
    'months_6' => 26,
    'year_1' => 52,
    'years_2' => 104,
    'years_5' => 260
  }.freeze

  # Win probability per bet type — determines variance/skew.
  # House edge determines expected loss; win probability determines distribution shape.
  # Low p = rare big wins + many losses (lottery). High p = frequent small swings (sports).
  WIN_PROBABILITIES = {
    'sports_singles' => 0.48,
    'accumulator_3' => 0.125,
    'accumulator_5' => 0.03125,
    'slots_tigrinho' => 0.30,
    'crash_aviator' => 0.45,
    'lottery' => 0.0000001,
    'roulette' => 0.4737
  }.freeze

  DEFAULT_SIMULATION_COUNT = 1000

  attribute :bet_type_key, :string
  attribute :house_edge, :float
  attribute :weekly_amount_cents, :integer
  attribute :simulation_count, :integer, default: DEFAULT_SIMULATION_COUNT

  def run
    TIMEFRAMES.each_with_object({}) do |(timeframe_key, weeks), results|
      results[timeframe_key] = simulate_timeframe(weeks)
    end
  end

  private

  # Win probability per bet type — determines distribution shape. Defaults to a
  # neutral mid value for unknown bet types.
  def win_probability
    @win_probability ||= WIN_PROBABILITIES.fetch(bet_type_key, 0.45)
  end

  # Per-week binary bet: win with probability p, lose with probability (1-p).
  # Payout on win = amount * (1 - house_edge) / p
  # This gives E[net] = p * (payout - amount) + (1-p) * (-amount) = -amount * house_edge
  def simulate_timeframe(weeks)
    payout_on_win = (weekly_amount_cents * (1.0 - house_edge) / win_probability).round

    outcomes = Array.new(simulation_count) do
      cumulative = 0
      weeks.times do
        if rand < win_probability
          cumulative += payout_on_win - weekly_amount_cents
        else
          cumulative -= weekly_amount_cents
        end
      end
      cumulative
    end

    outcomes.sort!
    profit_count = outcomes.count(&:positive?)

    {
      weeks: weeks,
      total_wagered_cents: weekly_amount_cents * weeks,
      percentiles: extract_percentiles(outcomes),
      profit_percentage: (profit_count.to_f / simulation_count * 100).round(1),
      expected_value_cents: -(weekly_amount_cents * weeks * house_edge).round
    }
  end

  def extract_percentiles(sorted_outcomes)
    {
      p5: sorted_outcomes[percentile_index(5)],
      p25: sorted_outcomes[percentile_index(25)],
      p50: sorted_outcomes[percentile_index(50)],
      p75: sorted_outcomes[percentile_index(75)],
      p95: sorted_outcomes[percentile_index(95)]
    }
  end

  def percentile_index(percentile)
    ((percentile / 100.0) * simulation_count).ceil.clamp(1, simulation_count) - 1
  end
end
