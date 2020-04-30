# frozen_string_literal: true

job_type :no_warnings_rake, "cd :path && :environment_variable=:environment RUBYOPT='-W0' bundle exec rake :task --silent :output"

every 30.minutes do
  no_warnings_rake 'was_thumbnail_service:run_thumbnail_monitor'
end
