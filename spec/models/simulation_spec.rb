require 'rails_helper'

RSpec.describe Simulation do
  subject(:simulation) { build(:simulation, attributes) }

  let(:attributes) { {} }

  it 'is valid with the full set of inputs' do
    expect(simulation).to be_valid
  end

  describe 'validations' do
    context 'with no visitor_id' do
      let(:attributes) { { visitor_id: nil } }

      it 'requires a visitor_id' do
        expect(simulation).not_to be_valid
        expect(simulation.errors[:visitor_id]).to be_present
      end
    end

    context 'with no bet types' do
      let(:attributes) { { bet_type_keys: [] } }

      it 'requires at least one bet type' do
        expect(simulation).not_to be_valid
        expect(simulation.errors[:bet_type_keys]).to be_present
      end
    end

    context 'with a bet type key outside the known set' do
      let(:attributes) { { bet_type_keys: %w[sports_singles made_up_game] } }

      it 'rejects the unknown key' do
        expect(simulation).not_to be_valid
        expect(simulation.errors[:bet_type_keys]).to be_present
      end
    end

    context 'with a blank weekly_amount_cents' do
      let(:attributes) { { weekly_amount_cents: nil } }

      it { is_expected.not_to be_valid }
    end

    context 'with a zero weekly_amount_cents' do
      let(:attributes) { { weekly_amount_cents: 0 } }

      it { is_expected.not_to be_valid }
    end

    context 'with a blank timeframe_weeks' do
      let(:attributes) { { timeframe_weeks: nil } }

      it { is_expected.not_to be_valid }
    end

    context 'with a zero timeframe_weeks' do
      let(:attributes) { { timeframe_weeks: 0 } }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#to_param' do
    subject(:simulation) { create(:simulation) }

    it 'exposes the uuid as its route param, never the sequential id' do
      expect(simulation.to_param).to eq(simulation.uuid)
      expect(simulation.to_param).not_to eq(simulation.id.to_s)
    end
  end
end
