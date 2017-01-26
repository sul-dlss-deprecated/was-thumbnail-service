# from http://stackoverflow.com/questions/20081186/how-to-ignore-delayed-job-query-logging-in-development-on-rails
if %w(development test).include? Rails.env
  module Delayed
    module Backend
      module ActiveRecord
        class Job
          class << self
            alias reserve_original reserve
            def reserve(worker, max_run_time = Worker.max_run_time)
              previous_level = ::ActiveRecord::Base.logger.level
              ::ActiveRecord::Base.logger.level = Logger::WARN if previous_level < Logger::WARN
              value = reserve_original(worker, max_run_time)
              ::ActiveRecord::Base.logger.level = previous_level
              value
            end
          end
        end
      end
    end
  end
end
