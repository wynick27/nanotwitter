require_relative '../clientlib/user_api.rb'
require_relative '../clientlib/tweet_api.rb'
require_relative '../clientlib/follow_api.rb'

describe "client" do
  before(:each) do
    User.base_uri = "http://localhost:4567"
    Tweet.base_uri = "http://localhost:4567"
    Follow.base_uri = "http://localhost:4567"
  end

  it "should get a user by name" do
    user = User.find_by_name("weiyun")
    user["name"].should == "weiyun"
    user["email"].should == "weiyun@brandeis.edu"
  end

  it "should return nil for a user name not found" do
    User.find_by_name("gosling").should be_nil
  end

  it "should get a user by id" do
    user = User.find_by_id(1)
    user["name"].should == "weiyun"
    user["email"].should == "weiyun@brandeis.edu"
  end

  it "should return nil for a user id not found" do
    User.find_by_id(0).should be_nil
  end

  it "should get a tweet by id" do
    tweet = Tweet.find_tweet_by_id(1)
    tweet["text"].should == "Et vel et laborum qui illum. Omnis ullam veritatis qui necessitatibus explicabo."
  end

  it "should return nil for a tweet id not found" do
    Tweet.find_tweet_by_id(0).should be_nil
  end

  it "should get a set of tweets by username" do
    tweet = Tweet.find_user_tweet_by_username("weiyun")
    tweet[0]["text"].should == "Ut minima aut excepturi qui eum culpa. Est rerum et. Quae ut rerum at mollitia et et quia."
  end

  it "should return nil for a username tweet not found" do
    Tweet.find_user_tweet_by_username("gosling").should be_nil
  end

  it "should get a set of tweets by userid" do
    tweet = Tweet.find_user_tweet_by_userid(1)
    tweet[0]["text"].should == "Ut minima aut excepturi qui eum culpa. Est rerum et. Quae ut rerum at mollitia et et quia."
  end

  it "should return nil for a userid tweet not found" do
    Tweet.find_user_tweet_by_userid(0).should be_nil
  end

  it "should get a set of followers by username" do
    followers = Follow.find_follower_by_name("weiyun")
    followers[0]["name"].should == "zhongqil"
  end

  it "should return nil for a username followers not found" do
    Follow.find_follower_by_name("gosling").should be_nil
  end

  it "should get a set of followers by userid" do
    followers = Follow.find_follower_by_id(1)
    followers[0]["name"].should == "zhongqil"
  end

  it "should return nil for a userid followers not found" do
    Follow.find_follower_by_id(0).should be_nil
  end

  it "should get a set of followings by username" do
    followings = Follow.find_following_by_name("zhongqil")
    followings[0]["name"].should == "weiyun"
  end

  it "should return nil for a username followings not found" do
    Follow.find_following_by_name("gosling").should be_nil
  end

  it "should get a set of followings by userid" do
    followings = Follow.find_following_by_id(1)
    followings[0]["name"].should == "nicklausking"
  end

  it "should return nil for a userid followings not found" do
    Follow.find_following_by_id("gosling").should be_nil
  end
end
