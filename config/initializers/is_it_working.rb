require 'is_it_working'
Rails.configuration.middleware.use(IsItWorking::Handler) do |h|
  h.check :active_record, :async => false
end