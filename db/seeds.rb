# Idempotent — safe to run multiple times in any environment.

# --- AppConfig ---

AppConfig::DEFAULTS.each do |attributes|
  AppConfig.find_or_initialize_by(key: attributes[:key]).update!(attributes)
end
