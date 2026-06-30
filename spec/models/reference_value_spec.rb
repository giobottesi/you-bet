require 'rails_helper'

RSpec.describe ReferenceValue, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:value_type) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_inclusion_of(:value_type).in_array(%w[string integer float]) }

    context 'when key is not unique' do
      let!(:reference_value) { create(:reference_value, key: key) }
      let(:duplicate) { build(:reference_value, key: key) }
      let(:key) { 'duplicate_demo_key' }

      it 'is invalid' do
        expect(duplicate.valid?).to be false
      end
    end
  end

  describe '#typed_value' do
    let(:reference_value) { build(:reference_value, value: value, value_type: value_type) }
    let(:value) { '4000' }
    let(:value_type) { 'integer' }

    it 'casts an integer' do
      expect(reference_value.typed_value).to eq(4000)
    end

    context 'when value_type is float' do
      let(:value) { '0.06' }
      let(:value_type) { 'float' }

      it 'casts a float' do
        expect(reference_value.typed_value).to be_within(0.001).of(0.06)
      end
    end

    context 'when value_type is string' do
      let(:value) { 'hello' }
      let(:value_type) { 'string' }

      it 'returns the raw string' do
        expect(reference_value.typed_value).to eq('hello')
      end
    end
  end

  describe '.by_category' do
    let!(:in_group) { create(:reference_value, key: 'group_a_key', category: 'group_a') }
    let!(:other_group) { create(:reference_value, key: 'group_b_key', category: 'group_b') }

    it 'returns only records in the category' do
      expect(ReferenceValue.by_category('group_a')).to contain_exactly(in_group)
      expect(ReferenceValue.by_category('group_b')).to contain_exactly(other_group)
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

    it 'loads pizza price as an integer' do
      expect(ReferenceValue.find_by(key: 'pizza_price_cents').typed_value).to eq(4000)
    end

    it 'is idempotent' do
      Rails.application.load_seed
      expect(ReferenceValue.where(key: 'pizza_price_cents').count).to eq(1)
    end
  end
end
