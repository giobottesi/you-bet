module SimulationsHelper
  # Pop-art accent rotation — no two adjacent bet cards share a color (DESIGN.md locked rule).
  BET_CARD_ACCENTS = %w[coral cyan green purple yellow].freeze

  # Returns the rotated accent as a CSS var value for the card's --bet-accent (Tailwind can't see runtime class names).
  def bet_card_accent(index)
    "var(--color-#{BET_CARD_ACCENTS[index % BET_CARD_ACCENTS.size]})"
  end

  # DataSenado weekly-spend tiers (PROPOSAL.md) — comparison key => weekly amount in cents. Custom field covers exact amounts.
  WEEKLY_AMOUNT_ANCHORS = {
    streaming: 1200,
    two_pizzas: 2500,
    phone_installment: 5000,
    moto_installment: 12500
  }.freeze

  # FE-04 timeframe slots — slot key => horizon in weeks, matching MonteCarloSimulator's 5 timeframes (BE 10).
  TIMEFRAME_SLOTS = {
    one_month: 4,
    six_months: 26,
    one_year: 52,
    two_years: 104,
    five_years: 260
  }.freeze

  # Slot selected when the form loads — 1 year, the default horizon.
  TIMEFRAME_DEFAULT_INDEX = 2

  # Slider view helpers — keep the template free of constant lookups and JSON coercion.
  def timeframe_slots
    TIMEFRAME_SLOTS.to_a
  end

  def timeframe_default_index
    TIMEFRAME_DEFAULT_INDEX
  end

  def timeframe_weeks_json
    TIMEFRAME_SLOTS.values.to_json
  end

  # R$ label for a cents amount, e.g. 1200 -> "R$12". Precision defaults to whole reais.
  def weekly_amount_label(cents, precision: 0)
    number_to_currency(cents / 100.0, unit: 'R$', precision: precision, format: '%u%n')
  end

  # House edge as a percentage label, e.g. 0.06 -> "6%". Nil when the ReferenceValue isn't seeded.
  def house_edge_label(bet_type)
    edge = bet_type.house_edge_value
    return if edge.nil?

    number_to_percentage(edge * 100, precision: edge < 0.1 ? 2 : 0, strip_insignificant_zeros: true)
  end
end
