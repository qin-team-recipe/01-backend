class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :description, :text
    add_column :users, :domain, :string
    add_column :users, :role, :string
    add_column :users, :sns_id, :string
    add_column :users, :thumnail, :string
  end
end
