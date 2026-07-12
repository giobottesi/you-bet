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

  # FE-09 harm-reduction support resources — always visible on results. URLs/short-code verified
  # against each official primary source (see PR). Prose lives in i18n; only stable data lives here.
  HELP_RESOURCES = [
    { key: :cvv, url: 'https://cvv.org.br/', phone: '188' },
    { key: :sus_caps, url: 'https://www.gov.br/saude/pt-br/composicao/saes/desmad/raps/caps' },
    { key: :gamblers_anonymous, url: 'https://jogadoresanonimos.com.br/' },
    { key: :self_exclusion,
      url: 'https://www.gov.br/fazenda/pt-br/composicao/orgaos/secretaria-de-premios-e-apostas/autoexclusao' }
  ].freeze

  # Keeps the partial free of constant lookups (mirrors timeframe_slots).
  def help_resources
    HELP_RESOURCES
  end

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

  # Canonical R$ label for a cents amount, e.g. 1200 -> "R$12". Precision defaults to whole reais.
  def reais_label(cents, precision: 0)
    number_to_currency(cents / 100.0, unit: 'R$', precision: precision, format: '%u%n')
  end

  # Weekly-spend label — the form's cents-to-R$ formatter, kept as a named alias for its callsites.
  def weekly_amount_label(cents, precision: 0)
    reais_label(cents, precision: precision)
  end

  # House edge as a percentage label, e.g. 0.06 -> "6%". Nil when the ReferenceValue isn't seeded.
  def house_edge_label(bet_type)
    edge = bet_type.house_edge_value
    return if edge.nil?

    number_to_percentage(edge * 100, precision: edge < 0.1 ? 2 : 0, strip_insignificant_zeros: true)
  end

  # Localized horizon name, reusing the slider's slot i18n, e.g. 52 -> "1 year". Nil for an unknown span.
  def timeframe_label(timeframe_weeks)
    slot_key = TIMEFRAME_SLOTS.key(timeframe_weeks)
    return if slot_key.nil?

    t("simulations.timeframe_slider.slots.#{slot_key}")
  end

  # A loss fraction as a percentage label, e.g. 0.05 -> "5%".
  def loss_percentage_label(loss_fraction)
    number_to_percentage(loss_fraction * 100, precision: 1, strip_insignificant_zeros: true)
  end

  # An already-percentage value (e.g. 38.5) as a whole-percent label -> "39%".
  def whole_percentage_label(percentage)
    number_to_percentage(percentage, precision: 0)
  end

  # A comparison item as its localized, pluralized label, e.g. "31 pizzas" / "1 iPhone".
  def comparison_label(comparison)
    t("simulations.results.opportunity.items.#{comparison[:key]}", count: comparison[:quantity])
  end

  # The [bet_type, result] pair that loses the least at the horizon — the person's best-case pick.
  def best_case_result(bet_type_results, timeframe_weeks)
    bet_type_results.min_by { |_bet_type, result| result.loss_fraction(timeframe_weeks) }
  end

  # Loss fraction at each horizon for one result — the ramp that shows time is the enemy.
  def loss_timeline(result)
    MonteCarloSimulator::TIMEFRAMES.values.map do |weeks|
      { weeks: weeks, fraction: result.loss_fraction(weeks) }
    end
  end

  # FE-10 WhatsApp share — prefilled message carrying the on-brand text and the permalink.
  def whatsapp_share_url(permalink)
    message = "#{t('simulations.results.share.text')} #{permalink}"
    "https://wa.me/?text=#{ERB::Util.url_encode(message)}"
  end

  # FE-10 X/Twitter share — intent link with the text and permalink as separate params.
  def twitter_share_url(permalink)
    text = ERB::Util.url_encode(t('simulations.results.share.text'))
    url = ERB::Util.url_encode(permalink)
    "https://twitter.com/intent/tweet?text=#{text}&url=#{url}"
  end
end
