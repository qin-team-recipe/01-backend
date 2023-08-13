class AddOwnNotesToCartList < ActiveRecord::Migration[7.0]
  def change
    add_column :cart_lists, :own_notes, :boolean
  end
end
