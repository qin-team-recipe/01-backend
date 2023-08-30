30.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password",
    description: Faker::Lorem.paragraph(sentence_count: 5),
    domain: Faker::Alphanumeric.unique.alphanumeric(number: 10),
    user_type: ["user", "chef"].sample,
    sns_id: Faker::Number.number(digits: 21),
    thumnail: Faker::Avatar.image(slug: "my-own-slug", size: "50x50")
  )

  recipe = Recipe.create!(
    name: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph(sentence_count: 5),
    thumbnail: Faker::Avatar.image(slug: "my-own-slug", size: "50x50"),
    serving_size: rand(1..5),
    is_draft: [true, false].sample,
    user_id: user.id,
    is_public: [true, false].sample
  )

  favorite_recipe = FavoriteRecipe.create!(
    user_id: user.id,
    recipe_id: recipe.id
  )

  cart_list = CartList.create!(
    recipe_id: recipe.id,
    user_id: user.id,
    name: Faker::Lorem.sentence(word_count: 5),
    position: rand(1..10),
    own_notes: [true, false].sample
  )

  recipe_external_link = RecipeExternalLink.create!(
    recipe_id: recipe.id,
    url: Faker::Internet.url,
    url_type: ["youtube", "instagram", "twitter"].sample
  )

  user_external_link = UserExternalLink.create!(
    user_id: user.id,
    url: Faker::Internet.url,
    url_type: ["youtube", "instagram", "twitter"].sample
  )

  followed_user = User.order("RANDOM()").first
  relationship = Relationship.create!(
    follower_id: user.id,
    followed_id: followed_user.id
  )

  5.times do |i|
    position = i + 1

    material = Material.create!(
      recipe_id: recipe.id,
      name: Faker::Food.sushi,
      position: position
    )

    step = Step.create!(
      recipe_id: recipe.id,
      description: Faker::Lorem.paragraph(sentence_count: 5),
      position: position
    )

    cart_item = CartItem.create!(
      cart_list_id: cart_list.id,
      name: Faker::Food.sushi,
      is_checked: [true, false].sample,
      position: position
    )
  end
end
