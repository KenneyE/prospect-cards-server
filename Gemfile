source('https://rubygems.org')
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby('2.7.2')

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
# gem 'rails', '~> 6.0.3'
gem 'rails', github: 'rails/rails', branch: 'master'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'apollo_upload_server', '2.0.1'
gem 'devise'
gem 'devise-jwt'
gem 'graphql'

gem 'nilify_blanks'
gem 'paper_trail'
gem 'acts_as_list'
gem 'sidekiq'
gem 'memoist'

gem 'money'

gem 'aws-sdk-s3', require: false
gem 'elasticsearch-rails', '~> 7.0'
gem 'searchkick'
gem 'stripe'

gem 'imgix-rails'

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 4.0'
  gem 'parallel_tests'
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'spring-commands-rspec'
  gem 'webmock'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'brakeman'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'

  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
