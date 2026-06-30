class ReferenceValue < ApplicationRecord
  scope :by_category, ->(category) { where(category: category) }

  def typed_value
    case value_type
    when 'integer' then value.to_i
    when 'float' then value.to_f
    else value
    end
  end
end
