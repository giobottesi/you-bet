class SimulationResult < ApplicationRecord
  validates :inputs_signature, presence: true, uniqueness: true

  # The stored result bucket for a horizon, keyed via the simulator's weeks map. Memoized; nil when not simulated.
  def result_by_timeframe(timeframe_weeks)
    (@result_by_timeframe ||= {})[timeframe_weeks] ||=
      results[MonteCarloSimulator::TIMEFRAMES.key(timeframe_weeks)]
  end

  # Projected loss in cents for the horizon (the stored expected value is negative). Nil when not simulated.
  def loss_cents(timeframe_weeks)
    bucket = result_by_timeframe(timeframe_weeks)
    bucket['expected_value_cents'].abs if bucket
  end

  # Loss as a fraction of everything wagered over the horizon (the realized edge). Nil when not simulated or nothing wagered.
  def loss_fraction(timeframe_weeks)
    bucket = result_by_timeframe(timeframe_weeks)
    return if bucket.nil?

    wagered_cents = bucket['total_wagered_cents'].to_i
    return if wagered_cents.zero?

    bucket['expected_value_cents'].abs.to_f / wagered_cents
  end
end
