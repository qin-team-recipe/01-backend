class CreateCartLists < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_lists do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
