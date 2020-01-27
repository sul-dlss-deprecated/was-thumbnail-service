# frozen_string_literal: true

module Was
  module ThumbnailService
    module Synchronization
      # It responsible of reading the timemap from wayback and parsed the datetime.
      class TimemapWaybackParser
        def initialize(uri)
          @uri = uri
        end

        def timemap
          timemap_text = read_timemap
          memento_hash = extract_mementos_from_timemap(timemap_text)
          memento_hash
        end

        def read_timemap
          return '' if @uri.blank?
          timemap_uri = "#{Settings.wayback_timemap_uri}#{@uri}"

          begin
            response = Faraday.get(timemap_uri)
            raise "#{response.reason_phrase}: #{response.status} for #{timemap_uri}" unless response.success?
            response.body
          rescue StandardError => e
            Honeybadger.notify e, context: { timemap_uri: timemap_uri }
            Rails.logger.error { "Error in retrieving the timemap from #{timemap_uri}.\n#{e.message}\n#{e.backtrace}" }
            ''
          end
        end

        def extract_mementos_from_timemap(timemap_text)
          mementos_hash = {}

          memento_string_list = timemap_text.scan(memento_pattern)
          memento_string_list.each do |memento_str|
            memento_hash = extract_memento_from_memento_string(memento_str)
            mementos_hash[ memento_hash[:memento_datetime] ] = memento_hash[:memento_uri] unless memento_hash.nil?
          end
          mementos_hash
        end

        def extract_memento_from_memento_string(memento_str)
          return nil if memento_str.nil? || memento_str.blank?

          memento_datetime = memento_str.match(/datetime=".*"\z/).to_s[10..-2]
          memento_uri = memento_str.match(/\A<.*>;/).to_s[1..-3]
          return if memento_uri.nil? || memento_datetime.nil?
          {
            memento_datetime: Utilities.convert_date_to_14_digits(memento_datetime),
            memento_uri: memento_uri
          }
        end

        def memento_pattern
          /<.*>;\s+rel=".*memento.*";\s+datetime=".*"/
        end
      end
    end
  end
end
