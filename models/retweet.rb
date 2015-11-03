class Retweet < ActiveRecord::Base
	belongs_to :user
  belongs_to :tweet, counter_cache: :retweets_count
end