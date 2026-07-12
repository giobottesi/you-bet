require 'rails_helper'

RSpec.describe 'Help', type: :request do
  describe 'GET /help' do
    before { get help_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the localized help heading' do
      expect(response.body).to include(CGI.escapeHTML(I18n.t('simulations.results.help.heading')))
    end

    # Crisis resources must be reachable without running a simulation.
    it 'lists every support resource with its outbound link' do
      helper = ApplicationController.helpers
      helper.help_resources.each do |resource|
        expect(response.body).to include("href=\"#{resource[:url]}\"")
        expect(response.body).to include(CGI.escapeHTML(I18n.t("simulations.results.help.resources.#{resource[:key]}.name")))
      end
    end
  end
end
