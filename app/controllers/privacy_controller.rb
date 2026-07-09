class PrivacyController < ContentController
  # Categories of data the app records, in plain LGPD terms (single source of truth for the notice).
  COLLECTED_DATA_KEYS = %i[visitor_cookie simulation_inputs language_preference].freeze

  def show
    @collected_data_keys = COLLECTED_DATA_KEYS
  end
end
