class Favourite < ActiveRecord::Base
  belongs_to :user, counter_cache: :favourites_count
  belongs_to :tweet,counter_cache: :favourites_count
end