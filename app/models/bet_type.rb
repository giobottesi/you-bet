class BetType
  TYPES = %w[
    sports_singles
    accumulator_3
    accumulator_5
    slots_tigrinho
    crash_aviator
    lottery
    roulette
  ].freeze

  attr_reader :key

  def initialize(key)
    raise ArgumentError, "Unknown bet type: #{key}" unless TYPES.include?(key)
    @key = key
  end

  def house_edge
    ReferenceValue.get("#{key}.house_edge")
  end

  def display_name(locale = I18n.locale)
    I18n.t("bet_types.#{key}", locale: locale, default: key.humanize)
  end

  def self.all
    TYPES.map { |key| new(key) }
  end

  def self.find(key)
    new(key)
  end
end
