require 'rails_helper'

RSpec.describe PoupancaCalculator do
  subject(:calculator) { described_class.new(weekly_amount_cents: weekly_amount_cents, monthly_rate: monthly_rate) }

  let(:weekly_amount_cents) { 5000 }
  let(:monthly_rate) { 0.0067 }

  describe '#run' do
    subject(:results) { calculator.run }

    it 'returns all five timeframes' do
      expect(results.keys).to contain_exactly('month_1', 'months_6', 'year_1', 'years_2', 'years_5')
    end

    it 'returns balance, total deposited, and interest earned per timeframe' do
      results.each_value do |timeframe|
        expect(timeframe.keys).to include(:balance_cents, :total_deposited_cents, :interest_earned_cents)
      end
    end

    it 'accrues interest so balance is at least total deposited' do
      results.each_value do |timeframe|
        expect(timeframe[:balance_cents]).to be >= timeframe[:total_deposited_cents]
      end
    end

    it 'grows interest over time' do
      expect(results['years_5'][:interest_earned_cents]).to be > results['month_1'][:interest_earned_cents]
    end

    it 'matches a manual one-month calculation' do
      monthly_deposit = (weekly_amount_cents * described_class::WEEKS_PER_MONTH).round
      expect(results['month_1'][:total_deposited_cents]).to eq(monthly_deposit)
      expect(results['month_1'][:balance_cents]).to eq((monthly_deposit * (1 + monthly_rate)).round)
    end
  end
end
