require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative '../lib/was/thumbnail_service/synchronization/timemap_wayback_parser'
require_relative '../lib/was/thumbnail_service/synchronization/timemap_database_parser'
require_relative '../lib/was/thumbnail_service/synchronization/timemap_synchronization'
require_relative '../lib/was/thumbnail_service/synchronization/memento_database_handler'
require_relative '../lib/was/thumbnail_service/picker/memento_picker'
require_relative '../lib/was/thumbnail_service/picker/memento_picker_threshold_grouping'
require_relative '../lib/was/thumbnail_service/capture/capture_thumbnail'
require_relative '../lib/was/thumbnail_service/capture/capture_controller'
require_relative '../lib/was/thumbnail_service/capture/capture_job'
require_relative '../lib/was/thumbnail_service/monitor'
require_relative '../lib/was/thumbnail_service/generator'
require_relative '../lib/was/thumbnail_service/utilities'

module WasThumbnailService
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.active_record.schema_format = :sql

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/was/**/*"]
    config.logger = Logger.new("was_thumbnail_service.log")
  #  Rails.logger.level = 0   
    
  end
end
