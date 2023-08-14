class ModifyRecipeTable < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :is_public, :boolean, default: true

    rename_column :recipes, :author_id, :user_id

    remove_column :recipes, :author_type
  end
end
