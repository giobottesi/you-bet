require 'rails_helper'

RSpec.describe ReferenceValue, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:value_type) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_inclusion_of(:value_type).in_array(%w[string integer float]) }

    it 'validates uniqueness of key' do
      ReferenceValue.create!(key: 'test', value: '1', value_type: 'integer', category: 'test')
      expect(ReferenceValue.new(key: 'test', value: '2', value_type: 'integer', category: 'test')).not_to be_valid
    end
  end

  describe '.get' do
    it 'returns a typed value by compound key' do
      ReferenceValue.create!(key: 'pizza_price_cents', value: '4000', value_type: 'integer', category: 'comparison')
      expect(ReferenceValue.get('pizza_price_cents')).to eq(4000)
    end

    it 'returns a float for house edges' do
      ReferenceValue.create!(key: 'sports_singles.house_edge', value: '0.06', value_type: 'float', category: 'bet_type')
      expect(ReferenceValue.get('sports_singles.house_edge')).to be_within(0.001).of(0.06)
    end

    it 'raises for missing key' do
      expect { ReferenceValue.get('nonexistent') }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '.by_category' do
    before do
      ReferenceValue.create!(key: 'price_a', value: '100', value_type: 'integer', category: 'comparison')
      ReferenceValue.create!(key: 'edge_a', value: '0.05', value_type: 'float', category: 'bet_type')
    end

    it 'filters by category' do
      expect(ReferenceValue.by_category('comparison').pluck(:key)).to eq([ 'price_a' ])
      expect(ReferenceValue.by_category('bet_type').pluck(:key)).to eq([ 'edge_a' ])
    end
  end

  describe 'seeds' do
    before { Rails.application.load_seed }

    it 'creates 10 comparison values' do
      expect(ReferenceValue.by_category('comparison').count).to eq(10)
    end

    it 'creates 7 bet type house edges' do
      expect(ReferenceValue.by_category('bet_type').count).to eq(7)
    end

    it 'loads pizza price as integer' do
      expect(ReferenceValue.get('pizza_price_cents')).to eq(4000)
    end

    it 'loads sports singles house edge as float' do
      expect(ReferenceValue.get('sports_singles.house_edge')).to be_within(0.001).of(0.06)
    end

    it 'is idempotent' do
      Rails.application.load_seed
      expect(ReferenceValue.where(key: 'pizza_price_cents').count).to eq(1)
    end
  end
end
