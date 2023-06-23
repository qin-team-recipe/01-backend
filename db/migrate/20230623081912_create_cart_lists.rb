class CreateCartLists < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_lists do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
