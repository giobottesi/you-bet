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

  # Loss as a fraction of everything wagered over the horizon (the realized edge).
  def loss_fraction(timeframe_weeks)
    bucket = result_by_timeframe(timeframe_weeks)
    bucket['expected_value_cents'].abs.to_f / bucket['total_wagered_cents']
  end
end
