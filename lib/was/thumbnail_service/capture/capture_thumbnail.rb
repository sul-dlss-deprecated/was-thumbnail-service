module Was
  module ThumbnailService
    module Capture
      class CaptureThumbnail
        
        def initialize(id, druid_id, memento_uri, memento_datetime)
          @id = id
          @druid_id = druid_id
          @memento_uri = memento_uri
          @memento_datetime = memento_datetime
          @temporary_file = "#{Rails.configuration.thumbnail_tmp_directory}/#{@memento_datetime}"
        end
        
        def process_thumbnail
          result = capture
          if (result.length > 0 && result.starts_with?('#FAIL#')) then
            if File.exist?(@temporary_file) then File.delete(@temporary_file) end
            raise "Thumbnail for memento #{@memento_uri} can't be generated.\n#{result}"
          end
          if Rails.configuration.jp2_required then
              Assembly::Image.new(@temporary_file+'.jpeg').create_jp2(:output=>@temporary_file+".jp2")
              FileUtils.rm @temporary_file+'.jpeg'
          end
          save_to_stack
          update_database
        end
        
        def capture
          result = ""
          begin
            result = Phantomjs.run(Rails.configuration.phantom_js_script, @memento_uri, @temporary_file+".jpeg")
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
          stacks_dir = DruidTools::StacksDruid.new(@druid_id, Rails.configuration.image_stacks).content_dir
          if Rails.configuration.jp2_required then
            thumbnail_file = "#{stacks_dir}/#{@memento_datetime}.jp2"
            FileUtils.mv @temporary_file+'.jp2', thumbnail_file
          else
            thumbnail_file = "#{stacks_dir}/#{@memento_datetime}.jpeg"
            FileUtils.mv @temporary_file+".jpeg", thumbnail_file
          end
        end
      end
    end
  end
end