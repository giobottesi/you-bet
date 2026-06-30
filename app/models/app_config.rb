class AppConfig < ApplicationRecord
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
