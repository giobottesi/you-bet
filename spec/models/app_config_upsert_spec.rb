require 'rails_helper'

RSpec.describe AppConfigUpsert do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:value_type) }
    it { is_expected.to validate_inclusion_of(:value_type).in_array(AppConfigUpsert::VALUE_TYPES) }
  end

  describe '#upsert' do
    subject(:command) { described_class.new(attributes) }

    let(:attributes) do
      { key: 'demo_sim_count', value: '1000', value_type: 'integer' }
    end

    it 'persists an app config (whole chain)' do
      command.upsert
      expect(AppConfig.fetch('demo_sim_count')).to eq(1000)
    end

    it 'updates the existing key instead of duplicating' do
      command.upsert
      described_class.new(attributes.merge(value: '2000')).upsert
      expect(AppConfig.where(key: 'demo_sim_count').count).to eq(1)
      expect(AppConfig.fetch('demo_sim_count')).to eq(2000)
    end

    it 'casts a decimal value type' do
      described_class.new(key: 'demo_decimal_rate', value: '0.0067', value_type: 'decimal').upsert
      expect(AppConfig.fetch('demo_decimal_rate')).to eq(BigDecimal('0.0067'))
    end

    context 'when value is missing' do
      let(:attributes) { { key: 'demo_sim_count', value_type: 'integer' } }

      it 'returns false with an error and persists nothing' do
        expect(command.upsert).to be false
        expect(command.errors[:value]).to be_present
        expect(AppConfig.where(key: 'demo_sim_count')).to be_empty
      end
    end
  end
end
