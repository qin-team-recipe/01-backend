FactoryBot.define do
  factory :favorite_recipe do
    association :user
    association :recipe
  end
end
