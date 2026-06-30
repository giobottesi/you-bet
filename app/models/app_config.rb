class AppConfig < ApplicationRecord
  VALUE_TYPES = %w[string integer float decimal].freeze

  validates :key, presence: true, uniqueness: true
  validates :value, presence: true
  validates :value_type, presence: true, inclusion: { in: VALUE_TYPES }

  def self.fetch(key)
    find_by!(key: key).typed_value
  end

  def typed_value
    case value_type
    when 'integer' then value.to_i
    when 'float' then value.to_f
    when 'decimal' then BigDecimal(value)
    else value
    end
  end
end
