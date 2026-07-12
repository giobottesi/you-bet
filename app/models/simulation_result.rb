class SimulationResult < ApplicationRecord
  validates :inputs_signature, presence: true, uniqueness: true

  # The stored result bucket for a horizon, keyed via the simulator's weeks map. Nil when not simulated.
  def result_by_timeframe(timeframe_weeks)
    results[MonteCarloSimulator::TIMEFRAMES.key(timeframe_weeks)]
  end

  # Projected loss in cents for the horizon (the stored expected value is negative).
  def loss_cents(timeframe_weeks)
    result_by_timeframe(timeframe_weeks)['expected_value_cents'].abs
  end

  # Loss as a fraction of everything deposited over the horizon — the share of your money that's gone.
  def loss_fraction(timeframe_weeks)
    bucket = result_by_timeframe(timeframe_weeks)
    bucket['expected_value_cents'].abs.to_f / bucket['total_deposited_cents']
  end

  # Share of simulated runs that ended in any profit — the honest short-term "win" that shrinks over time.
  def profit_percentage(timeframe_weeks)
    result_by_timeframe(timeframe_weeks)['profit_percentage']
  end
end
