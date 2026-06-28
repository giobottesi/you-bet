class ReferenceValue < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true
  validates :value_type, presence: true, inclusion: { in: %w[string integer float] }
  validates :category, presence: true

  scope :by_category, ->(category) { where(category: category) }

  SEED_COMPARISON_VALUES = [
  { key: 'pizza_price_cents', value: '4000', value_type: 'integer', category: 'comparison',
    description: 'Average delivery pizza price',
    data_source: 'iFood avg delivery, Jun 2026' },
  { key: 'iphone_price_cents', value: '550000', value_type: 'integer', category: 'comparison',
    description: 'iPhone price in Brazil',
    data_source: 'Apple BR store, Jun 2026' },
  { key: 'smartphone_price_cents', value: '90000', value_type: 'integer', category: 'comparison',
    description: 'Budget smartphone price',
    data_source: 'Magazalu Moto G, Jun 2026' },
  { key: 'cesta_basica_cents', value: '80000', value_type: 'integer', category: 'comparison',
    description: 'Monthly basic food basket',
    data_source: 'DIEESE Jun 2026' },
  { key: 'netflix_spotify_cents', value: '5500', value_type: 'integer', category: 'comparison',
    description: 'Monthly Netflix + Spotify bundle',
    data_source: 'Official pricing, Jun 2026' },
  { key: 'motorcycle_price_cents', value: '1000000', value_type: 'integer', category: 'comparison',
    description: 'Used Honda CG 160 average price',
    data_source: 'OLX Honda CG 160 avg, Jun 2026' },
  { key: 'rent_monthly_cents', value: '120000', value_type: 'integer', category: 'comparison',
    description: 'National average monthly rent',
    data_source: 'FipeZap national avg, Jun 2026' },
  { key: 'flight_price_cents', value: '80000', value_type: 'integer', category: 'comparison',
    description: 'Domestic flight average',
    data_source: 'Google Flights domestic avg' },
  { key: 'fridge_price_cents', value: '200000', value_type: 'integer', category: 'comparison',
    description: 'Average refrigerator price',
    data_source: 'Americanas avg, Jun 2026' },
  { key: 'course_price_cents', value: '250000', value_type: 'integer', category: 'comparison',
    description: 'Vocational tech course',
    data_source: 'SENAC avg tech course' }
].freeze

  SEED_BET_TYPE_VALUES = [
  { key: 'sports_singles.house_edge', value: '0.06', value_type: 'float', category: 'bet_type',
    description: 'Sports singles bookmaker vigorish',
    data_source: 'Standard bookmaker vigorish' },
  { key: 'accumulator_3.house_edge', value: '0.15', value_type: 'float', category: 'bet_type',
    description: '3-leg accumulator compounded margin',
    data_source: 'Compounding 5% per-leg margin' },
  { key: 'accumulator_5.house_edge', value: '0.23', value_type: 'float', category: 'bet_type',
    description: '5-leg accumulator compounded margin',
    data_source: 'Compounding 5% per-leg margin' },
  { key: 'slots_tigrinho.house_edge', value: '0.05', value_type: 'float', category: 'bet_type',
    description: 'Slots/Tigrinho adjusted RTP for unregulated platforms',
    data_source: 'PG Soft RTP adjusted for unregulated' },
  { key: 'crash_aviator.house_edge', value: '0.04', value_type: 'float', category: 'bet_type',
    description: 'Crash/Aviator operator-configurable edge',
    data_source: 'Operator-configurable, conservative' },
  { key: 'lottery.house_edge', value: '0.54', value_type: 'float', category: 'bet_type',
    description: 'Lottery prize pool retention',
    data_source: 'Caixa prize pool rules' },
  { key: 'roulette.house_edge', value: '0.0526', value_type: 'float', category: 'bet_type',
    description: 'American roulette (38 pockets, pays as 36)',
    data_source: 'American: 38 pockets, pays as 36' }
].freeze

  def self.get(compound_key)
    record = find_by!(key: compound_key)
    record.typed_value
  end

  def typed_value
    case value_type
    when 'integer' then value.to_i
    when 'float' then value.to_f
    else value
    end
  end
end
