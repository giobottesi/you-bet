# Idempotent — safe to run multiple times in any environment.

# --- AppConfig ---

[
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
].each do |attributes|
  AppConfig.find_or_initialize_by(key: attributes[:key]).update!(attributes)
end
