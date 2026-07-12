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

  # A won bet returns the stake times (1 - house_edge) / p, so E[balance] *= (1 - house_edge) per turnover.
  def win_multiplier
    @win_multiplier ||= (1.0 - house_edge) / win_probability
  end

  def simulate_timeframe(weeks)
    outcomes = simulated_outcomes(weeks).sort

    {
      weeks: weeks,
      total_deposited_cents: weekly_amount_cents * weeks,
      percentiles: extract_percentiles(outcomes),
      profit_percentage: profit_percentage(outcomes),
      expected_value_cents: expected_value_cents(weeks)
    }
  end

  def simulated_outcomes(weeks)
    simulation_count.times.map { single_run_net(weeks) }
  end

  # One run's net over `weeks`: each week deposits the weekly amount, then re-wagers the whole
  # bankroll — a win lets it ride, a loss zeroes it. Net = final bankroll minus everything deposited.
  def single_run_net(weeks)
    bankroll = 0
    weeks.times do
      bankroll += weekly_amount_cents
      bankroll = rand < win_probability ? (bankroll * win_multiplier).round : 0
    end
    bankroll - weekly_amount_cents * weeks
  end

  def profit_percentage(outcomes)
    (outcomes.count(&:positive?).to_f / simulation_count * 100).round(1)
  end

  # Closed-form expected net: E[balance] follows B_t = (B_{t-1} + deposit)(1 - edge). Recycled winnings
  # compound the edge over turnover, so cumulative loss trends toward the full deposits (gambler's ruin).
  def expected_value_cents(weeks)
    deposited = weekly_amount_cents * weeks
    retention = 1.0 - house_edge
    return 0 if retention == 1.0

    expected_balance = weekly_amount_cents * retention * (1 - retention**weeks) / house_edge
    (expected_balance - deposited).round
  end

  def extract_percentiles(sorted_outcomes)
    REPORTED_PERCENTILES.index_with { |percentile| sorted_outcomes[percentile_index(percentile)] }
                        .transform_keys { |percentile| :"p#{percentile}" }
  end

  def percentile_index(percentile)
    ((percentile / 100.0) * simulation_count).ceil.clamp(1, simulation_count) - 1
  end
end
