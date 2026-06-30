class PoupancaCalculator
  include ActiveModel::Model
  include ActiveModel::Attributes

  WEEKS_PER_MONTH = 4.33

  attribute :weekly_amount_cents, :integer
  attribute :monthly_rate, :float

  def run
    monthly_deposit = (weekly_amount_cents * WEEKS_PER_MONTH).round

    MonteCarloSimulator::TIMEFRAMES.each_with_object({}) do |(timeframe_key, weeks), results|
      months = (weeks / WEEKS_PER_MONTH).round
      results[timeframe_key] = calculate_balance(monthly_deposit, months)
    end
  end

  private

  def calculate_balance(monthly_deposit, months)
    balance = 0
    total_deposited = 0

    months.times do
      balance += monthly_deposit
      balance = (balance * (1 + monthly_rate)).round
      total_deposited += monthly_deposit
    end

    {
      balance_cents: balance,
      total_deposited_cents: total_deposited,
      interest_earned_cents: balance - total_deposited
    }
  end
end
