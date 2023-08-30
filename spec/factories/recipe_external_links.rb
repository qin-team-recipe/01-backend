FactoryBot.define do
  factory :recipe_external_link do
    url { Faker::Internet.url }

    trait :with_recipe do
      after(:build) do |recipe_external_link|
        recipe_external_link.recipe = create(:recipe, user: create(:user))
      end
    end
  end
end
