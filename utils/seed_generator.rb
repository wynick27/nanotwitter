require 'faker'
require_relative '../models/user'        #Model class
require_relative '../models/tweet'
require_relative '../models/retweet'
require_relative '../models/hashtag'
require_relative '../models/follow'
require_relative '../models/mention'
require_relative '../models/favourite'

class FakeData

  def self.gen_user
    dname = Faker::Name.name
      name = dname.gsub(/[^0-9a-zA-Z_]/,'').downcase
      user=User.create name: name,display_name:dname ,password:'',email:Faker::Internet.email,create_time:Faker::Date.backward(60),bio:Faker::Lorem.paragraph(1, false, 3)
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
    
    ActiveRecord::Base.transaction do  
      num.times do
        tweet=user.tweets.create(text:Faker::Lorem.paragraph(1, false, 4),create_time:Faker::Date.backward(10))
        tweet.conversation_root=tweet.id
        tweet.save
      end
    end
  end
  
  def self.gen_followers(curuser,num)
    usercount=User.count
    users=User.order("RANDOM()").limit(num)
    users.each do |user|
      if user.id!=curuser.id
        curuser.followers << user
      end
    end
  end

end