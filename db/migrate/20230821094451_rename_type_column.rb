class RenameTypeColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :type, :user_type
    rename_column :recipe_external_links, :type, :url_type
    rename_column :user_external_links, :type, :url_type
  end
end
