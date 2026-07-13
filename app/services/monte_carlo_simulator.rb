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

  # Bernoulli success probability per bet type — the input distribution we sample each week (MC step 2:
  # specify the predictor variable's distribution). Low p = rare big wins, high p = frequent small swings.
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
  # Fraction of the bankroll a bettor re-wagers each week (0 = pockets everything, 1 = lets it all ride).
  # 0.5 is anchored to observed Brazilian turnover÷deposits (~1.6–2.3×); it scales the effective edge.
  DEFAULT_REBET_FRACTION = 0.5
  REPORTED_PERCENTILES = [ 5, 25, 50, 75, 95 ].freeze

  attribute :bet_type_key, :string
  attribute :house_edge, :float
  attribute :weekly_amount_cents, :integer
  attribute :simulation_count, :integer, default: DEFAULT_SIMULATION_COUNT
  attribute :rebet_fraction, :float, default: DEFAULT_REBET_FRACTION

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

  # Monte Carlo core: draw `simulation_count` independent sampled paths, one net outcome each.
  # The sorted outcomes form the output distribution we read percentiles off (MC step 3).
  def simulated_outcomes(weeks)
    simulation_count.times.map { single_run_net(weeks) }
  end

  # One Monte Carlo iteration — a single random walk through the horizon. Each week deposits the weekly
  # amount, then re-wagers a fraction (rebet_fraction) of the bankroll and pockets the rest: a
  # Bernoulli draw (rand < p) lets the staked part ride on a win, loses it on a loss. Net = final bankroll
  # minus everything deposited. At rebet_fraction = 1 the whole bankroll rides (pure let-it-ride).
  def single_run_net(weeks)
    bankroll = 0
    weeks.times do
      bankroll += weekly_amount_cents
      staked = bankroll * rebet_fraction
      kept = bankroll - staked
      bankroll = (kept + (rand < win_probability ? staked * win_multiplier : 0)).round
    end
    bankroll - weekly_amount_cents * weeks
  end

  def profit_percentage(outcomes)
    (outcomes.count(&:positive?).to_f / simulation_count * 100).round(1)
  end

  # Analytic counterpart to the sampled runs above: the exact E[net], not an average of draws. The MC
  # outcomes give the spread ("what could happen to you"); this closed form gives the mean drift ("what
  # happens on average") and cross-checks the simulation. E[balance] follows B_t = (B_{t-1} + deposit)(1 - edge):
  # recycled winnings compound the edge over turnover, so cumulative loss trends toward full deposits (gambler's ruin).
  def expected_value_cents(weeks)
    deposited = weekly_amount_cents * weeks
    # Only rebet_fraction of the bankroll is re-exposed each week, so the edge bites at rebet_fraction × house_edge.
    effective_edge = rebet_fraction * house_edge
    return 0 if effective_edge.zero?

    retention = 1.0 - effective_edge
    expected_balance = weekly_amount_cents * retention * (1 - retention**weeks) / effective_edge
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
