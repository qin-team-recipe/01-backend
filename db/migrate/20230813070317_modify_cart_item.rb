class ModifyCartItem < ActiveRecord::Migration[7.0]
  def change
    remove_column :cart_items, :memo
    add_column :cart_items, :position, :integer
  end
end
