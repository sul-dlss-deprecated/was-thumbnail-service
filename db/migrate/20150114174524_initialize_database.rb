class InitializeDatabase < ActiveRecord::Migration[4.2]
  def up
    create_table :seed_uris do |t|
        t.column "uri",           :string
        t.column "druid_id",        :string
        t.timestamps
    end
    create_table :mementos do |t|
        t.column "uri_id"                           , :int
        t.column "memento_datetime"                 , :datetime
        t.column "memento_uri"                      , :string
        t.column "is_selected"                      , :boolean
        t.column "is_thumbnail_captured"            , :boolean
        t.column "simhash_value"                    , 'BIGINT UNSIGNED'
        t.column "last_thumbnail_captured_datetime" , :datetime
        t.column "retry_count"                      , :int
        t.timestamps
    end
  end
  def down
    drop_table :seed_uris
    drop_table :mementos
  end
end
