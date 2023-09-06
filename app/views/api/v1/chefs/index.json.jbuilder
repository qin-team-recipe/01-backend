json.array! @chefs do |chef|
  json.id chef.id
  json.name chef.name
  json.description chef.description
  json.follower_count chef.followers.count
  json.recipe_count chef.recipes.count
  json.created_at chef.created_at
  json.updated_at chef.updated_at
end