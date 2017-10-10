module Was
  module ThumbnailService
    module Synchronization
      class MementoDatabaseHandler
        def initialize(uri_id, memento_uri, memento_datetime)
          @uri_id = uri_id
          @memento_uri = memento_uri
          @memento_datetime = memento_datetime
        end

        def add_memento_to_database_timemap
          memento_text = download_memento_text
          @simhash_value = compute_simhash_value(memento_text)
          insert_memento_into_databse
        end

        def insert_memento_into_databse
          unless  @uri_id.present? &&  @memento_uri.present? && @memento_datetime.present? &&
                   !@simhash_value.nil? && @simhash_value > 0

            raise 'Memento insert is missing required fields. '+
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
          if memento_text.present?
            memento_text.simhash(:preserve_punctuation => true, :stop_words => false)
          else
            0
          end
        end

        def download_memento_text
          return '' if @memento_uri.nil? || @memento_uri.empty?
          datetime_path = @memento_uri.match(/\/\d+{14}\//).to_s
          return '' if datetime_path.empty?

          # Insert id_ after the datetime part in the uri to avoid wayback rewriting page w its own header
          memento_uri_unwritten = @memento_uri.sub(datetime_path, datetime_path[0..-2]+'id_/')
          begin
            # NOTE:  these timeouts don't work - wrong
            # response = RestClient.get(memento_uri_unwritten, :timeout => 60, :open_timeout => 60)
            RestClient.get(memento_uri_unwritten).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')

            # NOTE:  if the url gives a 302 to the original, non-wayback url, then who is to say that page still is extant?
            #   and then the 302 becomes a 404, which blows up here.
          rescue RestClient::Exception => e
            raise "RestClient error downloading memento text from #{memento_uri_unwritten}.\n#{e.inspect}\nHTTP Status code: #{e.http_code}\n#{e.backtrace.join(%(\n))}"
          end
        end
      end
    end
  end
end
