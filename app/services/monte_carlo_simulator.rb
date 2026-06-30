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

  # Win probability per bet type — shapes the distribution (low p = rare big wins, high p = small swings).
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
  REPORTED_PERCENTILES = [ 5, 25, 50, 75, 95 ].freeze

  attribute :bet_type_key, :string
  attribute :house_edge, :float
  attribute :weekly_amount_cents, :integer
  attribute :simulation_count, :integer, default: DEFAULT_SIMULATION_COUNT

  def self.run(**attributes)
    new(**attributes).run
  end

  def run
    TIMEFRAMES.each_with_object({}) do |(timeframe_key, weeks), results|
      results[timeframe_key] = simulate_timeframe(weeks)
    end
  end

  private

  # Defaults to a neutral mid value for unknown bet types.
  def win_probability
    @win_probability ||= WIN_PROBABILITIES.fetch(bet_type_key, 0.45)
  end

  # Payout on win = amount * (1 - house_edge) / p, so E[net] = -amount * house_edge.
  def payout_on_win
    @payout_on_win ||= (weekly_amount_cents * (1.0 - house_edge) / win_probability).round
  end

  def simulate_timeframe(weeks)
    outcomes = simulated_outcomes(weeks).sort

    {
      weeks: weeks,
      total_wagered_cents: weekly_amount_cents * weeks,
      percentiles: extract_percentiles(outcomes),
      profit_percentage: profit_percentage(outcomes),
      expected_value_cents: expected_value_cents(weeks)
    }
  end

  def simulated_outcomes(weeks)
    simulation_count.times.map { single_run_net(weeks) }
  end

  # One run's net over `weeks`: each week wins the payout or forfeits the stake.
  def single_run_net(weeks)
    weeks.times.sum do
      rand < win_probability ? payout_on_win - weekly_amount_cents : -weekly_amount_cents
    end
  end

  def profit_percentage(outcomes)
    (outcomes.count(&:positive?).to_f / simulation_count * 100).round(1)
  end

  def expected_value_cents(weeks)
    -(weekly_amount_cents * weeks * house_edge).round
  end

  def extract_percentiles(sorted_outcomes)
    REPORTED_PERCENTILES.index_with { |percentile| sorted_outcomes[percentile_index(percentile)] }
                        .transform_keys { |percentile| :"p#{percentile}" }
  end

  def percentile_index(percentile)
    ((percentile / 100.0) * simulation_count).ceil.clamp(1, simulation_count) - 1
  end
end
