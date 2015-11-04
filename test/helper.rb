

ENV['RACK_ENV'] = 'test'

require_relative '../app'
require_relative '../routes/restapi' # app is the name of your app file

# These two lines are optional but make your other files cleaner

#require 'bundler'
#Bundler.require

require 'rack/test'
require 'minitest/autorun' # optional but makes life easier
require 'minitest/pride' # optional but why would you not
require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'

include Rack::Test::Methods

def app
  Sinatra::Application
end

Capybara.app = NanoTwitter # the name of your app class
Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, :headers =>  { 'User-Agent' => 'Capybara' })
end
