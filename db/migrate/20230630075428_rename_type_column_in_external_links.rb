class RenameTypeColumnInExternalLinks < ActiveRecord::Migration[7.0]
  def change
    rename_column :external_links, :type, :link_type
  end
end
