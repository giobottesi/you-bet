class SourcesController < ContentController
  # Shared primary-source URLs — cited both as source cards and inline in the methodological notes.
  BCB_URL = 'https://www.bcb.gov.br/conteudo/relatorioinflacao/EstudosEspeciais/EE119_Analise_tecnica_sobre_o_mercado_de_apostas_online_no_Brasil_e_o_perfil_dos_apostadores.pdf'
  DATASENADO_URL = 'https://www.senado.leg.br/institucional/datasenado/relatorio_online/pesquisa_aposta_esportiva/2024/interativo.html'
  CNC_URL = 'https://portaldocomercio.org.br/diario-executivo/para-cnc-bets-agravam-endividamento-das-familias-brasileiras/'

  # Verified research sources behind the app's figures (docs/DATA.md — Research Source Citations).
  # name + deep link stay as citation data; provides/figures are localized prose (sources.data.<key>.*).
  DATA_SOURCES = [
    { key: 'bcb', name: 'Banco Central — Estudo Especial nº 119', url: BCB_URL },
    { key: 'datasenado', name: 'DataSenado — quem aposta no Brasil (2024)', url: DATASENADO_URL },
    { key: 'cnc', name: 'CNC — bets & family debt', url: CNC_URL },
    { key: 'unifesp', name: 'UNIFESP / LENAD III (FAPESP)',
      url: 'https://revistapesquisa.fapesp.br/quase-11-milhoes-de-brasileiros-apostam-de-modo-a-por-em-risco-a-saude-e-as-financas/' },
    { key: 'ibevar', name: 'Ibevar/FIA (2026)',
      url: 'https://www.infomoney.com.br/politica/apostas-online-superam-juros-como-fator-de-endividamento-no-brasil-mostra-estudo/' },
    { key: 'inss', name: 'INSS / Intercept — "Do tigrinho ao INSS"',
      url: 'https://www.intercept.com.br/2025/06/25/bets-auxilios-doenca-vicio-em-jogos-brasil/' },
    { key: 'atlasintel', name: 'AtlasIntel / Latam Pulse (Apr 2026)',
      url: 'https://atlasintel.org/poll/latam-pulse-brazil-april-2026-2026-04-30' }
  ].freeze

  # Order per note; prose localized (sources.notes.*). Every note cites its primary source (the "Fontes:" line).
  # The tigrinho-edge note was dropped: its only source (PG Soft's Fortune Tiger RTP) can't be verified — the
  # page 404s — so an unverifiable note has no place on a "verified sources" page.
  METHODOLOGICAL_NOTES = [
    { key: 'bettor_count', citations: [
      { label: 'Banco Central — EE119', url: BCB_URL },
      { label: 'DataSenado', url: DATASENADO_URL }
    ] },
    { key: 'cnc_contested', citations: [
      { label: 'CNC', url: CNC_URL }
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
