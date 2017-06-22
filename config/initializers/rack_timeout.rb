Rack::Timeout.wait_timeout = (ENV['WAIT_TIMEOUT'] || 30).to_i
Rack::Timeout.service_timeout = (ENV['SERVICE_TIMEOUT'] || 30).to_i
