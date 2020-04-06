FactoryBot.define do
  factory :post do
    user
    message { Faker::Lorem.paragraph }
  end
end
