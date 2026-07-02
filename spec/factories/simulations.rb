FactoryBot.define do
  factory :simulation do
    visitor_id { SecureRandom.uuid }
  end
end
