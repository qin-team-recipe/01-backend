class CreateSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :steps do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :title, null: false
      t.string :memo

      t.timestamps
    end
  end
end
