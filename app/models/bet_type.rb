class BetType
  include ActiveModel::Model
  include ActiveModel::Attributes

  BETTING_TYPES = %w[
    sports_singles
    slots_tigrinho
    crash_aviator
    accumulator_3
    accumulator_5
    roulette
    lottery
  ].freeze

  attribute :key, :string
  validates :key, presence: true

  def self.all
    BETTING_TYPES.map { |key| new(key: key) }
  end

  def self.create(key:, house_edge:, description:, data_source:)
    ReferenceValueUpsert.upsert(
      bet_type: key, key: 'house_edge', value: house_edge.to_s, value_type: 'float',
      category: 'bet_type', description: description, data_source: data_source
    )
  end

  def house_edge_value
    @house_edge ||= ReferenceValue.find_by(bet_type: key, key: 'house_edge')&.typed_value
  end

  def display_name(locale = I18n.locale)
    I18n.t("bet_types.#{key}", locale: locale, default: key.humanize)
  end
end
