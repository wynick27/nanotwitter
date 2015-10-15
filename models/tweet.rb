class Tweet < ActiveRecord::Base
  has_many :mentions
	has_many :favourites
	has_many :hashtags
  has_many :retweets
	belongs_to :user
end