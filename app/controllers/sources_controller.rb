class SourcesController < ContentController
  # Verified research sources behind the app's figures (docs/DATA.md — Research Source Citations).
  # name + deep link stay as citation data; provides/figures are localized prose (sources.data.<key>.*).
  DATA_SOURCES = [
    { key: 'bcb', name: 'Banco Central — Estudo Especial nº 119',
      url: 'https://www.bcb.gov.br/conteudo/relatorioinflacao/EstudosEspeciais/EE119_Analise_tecnica_sobre_o_mercado_de_apostas_online_no_Brasil_e_o_perfil_dos_apostadores.pdf' },
    { key: 'datasenado', name: 'DataSenado — quem aposta no Brasil (2024)',
      url: 'https://www.senado.leg.br/institucional/datasenado/relatorio_online/pesquisa_aposta_esportiva/2024/interativo.html' },
    { key: 'cnc', name: 'CNC — bets & family debt',
      url: 'https://portaldocomercio.org.br/diario-executivo/para-cnc-bets-agravam-endividamento-das-familias-brasileiras/' },
    { key: 'unifesp', name: 'UNIFESP / LENAD III (FAPESP)',
      url: 'https://revistapesquisa.fapesp.br/quase-11-milhoes-de-brasileiros-apostam-de-modo-a-por-em-risco-a-saude-e-as-financas/' },
    { key: 'ibevar', name: 'Ibevar/FIA (2026)',
      url: 'https://www.infomoney.com.br/politica/apostas-online-superam-juros-como-fator-de-endividamento-no-brasil-mostra-estudo/' },
    { key: 'inss', name: 'INSS / Intercept — "Do tigrinho ao INSS"',
      url: 'https://www.intercept.com.br/2025/06/25/bets-auxilios-doenca-vicio-em-jogos-brasil/' },
    { key: 'atlasintel', name: 'AtlasIntel / Latam Pulse (Apr 2026)',
      url: 'https://atlasintel.org/poll/latam-pulse-brazil-april-2026-2026-04-30' }
  ].freeze

  # Order per note; prose localized (sources.notes.*). A note only cites a source NOT already shown as a card
  # above — BCB/DataSenado/CNC are cards, so they aren't re-linked here; Bolsa Família is the one added source.
  # PG Soft's Fortune Tiger RTP link is parked (the primary page 404s); IBJR has no self-hosted rebuttal to cite.
  METHODOLOGICAL_NOTES = [
    { key: 'bettor_count' },
    { key: 'cnc_contested' },
    { key: 'tigrinho_edge' },
    { key: 'bolsa_familia', citations: [
      { label: 'gov.br — Bolsa Família', url: 'https://www.gov.br/mds/pt-br/acoes-e-programas/bolsa-familia' }
    ] }
  ].freeze

  def index
    @data_sources = DATA_SOURCES
    @methodological_notes = METHODOLOGICAL_NOTES
  end
end
