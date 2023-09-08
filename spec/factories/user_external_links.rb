FactoryBot.define do
  factory :user_external_link do
    url { Faker::Internet.url }

    trait :with_user do
      user
    end

    trait :with_url_type do
      url_type { UserExternalLink::URL_TYPES.values.sample }
    end
  end
end
