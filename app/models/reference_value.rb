class ReferenceValue < ApplicationRecord
  validates :key, presence: true, uniqueness: { scope: :bet_type }
  validates :value, presence: true
  validates :value_type, presence: true, inclusion: { in: %w[string integer float] }
  validates :category, presence: true

  scope :by_category, ->(category) { where(category: category) }

  def typed_value
    case value_type
    when 'integer' then value.to_i
    when 'float' then value.to_f
    else value
    end
  end
end
