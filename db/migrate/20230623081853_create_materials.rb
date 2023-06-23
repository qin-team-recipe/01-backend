class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :name
      t.string :memo

      t.timestamps
    end
  end
end
