source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'
gem 'rails-api' #Rails on API mode

gem 'mysql2' #Database adapter for ActiveRecord
gem 'warden', '1.2.3' # warden >= 1.2.3 which has patches for nil Session
gem 'devise', github: 'emilsoman/devise', branch: 'rails4'
gem 'devise_invitable', github: 'emilsoman/devise_invitable', branch: 'rails4' #For sending registration invitations
gem 'cancan' #For authorization
gem 'active_model_serializers' #Serializing ActiveRecord -> JSON

# Javascript server side engine for asset pipeline
gem 'therubyracer'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0.rc1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby



group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

#Testing
gem "rspec-rails", :group => [:development, :test] #Unit test framework
gem "database_cleaner", :group => :test #For cleaning database during unit tests
gem "cucumber-rails", :group => :test, :require => false #Behaviour driven development
gem "factory_girl_rails", :group => [:development, :test] #Factory for DB data
gem "email_spec", :group => :test #Use email_spec for testing emails
gem "gmail", :group => :test #Use gmail gem for reading emails
gem "shoulda-matchers", :group => :test #Collection of Rails testing matchers
gem 'cucumber-api-steps', :require => false, :group => :test #Cucumber steps for API
gem 'json_spec', group: :test # JSON matchers for tests

#Development
gem 'debugger', group: [:development, :test]
gem 'foreman', :group => :development
gem 'rails-erd', :group => :development
