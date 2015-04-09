module Was
  module ThumbnailService
    class Monitor
      
      def self.run
        seed_uris = SeedUri.all
        
        seed_uris.each do |seed_uri|
          uri = seed_uri[:uri]
          uri_id = seed_uri[:id]
          
          mementos_db_count = self.count_mementos_in_database uri_id
          mementos_wayback_count = self.count_mementos_in_wayback uri
          # This kind of check assumes that the wayback will not remove mementos after
          # being indexed.
          if mementos_wayback_count > mementos_db_count then
            Was::ThumbnailService::Generator.new(uri, uri_id).run
          end
        end
      end
      
      def self.count_mementos_in_wayback uri
        timemap_parser = Was::ThumbnailService::Synchronization::TimemapWaybackParser.new(uri)        
        wayback_memento_hash = timemap_parser.get_timemap
        unless wayback_memento_hash.nil? then
          return wayback_memento_hash.keys.count
        end
        return 0
      end
      
      def self.count_mementos_in_database uri_id
        Memento.where("uri_id = ?",uri_id).count()
      end
    end
  end
end
   