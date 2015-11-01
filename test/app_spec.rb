
ENV['RACK_ENV'] = 'test'

require 'pry-byebug'
require_relative '../app'
require_relative '../routes/restapi'
require "minitest/autorun"
require 'rack/test'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe NanoTwitter do
  it "it will create a new user" do

    post '/register', {:name => "sampleUser",
      :display_name => "sample user",
      :email => "sample@sample.com",
      :passwords => "sample"}
      #binding.pry
      username = "sampleUser"
      user = User.find_by name: username
      #binding.pry
      user.display_name.must_equal "sample users"
  end
end
