module Was
  module ThumbnailService
    module Synchronization
      class MementoDatabaseHandler
        
        def initialize(uri_id, memento_uri, memento_datetime)
          @uri_id = uri_id
          @memento_datetime = memento_datetime
          @memento_uri = memento_uri
        end
        
        def add_memento_to_database_timemap
          memento_text = download_memento_text
          @simhash_value = compute_simhash_value(memento_text)
          insert_memento_into_databse
        end
        
        def insert_memento_into_databse
          unless  @uri_id.present? &&  @memento_uri.present? && @memento_datetime.present? &&
                   !@simhash_value.nil? && @simhash_value > 0 then
            
            raise "Memento insert is missing required fields. "+
                  "Uri-id: #{@uri_id}, Memento-uri: #{@memento_uri}, "+ 
                  "Memento-datetime: #{@memento_datetime}, Simhash_value: #{@simhash_value}"
          end
          
          memento = Memento.new   
          memento[:uri_id] = @uri_id
          memento[:memento_uri] = @memento_uri
          memento[:memento_datetime] = @memento_datetime
          memento[:simhash_value] = @simhash_value
          memento[:is_selected] = 0
          memento[:is_thumbnail_captured] = 0 
          memento.save
        end
        
        def compute_simhash_value(memento_text)
          if memento_text.present? then
            return memento_text.force_encoding("UTF-8").simhash(:preserve_punctuation => true, :stop_words => false)
          else
            return 0
          end
        end
        
        def download_memento_text
          
          # Insert id_ after the datetime part in the uri to avoid
          # the wayback rewritten
          if @memento_uri.nil? || @memento_uri.empty? then
             return "" 
          end
          datetime_path = @memento_uri.match(/\/\d+{14}\//).to_s
          if datetime_path.length == 0 then
            return ""
          end
            
          memento_uri_unwritten = @memento_uri.sub(datetime_path, datetime_path[0..-2]+"id_/")
          begin
            response=RestClient.get(memento_uri_unwritten, :timeout => 60, :open_timeout => 60)
            return response
          rescue => e
            Rails.logger.error{ "Error in downloading memento text.\n#{e.message}\n#{e.backtrace}"}
            return ""
          end
        end
      end
    end
  end
end