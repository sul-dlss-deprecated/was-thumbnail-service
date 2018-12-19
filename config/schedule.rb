# frozen_string_literal: true

every 30.minutes do
  rake 'was_thumbnail_service:run_thumbnail_monitor'
end
