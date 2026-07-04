require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /' do
    before { get root_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the app name' do
      expect(response.body).to include('You')
      expect(response.body).to include('Coming soon')
    end
  end
end
