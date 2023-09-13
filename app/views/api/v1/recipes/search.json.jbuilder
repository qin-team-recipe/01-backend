json.array! @recipes do |recipe|
  json.id recipe.id
  json.name recipe.name
  json.description recipe.description
  json.favorite_count recipe.favoriters_count
  json.thumbnail recipe.thumbnail
  json.chef_name recipe.user.name
  json.created_at recipe.created_at
  json.updated_at recipe.updated_at
end
