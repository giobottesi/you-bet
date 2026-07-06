require 'rails_helper'

RSpec.describe 'Blog::Sessions', type: :request do
  describe 'GET /blog/sessions' do
    before { get blog_sessions_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders every session title and the magicagem branding' do
      expect(response.body).to include('magicagem')
      expect(response.body).to include('@magicagem')
      BlogSession.all.each do |blog_session|
        expect(response.body).to include(blog_session.title)
      end
    end
  end

  describe 'GET /blog/sessions/:id' do
    context 'with a known session' do
      before { get blog_session_path(BlogSession.all.first.id) }

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders the session body' do
        expect(response.body).to include(BlogSession.all.first.title)
      end
    end

    context 'with an unknown session' do
      before { get blog_session_path('does-not-exist') }

      it 'returns 404' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
