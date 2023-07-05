Faker::Config.locale = :ja

10.times do
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    crypted_password: Faker::Internet.password,
    salt: Faker::Crypto.md5
  )

  chef = Chef.create!(
    name: Faker::Name.name,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    thumbnail: Faker::Avatar.image(slug: "my-own-slug", size: "50x50")
  )

  external_link = ExternalLink.create!(
    chef_id: chef.id,
    title: Faker::Lorem.sentence(word_count: 3),
    url: Faker::Internet.url,
    link_type: ['Twitter', 'Instagram', 'Website'].sample,
    follower_count: rand(1000..10000)
  )

  favorite_chef = FavoriteChef.create!(
    user_id: user.id,
    chef_id: chef.id
  )

  3.times do
    author_type = ['User', 'Chef'].sample
    author_id = author_type == 'User' ? user.id : chef.id

    recipe = Recipe.create!(
      name: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.paragraph(sentence_count: 3),
      thumbnail: Faker::Avatar.image(slug: "my-own-slug", size: "50x50"),
      serving_size: rand(1..5),
      is_draft: [true, false].sample,
      author_type: author_type,
      author_id: author_id
    )

    material = Material.create!(
      recipe_id: recipe.id,
      name: Faker::Lorem.sentence(word_count: 3),
      memo: Faker::Lorem.paragraph(sentence_count: 3)
    )

    step = Step.create!(
      recipe_id: recipe.id,
      title: Faker::Lorem.sentence(word_count: 3),
      memo: Faker::Lorem.paragraph(sentence_count: 3)
    )

    favorite_recipe = FavoriteRecipe.create!(
      user_id: user.id,
      recipe_id: recipe.id
    )

    cart_list = CartList.create!(
      recipe_id: recipe.id,
      user_id: user.id,
      name: Faker::Lorem.sentence(word_count: 3),
      position: rand(1..10)
    )

    cart_item = CartItem.create!(
      cart_list_id: cart_list.id,
      name: Faker::Lorem.sentence(word_count: 3),
      memo: Faker::Lorem.paragraph(sentence_count: 3),
      is_checked: [true, false].sample
    )
  end
end
