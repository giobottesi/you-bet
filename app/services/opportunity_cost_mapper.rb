class OpportunityCostMapper
  include ActiveModel::Model
  include ActiveModel::Attributes

  RANDOM_COMPARISON_COUNT = 3

  attribute :loss_cents, :integer
  attribute :poupanca_balance_cents, :integer

  def self.run(**attributes)
    new(**attributes).run
  end

  def run
    affordable_comparisons.sample(RANDOM_COMPARISON_COUNT) << poupanca_comparison
  end

  private

  def affordable_comparisons
    ReferenceValue.by_category('comparison').filter_map { |reference_value| comparison_for(reference_value) }
  end

  def comparison_for(reference_value)
    price_cents = reference_value.typed_value
    quantity = loss_cents.abs / price_cents

    return if quantity < 1

    {
      key: reference_value.key,
      description: reference_value.description,
      price_cents: price_cents,
      quantity: quantity
    }
  end

  def poupanca_comparison
    {
      key: 'poupanca',
      description: 'rendendo na poupança',
      price_cents: nil,
      quantity: nil,
      balance_cents: poupanca_balance_cents
    }
  end
end
