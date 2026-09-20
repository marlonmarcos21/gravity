source 'https://rubygems.org'

ruby '3.4.9'

# ActiveSupport 7.2 calls JSON.generate/parse with quirks_mode:, removed in json 3.0
gem 'json', '~> 2.16'

# connection_pool 3.0 made TimedStack#pop keyword-only, which breaks Sidekiq 7's scheduler
gem 'connection_pool', '~> 2.5'

gem 'mutex_m'
gem 'csv'
gem 'nkf'
gem 'observer'
gem 'ostruct'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2'
# Use postgresql as the database for Active Record
gem 'pg'
gem 'pg_search'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
gem 'bootstrap-sass'
# Pinned: 5.1+ ships Bootstrap 5, but this app's markup is Bootstrap 3
# (navbar-fixed-top / navbar-collapse / navbar-toggle / btn-default).
# 5.0.0 ships Bootstrap 3.1.1, which is what production runs.
gem 'twitter-bootstrap-rails', '~> 5.0.0'
gem 'font-awesome-rails', github: 'bokmann/font-awesome-rails'
gem 'select2-rails'
gem 'bootstrap-datepicker-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-easing-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

gem 'rack-timeout'
gem 'puma'

# Flexible authentication solution for Rails with Warden
gem 'devise'

gem 'haml'
gem 'friendly_id'
gem 'paperclip'
gem 'streamio-ffmpeg'
gem 'aws-sdk-s3'
gem 'tinymce-rails', '~> 4.9.4'
gem 'tinymce-rails-imageupload', github: 'marlonmarcos21/tinymce-rails-imageupload'
gem 'simple_form'
gem 'country_select'
gem 'kaminari'
gem 'cancancan'
gem 'htmlentities'
gem 'html_truncator'
gem 'rails_autolink'
gem 'photoswipe-rails'
gem 'acts_as_commentable_with_threading'
# Sidekiq 8 requires a Redis server >= 7.0; .tool-versions pins redis 6.2.6
gem 'sidekiq', '~> 7.3'
gem 'public_activity'
gem 'paper_trail'
gem 'sitemap_generator'
gem 'bootsnap'
gem 'shrine'
gem 'redis', '~> 4'
gem 'after_commit_everywhere'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'awesome_print', '~> 1.6.1'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'hirb', '~> 0.7.2'
  gem 'phantomjs', '>= 1.8.1.1'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rb-readline'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
  gem 'listen'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 4.2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'parallel_tests'
  gem 'rubocop-rails'
  gem 'annotate'
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.2'
  gem 'rspec-activejob'
  gem 'shoulda-matchers', require: false
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
  gem 'wisper-rspec', require: false
  gem 'fakeweb'
  gem 'rails-controller-testing'
end

gem "shakapacker", "= 6.6"

gem "react-rails", "~> 3.3"
