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

Using RVM for Ruby version management is recommended.
[This blog post](http://ryanbigg.com/2010/12/ubuntu-ruby-rvm-rails-and-you/) talks about setting up an environment with Ruby 1.9.
Setting up Ruby 2.0 using RVM is not very different from the steps in the article. You may want to look into `--autolibs` flag
of RVM which will automatically install the dependencies for you while installing a Ruby version to make things simpler.

After you have installed Ruby and bundler ruby gem, see the "Getting Started" section to start the application

## Getting Started

    #Install and use the RubyGems specified in `Gemfile` the application
    bundle install

    #Create the database named `kanari_development`. This needs to be run only once
    rake db:create

    #Update the database to the latest schema
    rake db:migrate

    #Runs the application by starting the processes in `Procfile`
    foreman start

Point your browser to http://localhost:8080 and you should see the Homepage.

## Build / Tests

To build the project a.k.a run the tests,

    rake db:test:prepare
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

Not yet.
