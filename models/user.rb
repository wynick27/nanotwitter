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
end