workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 2)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

before_fork do
  unless Rails.env == 'development'
    PumaWorkerKiller.config do |config|
      config.ram           = (ENV['SYSTEM_RAM'] || 1024).to_i
      config.frequency     = 10
      config.percent_usage = 0.98
      config.rolling_restart_frequency = 6 * 3600
    end
    PumaWorkerKiller.start
  end

  ActiveRecord::Base.connection.disconnect!
end

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
