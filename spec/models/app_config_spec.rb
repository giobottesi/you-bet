require 'rails_helper'

RSpec.describe AppConfig, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:value_type) }
    it { is_expected.to validate_inclusion_of(:value_type).in_array(AppConfig::VALUE_TYPES) }


    context 'when key is not unique' do
      let!(:app_config) { create(:app_config, key: key) }
      let(:duplicate_app_config) { build(:app_config, key: key) }
      let(:key) { 'random_key' }

      it 'validates uniqueness of key' do
        expect(duplicate_app_config.valid?).to be false
      end
    end
  end

  describe '.fetch' do
    let!(:app_config) { create(:app_config, key: key, value: value, value_type: value_type) }
    let(:key) { 'sim_count' }
    let(:value) { '1000' }
    let(:value_type) { 'integer' }

    it 'returns an integer for integer value_type' do
      expect(AppConfig.fetch('sim_count')).to eq(1000)
    end

    context 'when value_type is float' do
      let(:key) { 'rate' }
      let(:value) { '0.0067' }
      let(:value_type) { 'float' }

      it 'returns a float for float value_type' do
        expect(AppConfig.fetch('rate')).to be_within(0.0001).of(0.0067)
      end
    end

    context 'when value_type is BigDecimal' do
      let(:key) { 'precise_rate' }
      let(:value) { '0.0067' }
      let(:value_type) { 'decimal' }

      it 'returns a BigDecimal for decimal value_type' do
        expect(AppConfig.fetch('precise_rate')).to eq(BigDecimal('0.0067'))
      end
    end

    context 'when value_type is string' do
      let(:key) { 'label' }
      let(:value) { 'hello' }
      let(:value_type) { 'string' }

      it 'returns a string for string value_type' do
        expect(AppConfig.fetch('label')).to eq('hello')
      end
    end

    context 'when key does not exists' do
      it 'raises ActiveRecord::RecordNotFound for missing key' do
        expect { AppConfig.fetch('nonexistent') }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'seeds' do
    before { Rails.application.load_seed }

    it 'creates monte_carlo_sims as integer' do
      expect(AppConfig.fetch('monte_carlo_sims')).to eq(1000)
    end

    it 'creates poupanca_monthly_rate as BigDecimal' do
      expect(AppConfig.fetch('poupanca_monthly_rate')).to eq(BigDecimal('0.0067'))
    end

    it 'creates minimum_wage_cents as integer' do
      expect(AppConfig.fetch('minimum_wage_cents')).to eq(162_100)
    end

    it 'creates data_retention_days as integer' do
      expect(AppConfig.fetch('data_retention_days')).to eq(180)
    end

    it 'is idempotent' do
      Rails.application.load_seed
      expect(AppConfig.where(key: 'monte_carlo_sims').count).to eq(1)
    end
  end
end
