FactoryBot.define do
  factory :cart_item do
    name { Faker::Name.name }
    is_checked { false }
    position { 1 }
  end
end
