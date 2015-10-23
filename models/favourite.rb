class Favourite < ActiveRecord::Base
  belongs_to :users
  belongs_to :tweets
end