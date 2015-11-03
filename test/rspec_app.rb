
ENV['RACK_ENV'] = 'test'

require 'rspec'
require_relative '../app'
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Sinatra::Application
end

describe 'nanoTwitter' do
  describe 'go to main page' do
    it "shoud go to main page" do
      get '/'
    end
  end
end
