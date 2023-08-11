class RemoveForeignKeyFromChefs < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :favorite_chefs, :chefs
    remove_foreign_key :external_links, :chefs
  end
end
