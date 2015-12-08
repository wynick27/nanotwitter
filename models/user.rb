class User < ActiveRecord::Base
  has_many :follows
  has_many :followed_users, :through => :follows,:source => :follower
  has_many :followings, :class_name => "Follow",
    :foreign_key => :follower_id
  has_many :followers, :through => :followings,
    :source => :user
  has_many :favourites
  has_many :tweets
  has_many :retweets
  has_many :conversations
  has_many :chat_groups, :through => :conversations
  validates :email, uniqueness: true
  validates :name, uniqueness: true
  #validates :name, format: { with: /[\w\d]+/ , message: "only allows letters" }
  def new_tweet(params={})
    text=Rack::Utils.escape_html(params[:text])
    text=Tweet.parse_tweet(text)
    tweet=self.tweets.create(text:text,reference:params[:reference],create_time:params[:create_time] || Time.now)
    tweet.conversation_root=tweet.id
    tweet.extract_hashtag
    tweet
  end
  def new_reply(tweet,text)
    reply=new_tweet text:text
    reply.reply_to=tweet.id
    reply.conversation_root=tweet.conversation_root
    reply.reply_level=(tweet.reply_level+1)
    reply
  end
  def self.new_user(params={})
    user=User.create(name:params[:name],display_name:params[:display_name],email:params[:email] || "",password:params[:password] || "",bio:params[:bio] || "",create_time:params[:create_time] || Time.now)
    user
  end
  
  def self.search(name) 
    User.where("lower(name) like ? or lower(display_name) like ?",name+"%",name+"%")
  end
end