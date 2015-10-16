
require 'pry-byebug'
#binding.pry
require_relative '../nano_app'
#require File.dirname(__FILE__) + '/../app'
require 'rspec'


describe "it initialize" do

  before(:each) do
      @user = nil
      u1=User.create(
         :name => "person1",
         :email => "p1@pauldix.net",
         :password => "1",
         :display_name => "Per1",
         :create_time => Time.now )

     u2=User.create(
        :name => "person2",
        :email => "p2@pauldix.net",
        :password => "2",
        :display_name => "Per2",
        :create_time => Time.now )

    u3=User.create(
       :name => "person3",
       :email => "p3@pauldix.net",
       :password => "3",
       :display_name => "Per3",
       :create_time => Time.now )

    u1.followed_users << u2
    u3.followed_users << u1

    Tweet.create(
        :text => "This is sample for person1",
        :create_time => Time.now,
        :user => u1.id)
  end

  describe "GET on /api/v1/users/:name" do
    it "should return info about the person throgh username" do
        get '/api/v1/users/lizhongqi'
        last_response.should be_ok
        attributes = JSON.parse(last_response.body)
        attributes["name"].should == "lizhongqi"
    end
  end
  
  describe "GET on /api/v1/users/:id" do
    it "should return info about the person through id" do
        get '/api/v1/users/1'
        last_response.should be_ok
        attributes = JSON.parse(last_response.body)
        attributes["id"].should == "1"

    end
  end


end
