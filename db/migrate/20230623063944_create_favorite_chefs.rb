class CreateFavoriteChefs < ActiveRecord::Migration[7.0]
  def change
    create_table :favorite_chefs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chef, null: false, foreign_key: true

      t.timestamps
    end

    add_index :favorite_chefs, [:user_id, :chef_id], unique: true
  end
end
