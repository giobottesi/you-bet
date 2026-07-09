class SourcesController < ContentController
  # Verified research sources behind the app's figures (docs/PROPOSAL.md — Data Sources).
  # Names and figures stay as data (citations); page chrome is localized.
  DATA_SOURCES = [
    { name: 'Banco Central — Estudo Especial nº 119',
      provides: 'Financial flows, market size',
      figures: 'R$18-21 bi/month via Pix, ~24M bettors, R$3 bi from Bolsa Família' },
    { name: 'DataSenado — Panorama Político 2024',
      provides: 'Bettor demographics, spending, debt',
      figures: '52% earn ≤2 minimum wages, 42% have 90+ day debt, spending tiers' },
    { name: 'CNC — PEIC',
      provides: 'Family debt trends',
      figures: '+500% spending growth in 3 years, ~270K families defaulted' },
    { name: 'UNIFESP / LENAD III',
      provides: 'Clinical gambling behavior',
      figures: '10.9M at-risk, 66.8% of digital bettors show problem behavior' },
    { name: 'Ibevar/FIA (2026)',
      provides: 'Debt regression analysis',
      figures: 'Betting impact 3x greater than interest rates' },
    { name: 'INSS via Intercept Brasil',
      provides: 'Ludopatia benefits',
      figures: '+2,300% growth in gambling disorder benefits' },
    { name: 'AtlasIntel / Latam Pulse (Apr 2026)',
      provides: 'Public perception',
      figures: '86% consider bets harmful, 70% support a ban' }
  ].freeze

  # Where sourced figures were reconciled or adjusted (docs/PROPOSAL.md — Methodological Notes).
  METHODOLOGICAL_NOTES = [
    { subject: 'BCB vs DataSenado bettor count',
      note: 'BCB says ~24M (Pix data), DataSenado says 22M (survey). We use "22-24 million" and explain the difference.' },
    { subject: 'Tigrinho house edge',
      note: 'PG Soft claims 96.81% RTP, but unregulated platforms can set lower RTPs. We use 5% as a conservative middle ground and disclose it transparently.' }
  ].freeze

  def index
    @data_sources = DATA_SOURCES
    @methodological_notes = METHODOLOGICAL_NOTES
  end
end
