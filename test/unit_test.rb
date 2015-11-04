
ENV['RACK_ENV'] = 'test'

require 'rspec'
require_relative '../app'
require_relative '..//models/tweet'
require 'rspec'
require 'rack/test'


RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app
  Sinatra::Application
end

#user_sample1.followers.any? {|single| single.name == "sample" }

describe "unit tests nanotwitter" do
  it 'should check the timeline of user' do
    user = User.find_by name: 'sample'
    tweet=user.tweets.create(text:"this is a test for unit test",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    time_line = Tweet.user_timeline(user)
    time_line.any? {|single| single.id == tweet.id}.should == true
  end

  it 'should check the tweets of user' do
    user = User.find_by name: 'sample'
    tweet=user.tweets.create(text:"this is a test for unit test for user_tweets",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    t = Tweet.user_tweets(user)
    t.any? {|single| single.id == tweet.id}.should == true
  end

  it 'should show all the tweets reply to a single tweet' do
    user = User.find_by name: 'sample'
    tweet=user.tweets.create(text:"THis is test for user_tweets_with_replies",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    user_reply = User.find_by name: 'sample1'
    tweet_reply=user.tweets.create text:"sample reply",create_time:Time.now,reply_to:tweet.id,conversation_root:tweet.conversation_root,reply_level:(tweet.reply_level+1)
    tweet_reply.save
    tweets = Tweet.user_tweets_with_replies(user)
    tweets.first.id.should == tweet_reply.id
  end

  it 'should check if the tweet is retweeted by the user' do
    user = User.find_by name: 'sample'
    tweet=user.tweets.create(text:"THis is test for checking retweeted_by",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    user_retweet = User.find_by name: 'sample1'
    user_retweet.retweets.create tweet_id:tweet.id,create_time:Time.now
    tweets = Tweet.user_tweets(user_retweet)
    tweets.first.id.should == tweet.id
  end
=begin
  it 'should show all the tweets favourited by user' do
    user = User.find_by name: 'sample'
    tweet=user.tweets.create(text:"THis is test for favourtied_by user",create_time:Time.now)
    tweet.conversation_root=tweet.id
    tweet.save
    user.favourites.create tweet_id:tweet.id,create_time:Time.now
    user.save
    tweet.favourited_by?(user).should == true
  end
=end
end
