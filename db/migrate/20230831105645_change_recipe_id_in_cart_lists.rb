class ChangeRecipeIdInCartLists < ActiveRecord::Migration[7.0]
  def change
    change_column_null :cart_lists, :recipe_id, true
  end
end
