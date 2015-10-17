
require 'pry-byebug'
#binding.pry
require_relative '../nano_api'
#require File.dirname(__FILE__) + '/../app'
require 'rspec'


#attributes = JSON.parse(last_response.body)
#attributes["name"].should == "trotter"
#attributes["email"].should == "no spam"
#attributes["bio"].should == "southern belle"


describe "check the data in the database" do
  describe "GET on /api/v1/users/username/:name" do
    it "should return info about the person throgh username" do
        get '/api/v1/users/username/lizhongqi'
        attributes = JSON.parse(last_response.body)
        last_response.should be_ok
        #attributes = JSON.parse(last_response.body)
        #attributes["name"].should == "lizhongqi"
    end
  end
end
