class Favourite < ActiveRecord::Base
  belongs_to :user
  belongs_to :tweet,counter_cache: :favourites_count
end