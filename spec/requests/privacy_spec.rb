require 'rails_helper'

RSpec.describe 'Privacy', type: :request do
  describe 'GET /privacy' do
    before { get privacy_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the localized page heading' do
      expect(response.body).to include(I18n.t('privacy.heading'))
    end

    it 'names every category of data it records' do
      PrivacyController::COLLECTED_DATA_KEYS.each do |key|
        expect(response.body).to include(I18n.t("privacy.collected.#{key}.name"))
      end
    end

    it 'presents the deletion instructions (LGPD acceptance)' do
      expect(response.body).to include(I18n.t('privacy.deletion.heading'))
      expect(response.body).to include(I18n.t('privacy.deletion.step_clear_cookie'))
    end
  end

  describe 'constants' do
    it 'covers the visitor cookie, simulation inputs, and language preference' do
      expect(PrivacyController::COLLECTED_DATA_KEYS).to eq(%i[visitor_cookie simulation_inputs language_preference])
    end
  end
end
