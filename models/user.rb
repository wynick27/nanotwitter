class User < ActiveRecord::Base
  has_many :follows
  has_many :followed_users, :through => :follows
  has_many :followings, :class_name => "Follow",
    :foreign_key => :follower_id
  has_many :followers, :through => :followings,
    :source => :user
  has_many :favourates
  has_many :tweets
  validates :email, uniqueness: true
  validates :name, uniqueness: true
end