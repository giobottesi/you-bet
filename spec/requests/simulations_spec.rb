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

  describe 'POST /simulations (#create, FE-05)' do
    let(:valid_params) do
      { bet_type_keys: %w[sports_singles roulette], weekly_amount_cents: '2500', timeframe_weeks: '52' }
    end

    let!(:sports_singles_edge) do
      create(:reference_value, bet_type: 'sports_singles', key: 'house_edge',
                               value: '0.05', value_type: 'float', category: 'bet_type')
    end
    let!(:roulette_edge) do
      create(:reference_value, bet_type: 'roulette', key: 'house_edge',
                               value: '0.027', value_type: 'float', category: 'bet_type')
    end

    it 'persists a simulation carrying the submitted inputs' do
      expect { post simulations_path, params: valid_params }.to change(Simulation, :count).by(1)

      simulation = Simulation.last
      expect(simulation.bet_type_keys).to eq(%w[sports_singles roulette])
      expect(simulation.weekly_amount_cents).to eq(2500)
      expect(simulation.timeframe_weeks).to eq(52)
    end

    it 'stamps the visitor_id from the signed cookie' do
      post simulations_path, params: valid_params

      expect(Simulation.last.visitor_id).to be_present
    end

    it 'redirects to the permalink addressed by uuid, not the sequential id' do
      post simulations_path, params: valid_params

      expect(response).to redirect_to(simulation_path(Simulation.last))
      expect(response.location).to include(Simulation.last.uuid)
    end

    it 'warms one result cache row per selected bet type' do
      expect { post simulations_path, params: valid_params }.to change(SimulationResult, :count).by(2)
    end

    it 'drops the blank custom-radio entry before validating' do
      post simulations_path, params: valid_params.merge(bet_type_keys: [ '', 'roulette' ])

      expect(Simulation.last.bet_type_keys).to eq(%w[roulette])
    end

    context 'with no bet types selected' do
      it 're-renders the form with 422 and persists nothing' do
        expect { post simulations_path, params: valid_params.merge(bet_type_keys: []) }
          .not_to change(Simulation, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include('<form')
      end
    end

    context 'with a blank weekly amount' do
      it 're-renders the form with 422' do
        post simulations_path, params: valid_params.merge(weekly_amount_cents: '')

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'GET /simulations/:id (#show, FE-05)' do
    it 'renders the permalink addressed by uuid' do
      simulation = create(:simulation)

      get simulation_path(simulation)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(simulation.uuid)
    end

    it '404s on an unknown uuid' do
      get simulation_path(id: SecureRandom.uuid)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /simulations/:id results summary (#show, FE-06)' do
    let(:simulation) do
      create(:simulation, bet_type_keys: %w[sports_singles roulette],
                          weekly_amount_cents: 5000, timeframe_weeks: 52)
    end

    let!(:sports_singles_edge) do
      create(:reference_value, bet_type: 'sports_singles', key: 'house_edge',
                               value: '0.05', value_type: 'float', category: 'bet_type')
    end
    let!(:roulette_edge) do
      create(:reference_value, bet_type: 'roulette', key: 'house_edge',
                               value: '0.027', value_type: 'float', category: 'bet_type')
    end

    before { get simulation_path(simulation, locale: 'en') }

    it 'returns 200 for a valid uuid' do
      expect(response).to have_http_status(:ok)
    end

    it 'names every selected bet type' do
      expect(response.body).to include(BetType.new(key: 'sports_singles').display_name(:en))
      expect(response.body).to include(BetType.new(key: 'roulette').display_name(:en))
    end

    it 'renders the recycled projected loss and its share of deposits per bet type' do
      helpers = ActionController::Base.helpers
      { 'sports_singles' => 0.05, 'roulette' => 0.027 }.each do |bet_type_key, edge|
        result = MonteCarloSimulator.new(bet_type_key: bet_type_key, house_edge: edge, weekly_amount_cents: 5000).run['year_1']
        loss_label = helpers.number_to_currency(result[:expected_value_cents].abs / 100.0, unit: 'R$', precision: 0, format: '%u%n')
        share = result[:expected_value_cents].abs.to_f / result[:total_deposited_cents]
        share_label = helpers.number_to_percentage(share * 100, precision: 1, strip_insignificant_zeros: true)

        expect(response.body).to include(loss_label)
        expect(response.body).to include(share_label)
      end
    end

    it 'renders the selected weekly amount and horizon' do
      expect(response.body).to include('R$50')
      expect(response.body).to include('1 year')
    end
  end

  describe 'GET /simulations/:id help resources (#show, FE-09)' do
    let(:simulation) { create(:simulation) }
    let(:resources) { SimulationsHelper::HELP_RESOURCES }

    before { get simulation_path(simulation, locale: 'en') }

    it 'always renders the help section heading and supportive intro' do
      expect(response.body).to include(CGI.escapeHTML(I18n.t('simulations.results.help.heading', locale: :en)))
      expect(response.body).to include(CGI.escapeHTML(I18n.t('simulations.results.help.intro', locale: :en)))
    end

    it 'names every support resource' do
      resources.each do |resource|
        name = I18n.t("simulations.results.help.resources.#{resource[:key]}.name", locale: :en)
        expect(response.body).to include(CGI.escapeHTML(name))
      end
    end

    it 'links every resource to its verified official source' do
      resources.each do |resource|
        expect(response.body).to include("href=\"#{resource[:url]}\"")
      end
    end

    it 'renders the CVV short-code as a tap-to-call link' do
      expect(response.body).to include('href="tel:188"')
      expect(response.body).to include('188')
    end
  end

  describe 'help resource constants (FE-09)' do
    let(:resources) { SimulationsHelper::HELP_RESOURCES }

    it 'carries the four Brazilian support resources' do
      expect(resources.size).to eq(4)
      expect(resources.map { |resource| resource[:key] })
        .to contain_exactly(:cvv, :sus_caps, :gamblers_anonymous, :self_exclusion)
    end

    it 'gives every resource a verified https source link' do
      resources.each { |resource| expect(resource[:url]).to start_with('https://') }
    end

    it 'carries the CVV emotional-support short-code' do
      cvv = resources.find { |resource| resource[:key] == :cvv }
      expect(cvv[:phone]).to eq('188')
    end
  end
end
