require_relative 'boot'

require 'rails/all'

GC::Profiler.enable

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gravity
  class Application < Rails::Application
    config.i18n.enforce_available_locales = true

    config.action_controller.action_on_unpermitted_parameters = :raise

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(
      #{config.root}/app/concerns/
      #{config.root}/app/controllers/concerns/
      #{config.root}/app/inputs/
      #{config.root}/app/jobs/
      #{config.root}/app/mailers/concerns/
      #{config.root}/app/models/concerns/
      #{config.root}/app/lib/
      #{config.root}/app/workers/concerns/
    )

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.time_zone = 'Singapore'

    config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    config.generators do |g|
      g.template_engine :haml
    end

    config.active_job.queue_adapter = :sidekiq
  end
end
