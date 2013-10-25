Kanari
======

# Development

## Requirements

Kanari server is a Rails 4 application that is developed on Ruby 2.0.
For the development environment it’s recommended to use the latest stable Ubuntu operating system ( 12.04 + ).

You need to install these :

1. Ruby 1.9+ ( Development happens on Ruby 2.0 )
2. RubyGems 2.0
3. bundler ruby gem
4. MySql server
5. Postfix ( for sending emails ) - `sudo apt-get install postfix`

Using RVM for Ruby version management is recommended.

### Installing RVM and Ruby in a fresh linux box (as a non root user) :

1. sudo apt-get install curl
2. \curl -L https://get.rvm.io | bash -s stable --ruby
3. In a new terminal if `rvm list` doesn't show the instaled ruby, start terminal as login shell. (Open your terminal and see the settings)

[This blog post](http://ryanbigg.com/2010/12/ubuntu-ruby-rvm-rails-and-you/) talks about setting up an environment with Ruby 1.9.
Setting up Ruby 2.0 using RVM is not very different from the steps in the article and you should already have Ruby 2.0 if you
followed the above instructions.


After you have installed Ruby and bundler ruby gem, see the "Getting Started" section to start the application

## Getting Started

    #Install and use the RubyGems specified in `Gemfile` the application
    bundle install

    #Create the database named `kanari_development`. This needs to be run only once
    rake db:create

    #Update the database to the latest schema
    rake db:migrate

    #Setup default data
    rake db:seed

    #Runs the application by starting the processes in `Procfile`
    foreman start

Point your browser to http://localhost:8080 and you should see the Homepage.

## Build / Tests

To build the project a.k.a run the tests,

    RAILS_ENV=test rake db:migrate
    rake

## Development on Steroids
Use zeus to preload your Rails environment so you don't have to wait while running rails commands.
You don't need to run `foreman start` if you decide to go down this route.

    gem install zeus
    zeus init ( inside the project root )
    zeus start

    #Run RSpecs
    zeus rspec spec

    #Run Cucumber features
    zeus cucumber

    zeus s #Rails server
    zeus c #Rails console

## Problem ?

Check the logs first. `tail -f log/development.log` should print the logs as they are generated.
Inspect the request and response using the browser console ( Chrome console / Firebug ).
Talk to a duck.

# Production

    bundle install
    rake db:create RAILS_ENV=production
    rake db:migrate RAILS_ENV=production
    mv db/test_seeds.rb db/seeds.rb && rake db:seed RAILS_ENV=production # If you need the seed data
    #Configure SSL - TODO
    rake assets:precompile RAILS_ENV=production

## Configure Email server

1. Edit config/environments/production.rb, change the following line :

    config.action_mailer.default_url_options = { :host => '<host_name(example: app.kanari.com)>' }

2. Change SMTP settings to use the Email service (for example AWS SES)


Uncomment the following line from `config/environments/production.rb` after setting up a webserver to serve static assets
from the `public` directory of the application.

    config.serve_static_assets = false

Keep the above line commented to run the application without a webserver.

    unicorn -E production #Starts unicorn on port 8080

# Misc information

## Taking a database seed dump

     rake db:seed:dump FILE="kanari_seed_data.rb" WITH_ID=true
