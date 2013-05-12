source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0.rc1'

# Use postgres as the database for Active Record
gem 'mysql2' #Database adapter for ActiveRecord
gem 'devise', github: 'plataformatec/devise', branch: 'rails4'
gem 'devise_invitable', github: 'scambra/devise_invitable', branch: 'rails4' #For sending registration invitations
gem 'therubyracer'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0.rc1'

gem "bootstrap-sass" #Use twitter bootstrap for easy layouts

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.0.1'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
gem 'debugger', group: [:development, :test]

#Testing
gem "rspec-rails", :group => [:development, :test] #Unit test framework
gem "database_cleaner", :group => :test #For cleaning database during unit tests
gem "cucumber-rails", :group => :test, :require => false #Behaviour driven development
gem "factory_girl_rails", :group => [:development, :test] #Factory for DB data
gem "email_spec", :group => :test #Use email_spec for testing emails
gem "gmail", :group => :test #Use gmail gem for reading emails

#Development
gem "better_errors", :group => :development
gem "binding_of_caller", :group => :development
gem 'debugger', group: [:development, :test]
gem 'xray-rails', :group => :development

