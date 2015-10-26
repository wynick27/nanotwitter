class Tweet < ActiveRecord::Base
  has_many :mentions
	has_many :favourites
	has_many :hashtags
  has_many :retweets
	belongs_to :user
  
  def self.user_timeline(user) 
    Tweet.includes(:user).from("(#{user.tweets.to_sql} UNION #{Tweet.where(:user_id=>user.followed_users).to_sql}) as tweets")
  end
  
  def self.user_tweets(user)
    Tweets.includes(:user).from("(#{user.tweets.to_sql} UNION #{Tweet.where(:tweet_id=>user.retweets).to_sql}) as tweets")
  end
  
  def self.user_tweets_with_replies(user)
    Tweets.includes(:user).from("(#{user.tweets.to_sql} UNION #{Tweet.where(:tweet_id=>user.retweets).to_sql}) as tweets")
  end
  def to_html
    erb :show_tweet,:locals=>{:tweet=>self}
  end
end