require 'rails_helper'

RSpec.describe SimulationResult do
  subject { build(:simulation_result) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:inputs_signature) }
    it { is_expected.to validate_presence_of(:results) }
    it { is_expected.to validate_uniqueness_of(:inputs_signature) }
  end
end
