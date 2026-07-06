require 'rails_helper'

RSpec.describe BetType do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
  end

  describe '.all' do
    it 'returns one value object per betting type' do
      expect(BetType.all.map(&:key)).to match_array(BetType::BETTING_TYPES)
    end

    it 'returns BetType instances' do
      expect(BetType.all).to all(be_a(BetType))
    end
  end

  describe '#house_edge_value' do
    let!(:reference_value) do
      create(:reference_value, bet_type: 'demo_type', key: 'house_edge', value: value, value_type: 'float', category: 'bet_type')
    end
    let(:value) { '0.06' }

    it 'reads the edge through the bet_type column' do
      expect(BetType.new(key: 'demo_type').house_edge_value).to be_within(0.001).of(0.06)
    end

    context 'when the edge is absent' do
      it 'returns nil' do
        expect(BetType.new(key: 'ghost_type').house_edge_value).to be_nil
      end
    end
  end

  describe '#display_name' do
    it 'returns the translated name for the requested locale' do
      expect(BetType.new(key: 'sports_singles').display_name(:en)).to eq('Sports singles')
      expect(BetType.new(key: 'sports_singles').display_name(:'pt-BR')).to eq('Apostas simples')
    end

    it 'humanizes the key when no translation exists' do
      expect(BetType.new(key: 'ghost_type').display_name(:en)).to eq('Ghost type')
    end
  end

  describe '.create' do
    it 'persists the house edge through the upsert command (whole chain)' do
      BetType.create(key: 'promo_type', house_edge: 0.54, description: 'Promo', data_source: 'test')
      expect(ReferenceValue.find_by(bet_type: 'promo_type', key: 'house_edge').typed_value).to be_within(0.001).of(0.54)
    end
  end
end
