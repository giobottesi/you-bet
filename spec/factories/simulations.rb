FactoryBot.define do
  factory :simulation do
    visitor_id { SecureRandom.uuid }
    bet_type_keys { %w[sports_singles roulette] }
    weekly_amount_cents { 2500 }
    timeframe_weeks { 52 }
  end
end
