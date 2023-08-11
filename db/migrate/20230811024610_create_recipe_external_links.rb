class CreateRecipeExternalLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_external_links do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :url
      t.string :type

      t.timestamps
    end
  end
end
