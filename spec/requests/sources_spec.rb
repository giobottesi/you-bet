require 'rails_helper'

RSpec.describe 'Sources', type: :request do
  describe 'GET /sources' do
    before { get sources_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the localized page heading' do
      expect(response.body).to include(I18n.t('sources.heading'))
    end

    it 'lists every data source by name (source attribution)' do
      SourcesController::DATA_SOURCES.each do |source|
        expect(response.body).to include(source[:name])
      end
    end

    it 'renders the key figures for each source' do
      SourcesController::DATA_SOURCES.each do |source|
        expect(response.body).to include(source[:figures])
      end
    end

    it 'renders every methodological note' do
      SourcesController::METHODOLOGICAL_NOTES.each do |note|
        expect(response.body).to include(CGI.escapeHTML(note[:subject]))
        expect(response.body).to include(CGI.escapeHTML(note[:note]))
      end
    end
  end

  describe 'constants' do
    it 'lists the seven verified research sources' do
      expect(SourcesController::DATA_SOURCES.size).to eq(7)
    end

    it 'gives every source a name, a provides descriptor, and figures' do
      SourcesController::DATA_SOURCES.each do |source|
        expect(source).to include(:name, :provides, :figures)
      end
    end

    it 'carries the reconciliation notes' do
      expect(SourcesController::METHODOLOGICAL_NOTES.size).to eq(2)
    end
  end
end
