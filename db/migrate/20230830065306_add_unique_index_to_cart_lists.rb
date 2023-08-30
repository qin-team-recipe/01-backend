class AddUniqueIndexToCartLists < ActiveRecord::Migration[7.0]
  def change
    add_index :cart_lists, [:user_id, :recipe_id], unique: true
  end
end
