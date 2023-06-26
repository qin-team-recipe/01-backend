class CreateChefs < ActiveRecord::Migration[7.0]
  def change
    create_table :chefs do |t|
      t.string :name, null: false
      t.text :description
      t.string :thumbnail

      t.timestamps
    end
  end
end
