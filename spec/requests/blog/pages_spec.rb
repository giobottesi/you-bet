require 'rails_helper'

RSpec.describe 'Blog::Pages', type: :request do
  describe 'GET /blog/about' do
    before { get blog_about_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the about placeholder' do
      expect(response.body).to include('@magicagem')
    end
  end

  describe 'GET /blog/archive' do
    before { get blog_archive_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'lists every session grouped by year' do
      BlogSession.all.each do |blog_session|
        expect(response.body).to include(blog_session.title)
      end
      expect(response.body).to include('2014')
    end
  end
end
