class ReferenceValueUpsert
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :key, :string
  attribute :value, :string
  attribute :value_type, :string, default: 'string'
  attribute :category, :string
  attribute :bet_type, :string
  attribute :description, :string
  attribute :data_source, :string

  validates :key, presence: true
  validates :value, presence: true
  validates :value_type, presence: true, inclusion: { in: %w[string integer float] }
  validates :category, presence: true

  def self.upsert!(attrs)
    new(**attrs).upsert
  end

  def upsert
    return false unless valid?

    reference_value.assign_attributes(
      value: value,
      value_type: value_type,
      category: category,
      description: description,
      data_source: data_source
    )

    reference_value.save
  end

  private

  def reference_value
    @reference_value ||= ReferenceValue.find_or_initialize_by(key: key, bet_type: bet_type)
  end
end
