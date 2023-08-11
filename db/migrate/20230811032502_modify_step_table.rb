class ModifyStepTable < ActiveRecord::Migration[7.0]
  def change
    add_column :steps, :position, :integer
    rename_column :steps, :title, :description
    change_column :steps, :description, :text
    remove_column :steps, :memo
  end
end
