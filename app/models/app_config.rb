class AppConfig < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true
  validates :value_type, presence: true, inclusion: { in: %w[string integer float decimal] }
  validate :value_matches_type

  def self.fetch(key)
    find_by!(key: key).typed_value
  end

  def typed_value
    case value_type
    when "integer" then value.to_i
    when "float" then value.to_f
    when "decimal" then BigDecimal(value)
    else value
    end
  end

  private

  def value_matches_type
    return if value.blank?

    case value_type
    when "integer" then Integer(value)
    when "float" then Float(value)
    when "decimal" then BigDecimal(value)
    end
  rescue ArgumentError, TypeError
    errors.add(:value, "is not a valid #{value_type}")
  end
end
