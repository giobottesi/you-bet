FactoryBot.define do
  factory :simulation_result do
    sequence(:inputs_signature) { |n| "sports_singles:0.06:5000:#{n}" }
    results { { 'month_1' => { 'expected_value_cents' => -1200 } } }
  end
end
