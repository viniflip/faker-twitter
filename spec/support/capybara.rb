require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'

Capybara.always_include_port = true
Capybara.default_driver = :rack_test
