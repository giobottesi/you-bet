require 'rails_helper'

RSpec.describe 'Rack::Attack', type: :request do
  before do
    # ActionDispatch::HostAuthorization 403s rspec's default www.example.com before the
    # request reaches Rack::Attack; localhost is permitted by Rails' .localhost default.
    host! 'localhost'
    Rack::Attack.enabled = true
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  after do
    Rack::Attack.cache.store.clear
    Rack::Attack.enabled = false
  end

  describe 'simulation throttle' do
    let(:limit) { 10 } # SIMULATION_THROTTLE_LIMIT default

    it 'allows requests up to the limit' do
      limit.times { post '/simulations' }

      expect(response).not_to have_http_status(:too_many_requests)
    end

    it 'returns 429 with a Retry-After header once the limit is exceeded' do
      (limit + 1).times { post '/simulations' }

      expect(response).to have_http_status(:too_many_requests)
      expect(response.headers['Retry-After']).to be_present
      expect(JSON.parse(response.body)['error']).to match(/Too many requests/)
    end
  end

  describe 'general throttle exclusions' do
    it 'does not throttle the health check endpoint' do
      500.times { get '/up' }

      expect(response).not_to have_http_status(:too_many_requests)
    end
  end

  describe Rack::Attack::ScannerProbe do
    it 'matches known scanner paths' do
      %w[/wp-login.php /xmlrpc.php /.env /.git/config /phpmyadmin].each do |path|
        expect(described_class.match?(path)).to be(true), "expected #{path} to match"
      end
    end

    it 'does not match legitimate paths' do
      %w[/ /simulations /up /assets/app.js].each do |path|
        expect(described_class.match?(path)).to be(false), "expected #{path} not to match"
      end
    end
  end
end
