FactoryBot.define do
  factory :recipe do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence(word_count: 25) }
    serving_size { rand(5) }
    is_draft { false }
    is_public { true }
  end

  trait :with_user do
    before(:create) do |recipe|
      user = create(:user, user_type: 'user')
      recipe.user = user
    end
  end

  trait :with_chef do
    before(:create) do |recipe|
      user = create(:user, user_type: 'chef')
      recipe.user = user
    end
  end

  trait :with_step do
    after(:create) do |recipe, _evaluator|
      create(:step, recipe:)
    end
  end

  trait :with_material do
    after(:create) do |recipe, _evaluator|
      create(:material, recipe:)
    end
  end

  trait :with_recipe_external_link do
    after(:create) do |recipe, _evaluator|
      create(:recipe_external_link, recipe:)
    end
  end
end
