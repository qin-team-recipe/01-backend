class DropExternalLinksTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :external_links do |t|
      t.bigint "chef_id", null: false
      t.string "title", null: false
      t.string "url", null: false
      t.string "link_type", null: false
      t.integer "follower_count"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["chef_id"], name: "index_external_links_on_chef_id"
    end
  end
end
