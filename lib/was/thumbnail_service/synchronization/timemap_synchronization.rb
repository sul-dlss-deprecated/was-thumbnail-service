module Was
  module ThumbnailService
    
    # It is responsible of the syncronization of the Timemap as 
    # recorded in the database and the wayback.
    class TimemapSynchronization
    
    	def initialize(uri, uri_id)
    		@uri = uri
    		@uri_id = uri_id
    	end
    	
    	def sync_database
        get_timemap_from_database
    	  get_timemap_from_wayback
    	  diff_mementos = get_timemap_difference_list
    	  insert_mementos_into_database diff_mementos
    	end

    	def insert_mementos_into_database diff_mementos
    	  diff_mementos.each do |memento_datetime| 
          memento_database_handler = MementoDatabaseHandler.new(@uri_id, @wayback_memento_hash[memento_datetime], memento_datetime)
          begin
            memento_database_handler.add_memento_to_database_timemap
          rescue => e
            puts e.message
          end
        end
      end
        
    	def get_timemap_from_database
        timemap_parser = Was::ThumbnailService::TimemapDatabaseParser.new(@uri)
        @database_memento_hash = timemap_parser.get_timemap
      end
    	
    	def get_timemap_from_wayback
    	  timemap_parser = Was::ThumbnailService::TimemapWaybackParser.new(@uri)
        @wayback_memento_hash = timemap_parser.get_timemap
    	end
    	
    	def get_timemap_difference_list
        database_memento_set = Set.new(@database_memento_hash.keys)
        wayback_memento_set = Set.new(@wayback_memento_hash.keys)
        return wayback_memento_set - database_memento_set
    	end

    end
  end
end
    
#logger.debug "Person attributes hash: #{@person.attributes.inspect}"
#logger.info "Processing the request..."
#logger.fatal "Terminating application, raised unrecoverable error!!!"