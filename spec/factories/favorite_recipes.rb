FactoryBot.define do
  factory :favorite_recipe do
    trait :with_user_and_recipe do
      after(:build) do |favorite_recipe|
        favorite_recipe.user = create(:user)
        favorite_recipe.recipe = create(:recipe, user: create(:user))
      end
    end

    trait :with_user do
      user
    end
  end
end
