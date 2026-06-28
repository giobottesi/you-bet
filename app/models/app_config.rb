class AppConfig < ApplicationRecord
  VALUE_TYPES = %w[string integer float decimal].freeze

  SEED_DEFAULTS = [
    { key: "monte_carlo_sims", value: "1000", value_type: "integer",
      description: "Number of Monte Carlo simulations per request",
      data_source: "internal" },
    { key: "poupanca_monthly_rate", value: "0.0067", value_type: "decimal",
      description: "Monthly savings account yield (poupança)",
      data_source: "BCB Selic/TR" },
    { key: "minimum_wage_cents", value: "162100", value_type: "integer",
      description: "Current Brazilian minimum wage in cents",
      data_source: "Decreto federal 2026" },
    { key: "data_retention_days", value: "180", value_type: "integer",
      description: "Days to retain anonymous simulation data",
      data_source: "internal (LGPD policy)" }
  ].freeze

  validates :key, presence: true, uniqueness: true
  validates :value, presence: true
  validates :value_type, presence: true, inclusion: { in: VALUE_TYPES }

  def self.fetch(key)
    find_by!(key: key).typed_value
  end

  def typed_value
    case value_type
    when "integer" then value.to_i
    when "float" then value.to_f
    when "decimal" then BigDecimal(value)
    else value
    end
  end
end
