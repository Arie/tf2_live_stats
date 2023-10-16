WebsocketRails.setup do |config|
  config.log_level = :debug
  config.log_internal_events = false
  config.synchronize = false
  config.standalone = true
  config.standalone_port = 9001
  config.redis_options = {:host => 'REDIS_ADDRESS', :port => 'REDIS_PORT'}
end
