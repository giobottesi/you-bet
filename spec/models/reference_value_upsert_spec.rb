require 'rails_helper'

RSpec.describe ReferenceValueUpsert do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_inclusion_of(:value_type).in_array(%w[string integer float]) }
  end

  describe '#upsert' do
    let(:command) { described_class.new(attributes) }
    let(:attributes) do
      { bet_type: 'phantom_type', key: 'house_edge', value: '0.05', value_type: 'float', category: 'bet_type' }
    end

    it 'persists a reference value (whole chain)' do
      command.upsert
      expect(ReferenceValue.find_by(bet_type: 'phantom_type', key: 'house_edge').typed_value).to be_within(0.0001).of(0.05)
    end

    it 'updates the existing (bet_type, key) instead of duplicating' do
      command.upsert
      described_class.new(attributes.merge(value: '0.09')).upsert
      expect(ReferenceValue.where(bet_type: 'phantom_type', key: 'house_edge').count).to eq(1)
      expect(ReferenceValue.find_by(bet_type: 'phantom_type', key: 'house_edge').typed_value).to be_within(0.0001).of(0.09)
    end

    it 'lets different bet types share the same key' do
      command.upsert
      described_class.new(attributes.merge(bet_type: 'other_type')).upsert
      expect(ReferenceValue.where(key: 'house_edge', bet_type: %w[phantom_type other_type]).count).to eq(2)
    end

    context 'with a comparison row (no bet_type)' do
      let(:attributes) do
        { key: 'test_price_cents', value: '4000', value_type: 'integer', category: 'comparison' }
      end

      it 'persists with a nil bet_type' do
        command.upsert
        expect(ReferenceValue.find_by(key: 'test_price_cents').bet_type).to be_nil
      end
    end

    context 'when value is missing' do
      let(:attributes) do
        { bet_type: 'phantom_type', key: 'house_edge', value_type: 'float', category: 'bet_type' }
      end

      it 'returns false with an error and persists nothing' do
        expect(command.upsert).to be false
        expect(command.errors[:value]).to be_present
        expect(ReferenceValue.where(bet_type: 'phantom_type', key: 'house_edge')).to be_empty
      end
    end
  end
end
