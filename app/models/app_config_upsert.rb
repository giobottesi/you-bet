class AppConfigUpsert
  include ActiveModel::Model
  include ActiveModel::Attributes

  VALUE_TYPES = %w[string integer float decimal].freeze

  attribute :key, :string
  attribute :value, :string
  attribute :value_type, :string, default: 'string'
  attribute :description, :string
  attribute :data_source, :string

  validates :key, presence: true
  validates :value, presence: true
  validates :value_type, presence: true, inclusion: { in: VALUE_TYPES }

  def self.upsert(attrs)
    new(**attrs).upsert
  end

  def upsert
    return false unless valid?

    app_config.assign_attributes(
      value: value,
      value_type: value_type,
      description: description,
      data_source: data_source
    )

    app_config.save
  end

  private

  def app_config
    @app_config ||= AppConfig.find_or_initialize_by(key: key)
  end
end
