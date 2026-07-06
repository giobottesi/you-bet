class SimulationsController < ApplicationController
  def new
    @simulation = Simulation.new
    @bet_types = BetType.all
  end
end
