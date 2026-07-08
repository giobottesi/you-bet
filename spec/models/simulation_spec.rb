require 'rails_helper'

RSpec.describe Simulation do
  it 'is valid with the full set of inputs' do
    expect(build(:simulation)).to be_valid
  end

  it 'requires a visitor_id' do
    simulation = build(:simulation, visitor_id: nil)

    expect(simulation).not_to be_valid
    expect(simulation.errors[:visitor_id]).to be_present
  end

  it 'requires at least one bet type' do
    simulation = build(:simulation, bet_type_keys: [])

    expect(simulation).not_to be_valid
    expect(simulation.errors[:bet_type_keys]).to be_present
  end

  it 'rejects bet type keys outside the known set' do
    simulation = build(:simulation, bet_type_keys: %w[sports_singles made_up_game])

    expect(simulation).not_to be_valid
    expect(simulation.errors[:bet_type_keys]).to be_present
  end

  it 'requires a positive weekly_amount_cents' do
    expect(build(:simulation, weekly_amount_cents: nil)).not_to be_valid
    expect(build(:simulation, weekly_amount_cents: 0)).not_to be_valid
  end

  it 'requires a positive timeframe_weeks' do
    expect(build(:simulation, timeframe_weeks: nil)).not_to be_valid
    expect(build(:simulation, timeframe_weeks: 0)).not_to be_valid
  end

  it 'exposes the uuid as its route param, never the sequential id' do
    simulation = create(:simulation)

    expect(simulation.to_param).to eq(simulation.uuid)
    expect(simulation.to_param).not_to eq(simulation.id.to_s)
  end
end
