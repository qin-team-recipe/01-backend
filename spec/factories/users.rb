FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence(word_count: 25) }
    email { Faker::Internet.email }
    domain { Faker::Alphanumeric.alphanumeric(number: 10) }
    user_type { 'user' }

    trait :chef do
      user_type { 'chef' }
    end
  end
end
