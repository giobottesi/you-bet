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

    it 'names the best-case bet type in the timeline' do
      # roulette (edge 0.027) loses less than sports singles (0.05), so it's the best-case pick.
      expect(response.body).to include(BetType.new(key: 'roulette').display_name(:en))
    end

    it 'leads with the worst-case loss and shows the best-case share over time' do
      helpers = ActionController::Base.helpers

      worst = MonteCarloSimulator.new(bet_type_key: 'sports_singles', house_edge: 0.05, weekly_amount_cents: 5000).run['year_1']
      worst_loss_label = helpers.number_to_currency(worst[:expected_value_cents].abs / 100.0, unit: 'R$', precision: 0, format: '%u%n')
      expect(response.body).to include(worst_loss_label)

      best = MonteCarloSimulator.new(bet_type_key: 'roulette', house_edge: 0.027, weekly_amount_cents: 5000).run['year_1']
      best_share = best[:expected_value_cents].abs.to_f / best[:total_deposited_cents]
      best_share_label = helpers.number_to_percentage(best_share * 100, precision: 1, strip_insignificant_zeros: true)
      expect(response.body).to include(best_share_label)
    end

    it 'projects a loss that is the majority of deposits — recycled winnings, not a single-turnover edge' do
      result = MonteCarloSimulator.new(bet_type_key: 'sports_singles', house_edge: 0.05, weekly_amount_cents: 5000).run['year_1']
      single_turnover_loss = 5000 * 52 * 0.05

      expect(result[:expected_value_cents].abs).to be > (single_turnover_loss * 3)
    end

    it 'renders the win chance that shrinks to almost nothing over time' do
      expect(response.body).to include('of simulations ended in profit')
    end

    it 'renders the selected weekly amount and horizon' do
      expect(response.body).to include('R$50')
      expect(response.body).to include('1 year')
    end
  end

  describe 'GET /simulations/:id opportunity cost (#show, FE-07)' do
    let(:simulation) do
      create(:simulation, bet_type_keys: %w[sports_singles], weekly_amount_cents: 5000, timeframe_weeks: 52)
    end

    let!(:edge) do
      create(:reference_value, bet_type: 'sports_singles', key: 'house_edge',
                               value: '0.05', value_type: 'float', category: 'bet_type')
    end
    let!(:pizza) do
      create(:reference_value, key: 'pizza_price_cents', value: '4000', value_type: 'integer', category: 'comparison')
    end
    let!(:poupanca_rate) do
      create(:app_config, key: 'poupanca_monthly_rate', value: '0.0067', value_type: 'decimal')
    end

    before { get simulation_path(simulation, locale: 'en') }

    it 'renders the opportunity-cost section heading' do
      expect(response.body).to include('That money could have been')
    end

    it 'renders a comparison item the lost money could have bought' do
      # R$130 lost / R$40 pizza = 3 pizzas.
      expect(response.body).to include('pizzas')
    end

    it 'renders the poupança balance the same money would have grown to' do
      expect(response.body).to include('In savings, it would have grown to')
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

  describe 'GET /simulations/:id share section (#show, FE-10)' do
    let(:simulation) { create(:simulation) }
    # pt-BR is the default locale, so only the non-default English view pins ?locale=en on the permalink.
    let(:base_permalink) { "http://www.example.com/simulations/#{simulation.uuid}" }

    context 'in English' do
      let(:permalink) { "#{base_permalink}?locale=en" }

      before { get simulation_path(simulation, locale: 'en') }

      it 'renders the share heading and the share Stimulus controller' do
        expect(response.body).to include(CGI.escapeHTML(I18n.t('simulations.results.share.heading', locale: :en)))
        expect(response.body).to include('data-controller="share"')
      end

      it 'wires the copy button to the permalink and localized confirmation' do
        expect(response.body).to include("data-share-url-value=\"#{permalink}\"")
        expect(response.body).to include('data-share-copied-value')
        expect(response.body).to include('data-action="share#copy"')
      end

      it 'links WhatsApp with the encoded share text and permalink' do
        message = "#{I18n.t('simulations.results.share.text', locale: :en)} #{permalink}"
        expect(response.body).to include("https://wa.me/?text=#{ERB::Util.url_encode(message)}")
      end

      it 'links X/Twitter with the encoded text and permalink params' do
        text = ERB::Util.url_encode(I18n.t('simulations.results.share.text', locale: :en))
        url = ERB::Util.url_encode(permalink)
        expect(response.body).to include("https://twitter.com/intent/tweet?text=#{text}&amp;url=#{url}")
      end
    end

    context 'in Portuguese' do
      let(:permalink) { base_permalink }

      before { get simulation_path(simulation, locale: 'pt-BR') }

      it 'renders the localized share heading' do
        expect(response.body).to include(CGI.escapeHTML(I18n.t('simulations.results.share.heading', locale: :'pt-BR')))
      end

      it 'carries the Portuguese share text and campaign hashtag in the WhatsApp link' do
        message = "#{I18n.t('simulations.results.share.text', locale: :'pt-BR')} #{permalink}"
        expect(response.body).to include("https://wa.me/?text=#{ERB::Util.url_encode(message)}")
        expect(I18n.t('simulations.results.share.text', locale: :'pt-BR')).to include('#DesafioContraBets')
      end
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
