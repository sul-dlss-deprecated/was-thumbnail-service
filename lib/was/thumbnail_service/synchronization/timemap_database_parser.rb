module Was
  module ThumbnailService
    module Synchronization
    
      # It responsible of reading the timemap from the database.
      class TimemapDatabaseParser
      
        def initialize(uri)
          @uri = uri
        end        
        
        def get_timemap
          memento_hash_list = {}
  
          memento_records = Memento.joins('INNER JOIN seed_uris on mementos.uri_id = seed_uris.id').where( "seed_uris.uri" => @uri)
          memento_records.each do |memento_record| 
            if memento_record[:memento_uri].present? && memento_record[:memento_datetime].present? then
              memento_hash = {}
              memento_datetime = Utilities.convert_date_to_14_digits(memento_record[:memento_datetime].to_s)
              memento_hash_list[memento_datetime] = memento_record[:memento_uri]
            end
          end
          return memento_hash_list
        end
      end
    end
  end
end
