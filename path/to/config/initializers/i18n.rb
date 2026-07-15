# config/initializers/i18n.rb

# Configure I18n to use a translation management tool
I18n.config.available_locales = [:en, :pt_BR]
I18n.config.default_locale = :en
I18n.config.load_path = [
  Rails.root.join('config', 'locales', 'en.yml'),
  Rails.root.join('config', 'locales', 'pt-BR.yml')
]

# Use I18n keys in translation files
I18n.config.i18n_keys = true