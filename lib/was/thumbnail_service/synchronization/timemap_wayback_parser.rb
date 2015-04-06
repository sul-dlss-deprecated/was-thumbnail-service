module Was
  module ThumbnailService
    module Synchronization
    
      # It responsible of reading the timemap from wayback and parsed the datetime.
      class TimemapWaybackParser
      
        def initialize(uri)
          @uri = uri
        end        
        
        def get_timemap
          timemap_text = read_timemap
          memento_hash = extract_mementos_from_timemap(timemap_text)
          return memento_hash
        end
        
        def read_timemap
          timemap_uri = "#{Rails.configuration.wayback_timemap_uri}#{@uri}"
          
          begin
            response=RestClient.get(timemap_uri,  :timeout => 60, :open_timeout => 60)
            return response
          rescue => e
            puts "Error in retrieving the timemap for #{@uri}.\n#{e.message}"
            return ""
          end
        end
        
        def extract_mementos_from_timemap(timemap_text)
          mementos_hash = {}
  
          memento_string_list = timemap_text.scan(memento_pattern)
          memento_string_list.each do |memento_str|
            memento_hash = extract_memento_from_memento_string(memento_str)
            unless memento_hash.nil? then
              mementos_hash[ memento_hash[:memento_datetime] ] = memento_hash[:memento_uri] 
            end
          end
          return mementos_hash
        end
        
        def extract_memento_from_memento_string(memento_str)
          if memento_str.nil? || memento_str.blank? then 
            return nil
          end
          
          memento_datetime = memento_str.match(/datetime=".*"\z/).to_s[10..-2]
          memento_uri = memento_str.match(/\A<.*>;/).to_s[1..-3]
          if memento_uri.nil? || memento_datetime.nil? then
            return nil
          else
            return {:memento_datetime=>Utilities.convert_date_to_14_digits(memento_datetime), :memento_uri=>memento_uri }
          end
        end
        
        def memento_pattern
          /<.*>;\s+rel=".*memento.*";\s+datetime=".*"/
        end
      end
    end
  end
end