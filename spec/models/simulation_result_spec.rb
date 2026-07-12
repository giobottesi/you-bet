require 'rails_helper'

RSpec.describe SimulationResult do
  subject { build(:simulation_result) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:inputs_signature) }
    it { is_expected.to validate_uniqueness_of(:inputs_signature) }
  end

  describe 'horizon readers' do
    subject(:simulation_result) do
      build(:simulation_result, results: {
              'year_1' => { 'expected_value_cents' => -13_000, 'total_deposited_cents' => 260_000, 'profit_percentage' => 38.5 }
            })
    end

    it 'returns the stored bucket for a simulated horizon' do
      expect(simulation_result.result_by_timeframe(52)).to include('expected_value_cents' => -13_000)
    end

    it 'is nil for a horizon that was not simulated' do
      expect(simulation_result.result_by_timeframe(4)).to be_nil
    end

    it 'exposes the loss as absolute cents' do
      expect(simulation_result.loss_cents(52)).to eq(13_000)
    end

    it 'exposes the loss as a fraction of everything wagered' do
      expect(simulation_result.loss_fraction(52)).to eq(0.05)
    end

    it 'exposes the share of runs that ended in profit' do
      expect(simulation_result.profit_percentage(52)).to eq(38.5)
    end
  end
end
