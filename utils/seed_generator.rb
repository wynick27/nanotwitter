require 'faker'
require_relative '../models/user'        #Model class
require_relative '../models/tweet'
require_relative '../models/retweet'
require_relative '../models/hashtag'
require_relative '../models/follow'
require_relative '../models/favourite'

class FakeData

  def self.gen_user
    dname = Faker::Name.name
      name = dname.gsub(/[^0-9a-zA-Z_]/,'').downcase
      user=User.new_user name: name,display_name:dname ,password:'',email:Faker::Internet.email,create_time:Faker::Time.between(2.years.ago, Time.now, :all),bio:Faker::Lorem.paragraph(1, false, 3)
      if user.valid?
        user.save
      end
      user
  end
  
  def self.gen_users(num)
    users=[]
    num.times do
      user=gen_user
      users<<user
    end
    users
  end
  
  def self.gen_tweets(user,num)
    tweets=[]
    ActiveRecord::Base.transaction do  
      num.times do
        tweet=user.new_tweet(text:Faker::Lorem.paragraph(1, false, 4),create_time:Faker::Time.between(60.days.ago, Time.now, :all))
        tweet.save
        tweets<<tweet
      end
    end
    tweets
  end
  
  def self.gen_followers(curuser,num)
    usercount=User.count
    users=User.order("RANDOM()").where.not(:id=>curuser.id).limit(num)
    ActiveRecord::Base.transaction do  
      users.each do |user|
        curuser.followers << user
      end
    end
    users
  end

end