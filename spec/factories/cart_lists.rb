FactoryBot.define do
  factory :cart_list do
    name { Faker::Name.name }
    position { 2 } # NOTE: position: 1は初期作成される自分用ノート
    own_notes { false }

    trait :with_user_and_recipe do
      after(:build) do |cart_list|
        # recipeにも関連するuserが設定される
        cart_list.user = create(:user)
        cart_list.recipe = create(:recipe, user: cart_list.user)
      end
    end
  end
end
