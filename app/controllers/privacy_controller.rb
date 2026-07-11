class PrivacyController < ContentController
  # Categories of data the app records, in plain LGPD terms (single source of truth for the notice).
  COLLECTED_DATA_KEYS = %i[visitor_cookie simulation_inputs language_preference].freeze

  # External references linked at the foot of the notice (label key => official source URL).
  REFERENCE_LINKS = {
    lgpd: 'https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm',
    anpd_cookies: 'https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia-orientativo-cookies-e-protecao-de-dados-pessoais.pdf'
  }.freeze

  def show
    @collected_data_keys = COLLECTED_DATA_KEYS
    @reference_links = REFERENCE_LINKS
  end
end
