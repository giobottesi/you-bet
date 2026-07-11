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

    it 'links the public code repository in the contact line' do
      expect(response.body).to include(PrivacyController::REPOSITORY_URL)
      expect(response.body).to include(I18n.t('privacy.deletion.contact_repo_label'))
    end

    it 'links every external reference under a further-reading heading' do
      expect(response.body).to include(I18n.t('privacy.references.heading'))
      PrivacyController::REFERENCE_LINKS.each_value do |url|
        expect(response.body).to include(url)
      end
    end
  end

  describe 'constants' do
    it 'covers the visitor cookie, simulation inputs, and language preference' do
      expect(PrivacyController::COLLECTED_DATA_KEYS).to eq(%i[visitor_cookie simulation_inputs language_preference])
    end

    it 'points every reference key at an official source URL' do
      expect(PrivacyController::REFERENCE_LINKS.keys).to eq(%i[lgpd anpd_cookies])
      expect(PrivacyController::REFERENCE_LINKS.values).to all(start_with('https://'))
    end
  end
end
