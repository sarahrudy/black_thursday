require 'faker'

FactoryBot.define do
  factory :merchant, class: Merchant do
    name { Faker::Name.name }
  end

  factory :item, class: Item do
    name { Faker::Name.name }
    description { Faker::Lorem.words(number: 4).join(' ') }
    unit_price { Faker::Number.number(digits: 4) }
    created_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    updated_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
  end
end
