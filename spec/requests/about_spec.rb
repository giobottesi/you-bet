require 'rails_helper'

RSpec.describe 'About', type: :request do
  describe 'GET /about' do
    before { get about_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the localized page heading' do
      expect(response.body).to include(CGI.escapeHTML(I18n.t('about.heading')))
    end

    # Competition requires an AI-usage declaration.
    it 'declares how AI was used' do
      expect(response.body).to include(CGI.escapeHTML(I18n.t('about.ai.heading')))
      expect(response.body).to include(CGI.escapeHTML(I18n.t('about.ai.intro')))
    end

    it 'names Betina as the AI author of the devlog (honest attribution)' do
      expect(response.body).to include('Betina')
      expect(response.body).to include(CGI.escapeHTML(I18n.t('about.ai.betina')))
    end

    it 'spells out each AI role honestly' do
      I18n.t('about.ai.roles').each do |role|
        expect(response.body).to include(CGI.escapeHTML(role))
      end
    end

    it 'links to the public GitHub repository' do
      expect(response.body).to include("href=\"#{AboutController::REPOSITORY_URL}\"")
    end

    it 'links to the devlog and the sources page' do
      expect(response.body).to include("href=\"#{devlog_path}\"")
      expect(response.body).to include("href=\"#{sources_path}\"")
    end

    it 'renders every developer-story section heading' do
      AboutController::STORY_SECTIONS.each do |section|
        expect(response.body).to include(CGI.escapeHTML(I18n.t("about.story.#{section}.heading")))
      end
    end

    it 'renders every FAQ question from Betina to Gio' do
      AboutController::FAQ_QUESTIONS.each do |question|
        expect(response.body).to include(CGI.escapeHTML(I18n.t("about.faq.#{question}.question")))
      end
    end

    it 'flags the story and FAQ answers as Gio-authored placeholders' do
      expect(response.body).to include(CGI.escapeHTML(I18n.t('about.placeholder_tag')))
    end
  end

  describe 'constants' do
    it 'points the repository link at an https GitHub URL' do
      expect(AboutController::REPOSITORY_URL).to start_with('https://github.com/')
    end

    it 'carries the ordered developer-story sections' do
      expect(AboutController::STORY_SECTIONS).to eq(%i[origin who_i_am why_this_one])
    end

    it "carries Betina's open questions for Gio" do
      expect(AboutController::FAQ_QUESTIONS.size).to eq(6)
      expect(AboutController::FAQ_QUESTIONS).to all(be_a(Symbol))
    end
  end
end
