class SimulationResult < ApplicationRecord
  validates :inputs_signature, presence: true, uniqueness: true
  validates :results, presence: true
end
