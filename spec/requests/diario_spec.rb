require 'rails_helper'

RSpec.describe 'Diario', type: :request do
  describe 'GET /diario' do
    let(:entries) { DevlogEntry.all }
    # Each entry's first markdown line (its H1) is a stable, locale-appropriate marker.
    let(:markers) { entries.map { |entry| entry.body.lines.first.strip } }

    before { get diario_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the localized page heading' do
      expect(response.body).to include(I18n.t('devlog.heading'))
    end

    it 'renders every devlog entry' do
      markers.each { |marker| expect(response.body).to include(marker) }
    end

    it 'renders entries chronologically (oldest sprint day first)' do
      positions = markers.map { |marker| response.body.index(marker) }

      expect(positions).not_to include(nil)
      expect(positions).to eq(positions.sort)
    end
  end

  describe 'constants' do
    it 'points at the committed devlog directory' do
      expect(DevlogEntry::DEVLOG_DIRECTORY).to eq(Rails.root.join('docs', 'devlog'))
    end

    it 'derives sprint-day numbers in ascending order' do
      expect(DevlogEntry.day_numbers).to eq(DevlogEntry.day_numbers.sort)
    end

    it 'loads exactly one entry per canonical English day file' do
      expect(DevlogEntry.all.size).to eq(DevlogEntry.day_numbers.size)
    end
  end
end
