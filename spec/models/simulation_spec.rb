require 'rails_helper'

RSpec.describe Simulation do
  it 'is valid with a visitor_id' do
    expect(build(:simulation)).to be_valid
  end

  it 'requires a visitor_id' do
    simulation = build(:simulation, visitor_id: nil)

    expect(simulation).not_to be_valid
    expect(simulation.errors[:visitor_id]).to be_present
  end
end
