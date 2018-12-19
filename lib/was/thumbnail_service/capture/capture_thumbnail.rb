# frozen_string_literal: true

require 'mini_magick'

module Was
  module ThumbnailService
    module Capture
      class CaptureThumbnail

        def initialize(id, druid_id, memento_uri, memento_datetime)
          @id = id
          @druid_id = druid_id
          @memento_uri = memento_uri
          @memento_datetime = memento_datetime
          @temporary_file = "#{Settings.thumbnail_tmp_directory}/#{@memento_datetime}"
        end

        def process_thumbnail
          result = capture
          if result.length.positive? && result.starts_with?('#FAIL#')
            File.delete(@temporary_file) if File.exist?(@temporary_file)
            raise "Thumbnail for memento #{@memento_uri} can't be generated.\n#{result}"
          end

          resize_temporary_image(@temporary_file + '.jpeg')
          if Settings.jp2_required
              Assembly::Image.new(@temporary_file + '.jpeg').create_jp2(:output=>@temporary_file + '.jp2')
              FileUtils.rm @temporary_file + '.jpeg'
          end
          save_to_stack
          update_database
        end

        def capture
          result = ''
          begin
            result = Phantomjs.run(Settings.phantom_js_script, @memento_uri, @temporary_file + '.jpeg')
          rescue StandardError => e
            Rails.logger.warn e
            result = result + "\nException in generating thumbnail. #{e.message}\n#{e.backtrace.inspect}"
          end
          return result
        end

        def update_database
          memento = Memento.find @id
          memento.update(is_thumbnail_captured: 'true')
        end

        def save_to_stack
          stacks_dir = DruidTools::StacksDruid.new(@druid_id, Settings.image_stacks).content_dir
          if Settings.jp2_required
            thumbnail_file = "#{stacks_dir}/#{@memento_datetime}.jp2"
            FileUtils.mv @temporary_file + '.jp2', thumbnail_file
          else
            thumbnail_file = "#{stacks_dir}/#{@memento_datetime}.jpeg"
            FileUtils.mv @temporary_file + '.jpeg', thumbnail_file
          end
        end
        def resize_temporary_image(temporary_image)
          image = MiniMagick::Image.open(temporary_image)
          width = image.width
          height = image.height

          if width > height
            resize_dimension = ' 400x '
          else
            resize_dimension = ' x400 '
          end
          image.resize resize_dimension
          image.write(temporary_image)
        end

      end
    end
  end
end
