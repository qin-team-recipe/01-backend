FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence(word_count: 25) }
    email { Faker::Internet.email }
    domain { Faker::Alphanumeric.alphanumeric(number: 10) }
    user_type { 'user' }
    thumnail { Faker::Internet.url }

    trait :with_type_chef do
      user_type { 'chef' }
    end

    trait :with_recipes do
      after(:create) do |user|
        create_list(:recipe, 5, user:)
      end
    end
  end
end
