Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  
  
  # Project specific configuration
  config.wayback_timemap_uri = ""
  config.phantom_js_script = "scripts/rasterize.js"
  config.thumbnail_tmp_directory = "tmp"
  config.image_stacks = ""
  config.image_stacks_uri = ""
end

#Bluepill.application("was-thumbnail-service", :foreground => true) do |app|
#  app.process("delayed_job") do |process|
#    process.working_dir = "/Users/aalsum/CodeWorkspace/was-thumbnail-service/"

   # process.start_grace_time    = 10.seconds
   # process.stop_grace_time     = 10.seconds
   # process.restart_grace_time  = 10.seconds

    #process.start_command = "RAILS_ENV=development bin/delayed_job start"
    #process.stop_command  = "RAILS_ENV=development bin/delayed_job stop"

    #process.pid_file = "/Users/aalsum/CodeWorkspace/was-thumbnail-service/tmp/pids/delayed_job.pid"
    #process.uid = "deploy"
    #process.gid = "deploy"
  #end
#end
