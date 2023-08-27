class AddIndexToPosition < ActiveRecord::Migration[7.0]
  def change
    add_index :steps, [:recipe_id, :position], unique: true
    add_index :materials, [:recipe_id, :position], unique: true
  end
end
