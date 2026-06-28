FactoryBot.define do
  factory :app_config do
    sequence(:key) { |n| "config_key_#{n}" }
    value { '1000' }
    value_type { 'integer' }
    description { 'Example config' }
    data_source { 'internal' }
  end
end
