class SourcesController < ContentController
  # Verified research sources behind the app's figures (docs/DATA.md — Research Source Citations).
  # Names, figures, and deep links stay as data (citations); page chrome is localized.
  # Figures audited against each primary source; a few were re-attributed/reworded from the challenge kit.
  DATA_SOURCES = [
    { name: 'Banco Central — Estudo Especial nº 119',
      provides: 'Financial flows, market size',
      figures: 'R$18-21 bi/month via Pix (2024); 5 million people in Bolsa Família households sent R$3 bi to bets',
      url: 'https://www.bcb.gov.br/conteudo/relatorioinflacao/EstudosEspeciais/EE119_Analise_tecnica_sobre_o_mercado_de_apostas_online_no_Brasil_e_o_perfil_dos_apostadores.pdf' },
    { name: 'DataSenado — quem aposta no Brasil (2024)',
      provides: 'Bettor demographics, spending, debt',
      figures: '22.1M bet in the last month; 52% earn ≤2 minimum wages; 42% carry 90+ day debt',
      url: 'https://www.senado.leg.br/institucional/datasenado/relatorio_online/pesquisa_aposta_esportiva/2024/interativo.html' },
    # R$30 bi/month is CNC's figure — corrected here from the kit, which attributed it to BCB.
    { name: 'CNC — bets & family debt',
      provides: 'Family debt trends',
      figures: 'Over R$30 bi/month; +500% spending growth in 3 years; ~269K families in severe default',
      url: 'https://portaldocomercio.org.br/diario-executivo/para-cnc-bets-agravam-endividamento-das-familias-brasileiras/' },
    { name: 'UNIFESP / LENAD III (FAPESP)',
      provides: 'Clinical gambling behavior',
      figures: '10.9M at-risk gamblers (6.8% of ages 14+); 66.8% of bettors show risky or problem gambling',
      url: 'https://revistapesquisa.fapesp.br/quase-11-milhoes-de-brasileiros-apostam-de-modo-a-por-em-risco-a-saude-e-as-financas/' },
    { name: 'Ibevar/FIA (2026)',
      provides: 'Debt regression analysis',
      figures: 'Debt-driver coefficient: bets 0.2255 vs interest 0.0709 — bets weigh roughly 3x',
      url: 'https://www.infomoney.com.br/politica/apostas-online-superam-juros-como-fator-de-endividamento-no-brasil-mostra-estudo/' },
    { name: 'INSS / Intercept — "Do tigrinho ao INSS"',
      provides: 'Ludopatia benefits',
      figures: '+2,300% monthly ludopatia benefits (2023 to 2025); 73% of beneficiaries are men',
      url: 'https://www.intercept.com.br/2025/06/25/bets-auxilios-doenca-vicio-em-jogos-brasil/' },
    { name: 'AtlasIntel / Latam Pulse (Apr 2026)',
      provides: 'Public perception',
      figures: '86.7% consider bets harmful; 70% support a total ban; 76% want ad limits; 85.2% link bets to family debt',
      url: 'https://atlasintel.org/poll/latam-pulse-brazil-april-2026-2026-04-30' }
  ].freeze

  # Order + primary-source citations per note; the prose is localized (sources.notes.*).
  # BCB/DataSenado/CNC URLs mirror DATA_SOURCES above (same verified primaries, cited here as inline references).
  # IBJR has no self-hosted rebuttal to link (only trade-press coverage) — omitted rather than cite a non-primary.
  METHODOLOGICAL_NOTES = [
    { key: 'bettor_count', citations: [
      { label: 'Banco Central — EE119', url: 'https://www.bcb.gov.br/conteudo/relatorioinflacao/EstudosEspeciais/EE119_Analise_tecnica_sobre_o_mercado_de_apostas_online_no_Brasil_e_o_perfil_dos_apostadores.pdf' },
      { label: 'DataSenado', url: 'https://www.senado.leg.br/institucional/datasenado/relatorio_online/pesquisa_aposta_esportiva/2024/interativo.html' }
    ] },
    { key: 'cnc_contested', citations: [
      { label: 'CNC', url: 'https://portaldocomercio.org.br/diario-executivo/para-cnc-bets-agravam-endividamento-das-familias-brasileiras/' }
    ] },
    { key: 'tigrinho_edge', citations: [
      { label: 'PG Soft — Fortune Tiger RTP', url: 'https://www.pgsoft.com/en/games/110/' }
    ] },
    { key: 'bolsa_familia', citations: [
      { label: 'gov.br — Bolsa Família', url: 'https://www.gov.br/mds/pt-br/acoes-e-programas/bolsa-familia' }
    ] }
  ].freeze

  def index
    @data_sources = DATA_SOURCES
    @methodological_notes = METHODOLOGICAL_NOTES
  end
end
