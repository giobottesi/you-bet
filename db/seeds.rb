# Idempotent — safe to run multiple times in any environment.

# --- AppConfig ---

SeedData::SEED_DEFAULTS.each do |attributes|
  AppConfig.find_or_initialize_by(key: attributes[:key]).update!(attributes)
end

# --- ReferenceValues: comparison prices ---

SeedData::SEED_COMPARISON_VALUES.each do |attributes|
  ReferenceValueUpsert.upsert(attributes)
end

# --- ReferenceValues: bet type house edges ---

SeedData::SEED_BET_TYPE_VALUES.each do |attributes|
  ReferenceValueUpsert.upsert(attributes)
end
