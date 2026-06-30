module SeedData
  # System-level constants (Monte Carlo params, rates, retention).
  SEED_DEFAULTS = [
    { key: 'monte_carlo_sims', value: '1000', value_type: 'integer',
      description: 'Number of Monte Carlo simulations per request',
      data_source: 'internal' },
    { key: 'poupanca_monthly_rate', value: '0.0067', value_type: 'decimal',
      description: 'Monthly savings account yield (poupança)',
      data_source: 'BCB Selic/TR' },
    { key: 'minimum_wage_cents', value: '162100', value_type: 'integer',
      description: 'Current Brazilian minimum wage in cents',
      data_source: 'Decreto federal 2026' },
    { key: 'data_retention_days', value: '180', value_type: 'integer',
      description: 'Days to retain anonymous simulation data',
      data_source: 'internal (LGPD policy)' }
  ].freeze

  # Externally-sourced comparison prices (cents), each cited.
  SEED_COMPARISON_VALUES = [
    { key: 'pizza_price_cents', value: '4000', value_type: 'integer', category: 'comparison',
      description: 'Average delivery pizza price',
      data_source: 'iFood avg delivery, Jun 2026' },
    { key: 'iphone_price_cents', value: '550000', value_type: 'integer', category: 'comparison',
      description: 'iPhone price in Brazil',
      data_source: 'Apple BR store, Jun 2026' },
    { key: 'smartphone_price_cents', value: '90000', value_type: 'integer', category: 'comparison',
      description: 'Budget smartphone price',
      data_source: 'Magazine Luiza Moto G, Jun 2026' },
    { key: 'cesta_basica_cents', value: '80000', value_type: 'integer', category: 'comparison',
      description: 'Monthly basic food basket',
      data_source: 'DIEESE Jun 2026' },
    { key: 'netflix_spotify_cents', value: '5500', value_type: 'integer', category: 'comparison',
      description: 'Monthly Netflix + Spotify bundle',
      data_source: 'Official pricing, Jun 2026' },
    { key: 'motorcycle_price_cents', value: '1000000', value_type: 'integer', category: 'comparison',
      description: 'Used Honda CG 160 average price',
      data_source: 'OLX Honda CG 160 avg, Jun 2026' },
    { key: 'rent_monthly_cents', value: '120000', value_type: 'integer', category: 'comparison',
      description: 'National average monthly rent',
      data_source: 'FipeZap national avg, Jun 2026' },
    { key: 'flight_price_cents', value: '80000', value_type: 'integer', category: 'comparison',
      description: 'Domestic flight average',
      data_source: 'Google Flights domestic avg' },
    { key: 'fridge_price_cents', value: '200000', value_type: 'integer', category: 'comparison',
      description: 'Average refrigerator price',
      data_source: 'Americanas avg, Jun 2026' },
    { key: 'course_price_cents', value: '250000', value_type: 'integer', category: 'comparison',
      description: 'Vocational tech course',
      data_source: 'SENAC avg tech course' }
  ].freeze

  # Bet type house edges — bet_type lives in its own column.
  SEED_BET_TYPE_VALUES = [
    { bet_type: 'sports_singles', key: 'house_edge', value: '0.06', value_type: 'float', category: 'bet_type',
      description: 'Sports singles bookmaker vigorish',
      data_source: 'Standard bookmaker vigorish' },
    { bet_type: 'accumulator_3', key: 'house_edge', value: '0.15', value_type: 'float', category: 'bet_type',
      description: '3-leg accumulator compounded margin',
      data_source: 'Compounding 5% per-leg margin' },
    { bet_type: 'accumulator_5', key: 'house_edge', value: '0.23', value_type: 'float', category: 'bet_type',
      description: '5-leg accumulator compounded margin',
      data_source: 'Compounding 5% per-leg margin' },
    { bet_type: 'slots_tigrinho', key: 'house_edge', value: '0.05', value_type: 'float', category: 'bet_type',
      description: 'Slots/Tigrinho adjusted RTP for unregulated platforms',
      data_source: 'PG Soft RTP adjusted for unregulated' },
    { bet_type: 'crash_aviator', key: 'house_edge', value: '0.04', value_type: 'float', category: 'bet_type',
      description: 'Crash/Aviator operator-configurable edge',
      data_source: 'Operator-configurable, conservative' },
    { bet_type: 'lottery', key: 'house_edge', value: '0.54', value_type: 'float', category: 'bet_type',
      description: 'Lottery prize pool retention',
      data_source: 'Caixa prize pool rules' },
    { bet_type: 'roulette', key: 'house_edge', value: '0.0526', value_type: 'float', category: 'bet_type',
      description: 'American roulette (38 pockets, pays as 36)',
      data_source: 'American: 38 pockets, pays as 36' }
  ].freeze
end
