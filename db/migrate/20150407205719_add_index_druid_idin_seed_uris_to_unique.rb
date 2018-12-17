class AddIndexDruidIdinSeedUrisToUnique < ActiveRecord::Migration[4.2]
  def change
    add_index :seed_uris, :druid_id, :unique => true
  end
end
