class CreateExternalLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :external_links do |t|
      t.references :chef, null: false, foreign_key: true
      t.string :title, null: false
      t.string :url, null: false
      t.string :type, null: false
      t.integer :follower_count

      t.timestamps
    end
  end
end
