FactoryBot.define do
  factory :reference_value do
    sequence(:key) { |n| "reference_key_#{n}" }
    value { '4000' }
    value_type { 'integer' }
    category { 'comparison' }
    description { 'Example reference value' }
    data_source { 'internal' }
  end
end
