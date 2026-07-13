class SimulationResultUpsert
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :bet_type_key, :string
  attribute :house_edge, :float
  attribute :weekly_amount_cents, :integer
  attribute :simulation_count, :integer, default: MonteCarloSimulator::DEFAULT_SIMULATION_COUNT
  attribute :recycling_coefficient, :float, default: MonteCarloSimulator::DEFAULT_RECYCLING_COEFFICIENT

  validates :bet_type_key, presence: true
  validates :house_edge, presence: true
  validates :weekly_amount_cents, presence: true

  def self.upsert(attrs)
    new(**attrs).upsert
  end

  # Read-through cache: compute on miss only, never overwrite a stored result (freeze for stable permalinks).
  def upsert
    return false unless valid?

    SimulationResult.find_by(inputs_signature: inputs_signature) ||
      SimulationResult.create!(inputs_signature: inputs_signature, results: simulated_results).reload
  end

  private

  def inputs_signature
    "#{bet_type_key}:#{house_edge}:#{weekly_amount_cents}:#{simulation_count}:#{recycling_coefficient}"
  end

  def simulated_results
    @simulated_results ||= MonteCarloSimulator.run(
      bet_type_key: bet_type_key,
      house_edge: house_edge,
      weekly_amount_cents: weekly_amount_cents,
      simulation_count: simulation_count,
      recycling_coefficient: recycling_coefficient
    )
  end
end
