json.id @chef.id
json.name @chef.name
json.description @chef.description
json.domain @chef.domain
json.follower_count @chef.followers.count
json.recipe_count @chef.recipes.count
json.thumbnail @chef.thumnail
json.external_links @chef.user_external_links do |external_link|
  json.url external_link.url
  json.type external_link.url_type
end
json.created_at @chef.created_at
json.updated_at @chef.updated_at
