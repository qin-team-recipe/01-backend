class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text :description
      t.string :thumbnail
      t.integer :serving_size
      t.boolean :is_draft
      t.references :author, polymorphic: true, null: false

      t.timestamps
    end
  end
end
