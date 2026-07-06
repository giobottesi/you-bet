require 'rails_helper'

RSpec.describe 'Simulations', type: :request do
  describe 'GET /simulations/new' do
    before { get new_simulation_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the simulation form' do
      expect(response.body).to include('<form')
      expect(response.body).to include('See the damage')
    end

    it 'links out to the blog' do
      expect(response.body).to include(blog_sessions_path)
    end
  end

  describe 'GET / (root)' do
    before { get root_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the same landing page as simulations/new' do
      expect(response.body).to include('<form')
      expect(response.body).to include('See the damage')
    end
  end
end
