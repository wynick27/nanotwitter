
ENV['RACK_ENV'] = 'test'

require 'rspec'
require_relative '../app'
require_relative '..//models/tweet'
require 'rack/test'
require 'pry-byebug'


RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Sinatra::Application
end

#user_sample1.followers.any? {|single| single.name == "sample" }

describe "unit tests nanotwitter" do
  before(:each) do
    Tweet.destroy_all
    User.destroy_all
    Follow.destroy_all
  end

  #user1 = User.new name: "sample",display_name: "SampleName",email: "sample@sample.com",password: "password"
  #user2 = User.new name: "sample1",display_name: "SampleNameOne",email: "sampleone@sample.com",password: "password"

  it 'should check the timeline of user' do
    user = User.new name: "sample",display_name: "SampleName",email: "sample@sample.com",password: "password"
    user.save
    tweet=user.tweets.create(text:"this is a test for unit test",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    time_line = Tweet.user_timeline(user)
    time_line.any? {|single| single.id == tweet.id}.should == true
  end

  it 'should check the timeline of user and check the tweets from other user' do
    user = User.new name: "sample",display_name: "SampleName",email: "sample@sample.com",password: "password"
    user.save
    user2 = User.new name: "sample1",display_name: "SampleNameOne",email: "sampleone@sample.com",password: "password"
    user2.save
    user.followers << user2
    tweet=user.tweets.create(text:"this is a test for unit test",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    time_line = Tweet.user_timeline(user2)
    time_line.any? {|single| single.id == tweet.id}.should == true
  end


  it 'should check the tweets of user' do
    user = User.new name: "sample",display_name: "SampleName",email: "sample@sample.com",password: "password"
    user.save
    tweet=user.tweets.create(text:"this is a test for unit test for user_tweets",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    t = Tweet.user_tweets(user)
    t.any? {|single| single.id == tweet.id}.should == true
  end

  it 'should show all the tweets reply to a single tweet' do
    user = User.new name: "sample",display_name: "SampleName",email: "sample@sample.com",password: "password"
    user.save
    tweet=user.tweets.create(text:"THis is test for user_tweets_with_replies",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    user_reply = User.new name: "sample1",display_name: "SampleNameOne",email: "sampleone@sample.com",password: "password"
    user_reply.save
    tweet_reply=user.tweets.create text:"sample reply",create_time:Time.now,reply_to:tweet.id,conversation_root:tweet.conversation_root,reply_level:(tweet.reply_level+1)
    tweet_reply.save
    tweets = Tweet.user_tweets_with_replies(user)
    tweets.first.id.should == tweet_reply.id
  end

  it 'should check if the tweet is retweeted by the user' do
    user = User.new name: "sample",display_name: "SampleName",email: "sample@sample.com",password: "password"
    user.save
    tweet=user.tweets.create(text:"THis is test for checking retweeted_by",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    user_retweet = User.new name: "sample1",display_name: "SampleNameOne",email: "sampleone@sample.com",password: "password"
    user_retweet.save
    user_retweet.retweets.create tweet_id:tweet.id,create_time:Time.now
    tweets = Tweet.user_tweets(user_retweet)
    tweets.first.id.should == tweet.id
  end

  it 'should search one term from user and return the tweet' do
    user = User.new name: "sample",display_name: "SampleName",email: "sample@sample.com",password: "password"
    user.save
    tweet=user.tweets.create(text:"THis is test for checking retweeted_by",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    tweet2=user.tweets.create(text:"THis is test for checking retweeted_by and this is the second one",create_time:Time.now)
    tweet2.conversation_root=tweet2.id
    tweet2.save
    search_result = search_one_without_user(user.tweets,"retweeted_by",user)
    search_result.length.should == 2
  end

=begin
  ################ NOT DONE YET #################
  it 'should show all the tweets reply to a single tweet and return the newest one' do
    user = User.new name: "sample",display_name: "SampleName",email: "sample@sample.com",password: "password"
    user.save
    tweet=user.tweets.create(text:"THis is test for user_tweets_with_replies",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    user_reply = User.new name: "sample1",display_name: "SampleNameOne",email: "sampleone@sample.com",password: "password"
    user_reply.save
    tweet_reply=user.tweets.create text:"sample reply",create_time:Time.now,reply_to:tweet.id,conversation_root:tweet.conversation_root,reply_level:(tweet.reply_level+1)
    tweet_reply.save
  end
=end
end
