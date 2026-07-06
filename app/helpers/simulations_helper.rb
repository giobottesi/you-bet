module SimulationsHelper
  # Pop-art accent rotation — no two adjacent bet cards share a color (DESIGN.md locked rule).
  BET_CARD_ACCENTS = %w[coral cyan green purple yellow].freeze

  # Returns the rotated accent as a CSS var value for the card's --bet-accent (Tailwind can't see runtime class names).
  def bet_card_accent(index)
    "var(--color-#{BET_CARD_ACCENTS[index % BET_CARD_ACCENTS.size]})"
  end

  # House edge as a percentage label, e.g. 0.06 -> "6%". Nil when the ReferenceValue isn't seeded.
  def house_edge_label(bet_type)
    edge = bet_type.house_edge_value
    return if edge.nil?

    number_to_percentage(edge * 100, precision: edge < 0.1 ? 2 : 0, strip_insignificant_zeros: true)
  end
end
