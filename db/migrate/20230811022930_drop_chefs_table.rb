class DropChefsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :chefs do |t|
      t.string "name", null: false
      t.text "description"
      t.string "thumbnail"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
