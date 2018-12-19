# frozen_string_literal: true

module Was
  module ThumbnailService
    class Utilities
      
      def self.convert_date_to_14_digits(time_object)
        return Time.parse(time_object).utc.strftime("%Y%m%d%H%M%S")        
      end
      
    end
  end
end
