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
        expect(response.body).to include(CGI.escapeHTML(source[:name]))
      end
    end

    it 'renders each source: provides, every figure line, the conclusion, and the exact-figure receipt' do
      SourcesController::DATA_SOURCES.each do |source|
        expect(response.body).to include(CGI.escapeHTML(I18n.t("sources.data.#{source[:key]}.provides")))
        I18n.t("sources.data.#{source[:key]}.figures").each do |line|
          expect(response.body).to include(CGI.escapeHTML(line))
        end
        expect(response.body).to include(CGI.escapeHTML(I18n.t("sources.data.#{source[:key]}.conclusion")))
        expect(response.body).to include(CGI.escapeHTML(I18n.t("sources.data.#{source[:key]}.exact")))
      end
    end

    it 'deep-links every source to its primary source' do
      SourcesController::DATA_SOURCES.each do |source|
        expect(response.body).to include("href=\"#{source[:url]}\"")
      end
    end

    it 'renders every methodological note by its localized subject and body' do
      SourcesController::METHODOLOGICAL_NOTES.each do |note|
        expect(response.body).to include(CGI.escapeHTML(I18n.t("sources.notes.#{note[:key]}.subject")))
        expect(response.body).to include(CGI.escapeHTML(I18n.t("sources.notes.#{note[:key]}.body")))
      end
    end

    it 'deep-links every note citation to its primary source' do
      SourcesController::METHODOLOGICAL_NOTES.flat_map { |note| note[:citations] || [] }.each do |citation|
        expect(response.body).to include("href=\"#{citation[:url]}\"")
        expect(response.body).to include(CGI.escapeHTML(citation[:label]))
      end
    end
  end

  describe 'constants' do
    it 'lists the seven verified research sources' do
      expect(SourcesController::DATA_SOURCES.size).to eq(7)
    end

    it 'gives every source a key, a name, a link, and localized provides/figures/conclusion/exact in both locales' do
      SourcesController::DATA_SOURCES.each do |source|
        expect(source).to include(:key, :name, :url)
        expect(source[:url]).to start_with('https://')
        %i[en pt-BR].each do |locale|
          expect(I18n.t("sources.data.#{source[:key]}.provides", locale: locale)).to be_present
          expect(I18n.t("sources.data.#{source[:key]}.figures", locale: locale)).to be_an(Array).and be_present
          expect(I18n.t("sources.data.#{source[:key]}.conclusion", locale: locale)).to be_present
          expect(I18n.t("sources.data.#{source[:key]}.exact", locale: locale)).to be_present
        end
      end
    end

    it 'carries the methodological notes, each keyed to its prose and cited to a verifiable primary source' do
      expect(SourcesController::METHODOLOGICAL_NOTES.size).to eq(3)
      SourcesController::METHODOLOGICAL_NOTES.each do |note|
        expect(note).to include(:key, :citations)
        note[:citations].each do |citation|
          expect(citation[:label]).to be_present
          expect(citation[:url]).to start_with('https://')
        end
      end
    end
  end
end
