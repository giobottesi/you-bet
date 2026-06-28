require "rails_helper"

RSpec.describe AppConfig, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:value_type) }
    it { is_expected.to validate_inclusion_of(:value_type).in_array(AppConfig::VALUE_TYPES) }

    it "validates uniqueness of key" do
      AppConfig.create!(key: "test_key", value: "1", value_type: "string")
      expect(AppConfig.new(key: "test_key", value: "2", value_type: "string")).not_to be_valid
    end
  end

  describe ".fetch" do
    it "returns an integer for integer value_type" do
      AppConfig.create!(key: "sim_count", value: "1000", value_type: "integer")
      expect(AppConfig.fetch("sim_count")).to eq(1000)
    end

    it "returns a float for float value_type" do
      AppConfig.create!(key: "rate", value: "0.0067", value_type: "float")
      expect(AppConfig.fetch("rate")).to be_within(0.0001).of(0.0067)
    end

    it "returns a BigDecimal for decimal value_type" do
      AppConfig.create!(key: "precise_rate", value: "0.0067", value_type: "decimal")
      expect(AppConfig.fetch("precise_rate")).to eq(BigDecimal("0.0067"))
    end

    it "returns a string for string value_type" do
      AppConfig.create!(key: "label", value: "hello", value_type: "string")
      expect(AppConfig.fetch("label")).to eq("hello")
    end

    it "raises ActiveRecord::RecordNotFound for missing key" do
      expect { AppConfig.fetch("nonexistent") }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "seeds" do
    before { Rails.application.load_seed }

    it "creates monte_carlo_sims as integer" do
      expect(AppConfig.fetch("monte_carlo_sims")).to eq(1000)
    end

    it "creates poupanca_monthly_rate as BigDecimal" do
      expect(AppConfig.fetch("poupanca_monthly_rate")).to eq(BigDecimal("0.0067"))
    end

    it "creates minimum_wage_cents as integer" do
      expect(AppConfig.fetch("minimum_wage_cents")).to eq(162_100)
    end

    it "creates data_retention_days as integer" do
      expect(AppConfig.fetch("data_retention_days")).to eq(180)
    end

    it "is idempotent" do
      Rails.application.load_seed
      expect(AppConfig.where(key: "monte_carlo_sims").count).to eq(1)
    end
  end
end
