FactoryBot.define do
  factory :recipe do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence(word_count: 25) }
    serving_size { rand(5) }
    is_draft { false }
    is_public { true }
  end

  trait :with_user do
    user
  end
end
