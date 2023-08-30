FactoryBot.define do
  factory :user_external_link do
    url { Faker::Internet.url }

    trait :with_user do
      user
    end
  end
end
