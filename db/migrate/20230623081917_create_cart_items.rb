class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.references :cart_list, null: false, foreign_key: true
      t.string :name
      t.string :memo
      t.boolean :is_checked

      t.timestamps
    end
  end
end
