require 'rails_helper'

RSpec.describe 'Devlog', type: :request do
  describe 'GET /devlog' do
    let(:entries) { DevlogReader.all }
    # Each entry's title heads its collapsible <details>, a stable locale-appropriate marker.
    let(:markers) { entries.map(&:title) }

    before { get devlog_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the localized page heading' do
      expect(response.body).to include(I18n.t('devlog.heading'))
    end

    it 'renders every devlog entry title' do
      markers.each { |marker| expect(response.body).to include(marker) }
    end

    it 'renders entries newest sprint day first' do
      positions = markers.map { |marker| response.body.index(marker) }

      expect(positions).not_to include(nil)
      expect(positions).to eq(positions.sort)
      expect(entries.first.day_number).to be > entries.last.day_number
    end

    it 'collapses each entry into a details element' do
      expect(response.body).to include('<details')
    end

    it 'renders markdown as HTML rather than raw syntax' do
      expect(response.body).to include('<strong>')
    end

    it 'nests entry sections in their own collapsibles (more than one per entry)' do
      expect(response.body.scan('<details').size).to be > entries.size
    end
  end

  describe 'DevlogReader' do
    it 'points at the committed devlog directory' do
      expect(DevlogReader::DEVLOG_DIRECTORY).to eq(Rails.root.join('docs', 'devlog'))
    end

    it 'derives sprint-day numbers in ascending order' do
      expect(DevlogReader.day_numbers).to eq(DevlogReader.day_numbers.sort)
    end

    it 'loads exactly one entry per canonical English day file' do
      expect(DevlogReader.all.size).to eq(DevlogReader.day_numbers.size)
    end

    it 'splits the H1 title off the entry body' do
      entry = DevlogReader.all.first

      expect(entry.title).to be_present
      expect(entry.title).not_to start_with('#')
      expect(entry.body).not_to include(entry.title)
    end

    it 'splits the body into H2 sections with a leading preamble' do
      sections = DevlogReader.all.second.sections

      expect(sections.size).to be > 1
      expect(sections.first.heading).to be_nil
      expect(sections.drop(1).map(&:heading)).to all(be_present)
    end
  end
end
