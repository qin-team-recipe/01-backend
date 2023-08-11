class ModifyMaterialTable < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :position, :integer
    remove_column :materials, :memo
  end
end
