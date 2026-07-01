class SimulationResult < ApplicationRecord
  validates :inputs_signature, presence: true, uniqueness: true
end
