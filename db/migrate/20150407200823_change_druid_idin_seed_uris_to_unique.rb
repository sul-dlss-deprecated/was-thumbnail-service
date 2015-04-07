class ChangeDruidIdinSeedUrisToUnique < ActiveRecord::Migration
  def change
    change_column :seed_uris, :druid_id, :string, {:unique => true}
  end
end
