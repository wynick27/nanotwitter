class Follow < ActiveRecord::Base
  belongs_to :user, counter_cache: :followed_users_count
  belongs_to :follower, :class_name => "User", :counter_cache=>:followers_count
end