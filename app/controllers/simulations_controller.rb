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
  end

  private

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
