class AddNullConstraints < ActiveRecord::Migration[7.0]
  def change
    change_column_null :cart_items, :position, false
    change_column_null :cart_lists, :own_notes, false
    change_column_null :materials, :position, false
    change_column_null :recipe_external_links, :url, false
    change_column_null :recipes, :serving_size, false
    change_column_null :recipes, :is_public, false
    change_column_null :relationships, :follower_id, false
    change_column_null :relationships, :followed_id, false
    change_column_null :steps, :position, false
    change_column_null :user_external_links, :url, false
    change_column_null :users, :domain, false
    change_column_null :users, :role, false

    add_index :users, :domain, unique: true

    rename_column :users, :role, :type

    add_index :recipe_external_links, [:recipe_id, :url], unique: true
    add_index :recipe_external_links, [:recipe_id, :type], unique: true
    add_index :user_external_links, [:user_id, :url], unique: true
    add_index :user_external_links, [:user_id, :type], unique: true
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
