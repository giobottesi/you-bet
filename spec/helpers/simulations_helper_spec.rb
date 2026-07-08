require 'rails_helper'

RSpec.describe SimulationsHelper, type: :helper do
  describe '#bet_card_accent' do
    it 'rotates through the accent palette by index' do
      expect(helper.bet_card_accent(0)).to eq('var(--color-coral)')
      expect(helper.bet_card_accent(1)).to eq('var(--color-cyan)')
    end

    it 'wraps around past the last accent so no two adjacent cards clash' do
      expect(helper.bet_card_accent(5)).to eq(helper.bet_card_accent(0))
    end
  end

  describe 'constants' do
    it 'holds the four DataSenado WEEKLY_AMOUNT_ANCHORS keyed by comparison, in ascending cents' do
      expect(SimulationsHelper::WEEKLY_AMOUNT_ANCHORS.values).to eq([ 1200, 2500, 5000, 12500 ])
    end

    it 'holds the five TIMEFRAME_SLOTS in weeks, matching the simulator timeframes (BE 10)' do
      expect(SimulationsHelper::TIMEFRAME_SLOTS.values).to eq([ 4, 26, 52, 104, 260 ])
    end

    it 'defaults the timeframe slider to the 1-year slot' do
      key = SimulationsHelper::TIMEFRAME_SLOTS.keys[SimulationsHelper::TIMEFRAME_DEFAULT_INDEX]
      expect(key).to eq(:one_year)
    end
  end

  describe '#weekly_amount_label' do
    it 'formats cents as a whole-real R$ label by default' do
      expect(helper.weekly_amount_label(1200)).to eq('R$12')
      expect(helper.weekly_amount_label(12500)).to eq('R$125')
    end

    it 'keeps the centavos when a precision is passed' do
      expect(helper.weekly_amount_label(1250, precision: 2)).to eq('R$12.50')
    end
  end

  describe '#house_edge_label' do
    let(:bet_type) { BetType.new(key: 'sports_singles') }

    it 'formats a whole-percent edge without decimals' do
      allow(bet_type).to receive(:house_edge_value).and_return(0.06)
      expect(helper.house_edge_label(bet_type)).to eq('6%')
    end

    it 'keeps decimals for sub-10% edges that need them' do
      allow(bet_type).to receive(:house_edge_value).and_return(0.0526)
      expect(helper.house_edge_label(bet_type)).to eq('5.26%')
    end

    it 'returns nil when the reference value is not seeded' do
      allow(bet_type).to receive(:house_edge_value).and_return(nil)
      expect(helper.house_edge_label(bet_type)).to be_nil
    end
  end
end
