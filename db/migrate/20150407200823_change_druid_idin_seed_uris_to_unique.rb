class ChangeDruidIdinSeedUrisToUnique < ActiveRecord::Migration[4.2]
  def change
    change_column :seed_uris, :druid_id, :string, {:unique => true}
  end
end
