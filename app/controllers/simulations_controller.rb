class SimulationsController < ApplicationController
  def new
    @simulation = Simulation.new
    @bet_types = BetType.all
  end

  def create
    @simulation = Simulation.new(simulation_params.merge(visitor_id: current_visitor_id))

    if @simulation.save
      warm_result_cache
      redirect_to @simulation
    else
      @bet_types = BetType.all
      render :new, status: :unprocessable_content
    end
  end

  def show
    @simulation = Simulation.find_by!(uuid: params[:id])
    @bet_type_results = @simulation.bet_type_keys.filter_map { |bet_type_key| bet_type_result_for(bet_type_key) }
    @worst_case_loss_cents = worst_case_loss_cents
    load_opportunity_cost
  end

  private

  # Worst single-bet-type loss for the horizon — the bet types are parallel what-ifs on the same
  # money, never summed, so the opportunity anchor uses the deepest one (matches the staked->lost bar).
  def worst_case_loss_cents
    weeks = @simulation.timeframe_weeks
    @bet_type_results.map { |_bet_type, result| result.loss_cents(weeks) }.max || 0
  end

  # What the lost money could have bought, plus what it would have grown to in poupança (the hero).
  # A bonus section — never fail the core results page if its reference data isn't seeded.
  def load_opportunity_cost
    @item_comparisons = []
    return if @worst_case_loss_cents.zero?

    balance_cents = poupanca_balance_cents
    return if balance_cents.nil?

    comparisons = OpportunityCostMapper.run(loss_cents: @worst_case_loss_cents, poupanca_balance_cents: balance_cents)
    @poupanca_comparison = comparisons.find { |comparison| comparison[:key] == 'poupanca' }
    @item_comparisons = comparisons.reject { |comparison| comparison[:key] == 'poupanca' }.first(2)
  end

  # Balance the same weekly amount would reach in poupança over the chosen horizon; nil if the rate isn't seeded.
  def poupanca_balance_cents
    monthly_rate = AppConfig.find_by(key: 'poupanca_monthly_rate')&.typed_value
    return if monthly_rate.nil?

    timeframe_key = MonteCarloSimulator::TIMEFRAMES.key(@simulation.timeframe_weeks)
    PoupancaCalculator.run(
      weekly_amount_cents: @simulation.weekly_amount_cents,
      monthly_rate: monthly_rate
    ).dig(timeframe_key, :balance_cents)
  end

  def simulation_params
    params.permit(:weekly_amount_cents, :timeframe_weeks, bet_type_keys: []).tap do |permitted|
      permitted[:bet_type_keys]&.reject!(&:blank?)
    end
  end

  # One submission warms N cache rows — the simulator returns every timeframe per type.
  def warm_result_cache
    @simulation.bet_type_keys.each { |bet_type_key| bet_type_result_for(bet_type_key) }
  end

  # Read-through the cache for one bet type, warming on miss. Nil when the house edge isn't seeded.
  def bet_type_result_for(bet_type_key)
    bet_type = BetType.new(key: bet_type_key)
    result = SimulationResultUpsert.upsert(
      bet_type_key: bet_type_key,
      house_edge: bet_type.house_edge_value,
      weekly_amount_cents: @simulation.weekly_amount_cents
    )
    [ bet_type, result ] if result.is_a?(SimulationResult)
  end
end
