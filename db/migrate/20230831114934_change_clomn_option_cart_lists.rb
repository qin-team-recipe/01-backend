class ChangeClomnOptionCartLists < ActiveRecord::Migration[7.0]
  def change
    change_column_default :cart_lists, :own_notes, from: nil, to: false
  end
end
