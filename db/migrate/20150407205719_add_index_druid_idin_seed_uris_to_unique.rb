class AddIndexDruidIdinSeedUrisToUnique < ActiveRecord::Migration
  def change
    add_index :seed_uris, :druid_id, :unique => true
  end
end
