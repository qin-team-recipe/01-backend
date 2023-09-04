FactoryBot.define do
  factory :recipe_external_link do
    url { Faker::Internet.url }

    trait :with_recipe do
      after(:build) do |recipe_external_link|
        recipe_external_link.recipe = create(:recipe, user: create(:user))
      end
    end

    trait :with_url_type do
      url_type { RecipeExternalLink::URL_TYPES.values.sample }
    end
  end
end
