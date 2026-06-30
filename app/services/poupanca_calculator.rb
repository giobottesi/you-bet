class PoupancaCalculator
  include ActiveModel::Model
  include ActiveModel::Attributes

  WEEKS_PER_MONTH = 4.33

  attribute :weekly_amount_cents, :integer
  attribute :monthly_rate, :float

  def self.run(**attributes)
    new(**attributes).run
  end

  def run
    MonteCarloSimulator::TIMEFRAMES.each_with_object({}) do |(timeframe_key, weeks), results|
      results[timeframe_key] = balance_breakdown(months_in(weeks))
    end
  end

  private

  def monthly_deposit
    @monthly_deposit ||= (weekly_amount_cents * WEEKS_PER_MONTH).round
  end

  def months_in(weeks)
    (weeks / WEEKS_PER_MONTH).round
  end

  def balance_breakdown(months)
    balance = compounded_balance(months)
    total_deposited = monthly_deposit * months

    {
      balance_cents: balance,
      total_deposited_cents: total_deposited,
      interest_earned_cents: balance - total_deposited
    }
  end

  # Deposit then compound monthly, rounding to whole cents each step.
  def compounded_balance(months)
    months.times.reduce(0) do |balance, _|
      ((balance + monthly_deposit) * (1 + monthly_rate)).round
    end
  end
end
