# frozen_string_literal: true

require 'okcomputer'

# /status for simplest rails app 'upness', e.g. for load balancer
# /status/all to show all dependencies
# /status/<name-of-check> for a specific check
OkComputer.mount_at = 'status'
OkComputer.check_in_parallel = true

# REQUIRED checks, required to pass for /status/all
#  individual checks also avail at /status/<name-of-check>

OkComputer::Registry.register 'ruby_version', OkComputer::RubyVersionCheck.new

OkComputer::Registry.register 'thumbnail_tmp_dir', OkComputer::DirectoryCheck.new(Settings.thumbnail_tmp_directory)
OkComputer::Registry.register 'digital_stacks_dir', OkComputer::DirectoryCheck.new(Settings.image_stacks)

# Settings.wayback_timemap_uri is used to determine if there are new mementos that require additional thumbnails
#  would like a better check, but Settings.wayback_timemap_uri = "https://swap.stanford.edu/timemap/link/" gives HTTP 404 error
wayback_timemap_root_url = "#{Settings.wayback_timemap_uri.split('.edu').first}.edu"
OkComputer::Registry.register 'external-wayback_timemap_root_url', OkComputer::HttpCheck.new(wayback_timemap_root_url)

# check if delayed_job is known to app by looking for any priority and a queue size <= 10,000
OkComputer::Registry.register 'delayed-job-size', OkComputer::DelayedJobBackedUpCheck.new(0, 10_000, greater_than_priority: 0)

# ------------------------------------------------------------------------------

# NON-CRUCIAL (Optional) checks, avail at /status/<name-of-check>
#   - at individual endpoint, HTTP response code reflects the actual result
#   - in /status/all, these checks will display their result text, but will not affect HTTP response code

# Settings.purl_url is used for links to the seed objects in the GUI
OkComputer::Registry.register 'external-purl_status_url', OkComputer::HttpCheck.new("#{Settings.purl_url}status")

# Settings.wayback_uri is used for links to the mementos (crawl objects) in the GUI
#  would like a better check, but Settings.wayback_uri = "https://swap.stanford.edu/*/" gives HTTP 400 error
wayback_root_url = "#{Settings.wayback_uri.split('.edu').first}.edu"
OkComputer::Registry.register 'external-wayback_root_uri', OkComputer::HttpCheck.new(wayback_root_url)

OkComputer.make_optional %w[external-purl_status_url external-wayback_root_uri]
