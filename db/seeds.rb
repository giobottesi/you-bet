# Idempotent — safe to run multiple times in any environment.

# --- AppConfig ---

AppConfig::SEED_DEFAULTS.each do |attributes|
  AppConfig.find_or_initialize_by(key: attributes[:key]).update!(attributes)
end

# --- ReferenceValues: comparison prices ---

ReferenceValue::SEED_COMPARISON_VALUES.each do |attributes|
  ReferenceValue.find_or_initialize_by(key: attributes[:key]).update!(attributes)
end

# --- ReferenceValues: bet type house edges ---

ReferenceValue::SEED_BET_TYPE_VALUES.each do |attributes|
  ReferenceValue.find_or_initialize_by(key: attributes[:key]).update!(attributes)
end
