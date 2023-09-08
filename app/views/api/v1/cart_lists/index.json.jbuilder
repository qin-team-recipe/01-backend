json.lists @cart_lists do |cart_list|
  json.id cart_list.id
  json.recipe_id cart_list.recipe_id
  json.name cart_list.name
  json.own_notes cart_list.own_notes
  json.position cart_list.position
  json.items cart_list.cart_items do |cart_item|
    json.name cart_item.name
    json.is_checked cart_item.is_checked
    json.position cart_item.position
    json.created_at cart_item.created_at
    json.updated_at cart_item.updated_at
  end
end
