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

    describe 'weekly amount input (#59)' do
      let(:body) { response.body }
      let(:radios) { body.scan('name="weekly_amount_cents"') }
      let(:anchor_count) { SimulationsHelper::WEEKLY_AMOUNT_ANCHORS.size }

      it 'renders one radio per anchor plus the custom row' do
        expect(radios.size).to eq(anchor_count + 1)
      end

      it 'renders the radios as a required radio group' do
        expect(body).to include('type="radio"')
        expect(body).to include('required')
      end

      it 'renders each anchor by its formatted R$ label' do
        %w[R$12 R$25 R$50 R$125].each { |label| expect(body).to include(label) }
      end

      it 'renders a custom reais number field' do
        expect(body).to include('data-weekly-amount-target="customInput"')
        expect(body).to include('type="number"')
      end
    end

    describe 'timeframe slider (#FE-04)' do
      let(:body) { response.body }
      let(:slots) { SimulationsHelper::TIMEFRAME_SLOTS }
      let(:default_weeks) { slots.values[SimulationsHelper::TIMEFRAME_DEFAULT_INDEX] }

      it 'renders a range input bounded by the slot count' do
        expect(body).to include('type="range"')
        expect(body).to include("max=\"#{slots.size - 1}\"")
      end

      it 'renders a hidden timeframe_weeks field defaulting to the 1-year horizon' do
        expect(body).to include('name="timeframe_weeks"')
        expect(body).to include("value=\"#{default_weeks}\"")
      end

      it 'renders one tick per slot with the active default' do
        ticks = body.scan('data-timeframe-slider-target="tick"')
        expect(ticks.size).to eq(slots.size)
        expect(body).to include('is-active')
      end
    end
  end
end
