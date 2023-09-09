json.id @recipe.id
json.name @recipe.name
json.description @recipe.description
json.favorite_count @recipe.favoriters_count
json.thumbnail @recipe.thumbnail
json.serving_size @recipe.serving_size
json.is_favorite false # TODO: ログイン機能ができたら実装する
json.is_public @recipe.is_public
json.is_draft @recipe.is_draft
json.author_type @recipe.author_type
json.steps @recipe.steps do |step|
  json.description step.description
  json.position step.position
end
json.materials @recipe.materials do |material|
  json.name material.name
  json.position material.position
end
json.external_links @recipe.recipe_external_links do |external_link|
  json.url external_link.url
  json.type external_link.url_type
end
json.created_at @recipe.created_at
json.updated_at @recipe.updated_at
