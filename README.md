Kanari
======

# Development

## Requirements

1. Ruby 1.9+ (Use RVM)
2. RubyGems 2.0
3. bundler gem
4. MySql server

## Getting Started

    bundle install
    rake db:create
    rake db:migrate
    foreman start

Point your browser to http://localhost:8080 and you should see the Homepage.

## Build / Tests

To build the project a.k.a run the tests,

    rake db:test:prepare
    rake

## Development on Steroids !
Use zeus to preload your Rails environment so you don't have to wait while running rails commands.
You don't need to run `foreman start` if you decide to go down this rabbit hole.

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
Inspect the request and response using the browser console ( Chrome console / Firebug )

# Production

Not yet.
