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

    describe 'bet type picker (#54)' do
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

    describe 'weekly amount input (FE-03)' do
      it 'renders a required radio per anchor plus the custom row under weekly_amount_cents' do
        radios = response.body.scan('name="weekly_amount_cents"')
        expect(radios.size).to eq(4 + 1) # four DataSenado anchors + the custom row
        expect(response.body).to include('type="radio"')
        expect(response.body).to include('required')
      end

      it 'renders each anchor by its formatted R$ label' do
        %w[R$12 R$25 R$50 R$125].each do |label|
          expect(response.body).to include(label)
        end
      end

      it 'renders a custom reais number field' do
        expect(response.body).to include('data-weekly-amount-target="customInput"')
        expect(response.body).to include('type="number"')
      end
    end
  end
end
