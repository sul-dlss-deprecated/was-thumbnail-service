module Was
  module ThumbnailService
    class CaptureThumbnail
      
      def initialize(id, druid_id, memento_uri, memento_datetime)
        @id = id
        @druid_id = druid_id
        @memento_uri = memento_uri
        @memento_datetime = memento_datetime
        @temporary_file = "#{Rails.configuration.thumbnail_tmp_directory}/#{@memento_datetime}.jpg"
      end
      
      def process_thumbnail
        result = capture 
        if result.length > 0 then
          if File.exist?(@temporary_file) then File.delete(@temporary_file) end
          raise "Thumbnail for memento #{@memento_uri} can't be generated."
        end
        save_to_stack
        update_database
      end
      
      def capture
        result = ""
        begin
          result = Phantomjs.run(Rails.configuration.phantom_js_script, @memento_uri, @temporary_file)
        rescue Exception => e 
          result = result +"\nException in generating thumbnail. #{e.message}\n#{e.backtrace.inspect}"
        end
        return result
      end
      
      def update_database
        memento = Memento.find @id
        memento.update(is_thumbnail_captured: "true")
      end
      
      def save_to_stack
        puts @druid_id
        stacks_dir = DruidTools::StacksDruid.new(@druid_id, Rails.configuration.image_stacks).content_dir
        thumbnail_file = "#{stacks_dir}/#{@memento_datetime}.jpg"
        FileUtils.mv @temporary_file, thumbnail_file
      end
    end
  end
end