class ModifyFavoriteChefs < ActiveRecord::Migration[7.0]
  def change
    rename_table :favorite_chefs, :relationships

    add_column :relationships, :follower_id, :bigint
    add_column :relationships, :followed_id, :bigint

    remove_column :relationships, :user_id
    remove_column :relationships, :chef_id

    add_foreign_key :relationships, :users, column: :follower_id
    add_foreign_key :relationships, :users, column: :followed_id

    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
  end
end
