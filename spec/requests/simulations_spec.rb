require 'rails_helper'

RSpec.describe 'Simulations', type: :request do
  describe 'GET / (simulation form is the landing page)' do
    before { get root_path }

    it 'returns 200' do
      expect(response).to have_http_status(:ok)
    end

    it 'renders the simulation form' do
      expect(response.body).to include('<form')
      expect(response.body).to include('See the damage')
    end

    it 'renders the three form section partials by their Stimulus identifiers' do
      expect(response.body).to include('data-controller="bet-type-picker"')
      expect(response.body).to include('data-controller="weekly-amount"')
      expect(response.body).to include('data-controller="timeframe-slider"')
    end

    describe 'bet type picker (FE-02)' do
      it 'renders every bet type by its display name' do
        BetType.all.each do |bet_type|
          expect(response.body).to include(bet_type.display_name)
        end
      end

      it 'renders each type as a multi-select checkbox in the bet_type_keys array' do
        checkboxes = response.body.scan('name="bet_type_keys[]"')
        expect(checkboxes.size).to eq(BetType::BETTING_TYPES.size)
        expect(response.body).to include('type="checkbox"')
      end
    end
  end
end
