require './utils/seed_generator'

  NanoTwitter.get %r{^/test/seed/(\d+)$} do |num|
    num=num.to_i
    users=FakeData::gen_users(num)
    users.to_json
  end

  NanoTwitter.get %r{^/test/tweets/(\d+)$} do |num|
    num=num.to_i
    begin
      testuser=User.find_by name: 'testuser'
      if !testuser then return "No test User!" end
      tweets=FakeData::gen_tweets(testuser,num)
      tweets.to_json
    end
  end

  NanoTwitter.get %r{^/test/follow/(\d+)$} do |num|
    num=num.to_i
      testuser=User.find_by name: 'testuser'
      if !testuser then return "No test User!" end
      followers=FakeData::gen_followers(testuser,num)
      followers.to_json
  end
  
  
  NanoTwitter.get '/test/status' do
    testuser=User.find_by name: 'testuser'
    {total_tweets:Tweet.all.count,
    total_user:User.all.count,
    total_followings: Follow.all.count,
    testuser:testuser,
    testuser_follower:testuser ? testuser.followers.count : 0,
    testuser_following:testuser ? testuser.followed_users.count : 0,
    testuser_tweets:testuser ? testuser.tweets.count : 0}.to_json
  end

  NanoTwitter.get '/test/reset/all' do
    
    Tweet.delete_all
    User.delete_all
    HashTag.delete_all
    Favourite.delete_all
    Follow.delete_all
    Message.delete_all
    Retweet.delete_all
    Conversation.delete_all
    ChatGroup.delete_all
    "Done"
  end
  #test interface
  NanoTwitter.get '/test/reset/testuser' do
    
    testuser=User.find_by name: 'testuser'
    if !testuser.nil?
      ActiveRecord::Base.transaction do 
        testuser.tweets.destroy_all
        testuser.followed_users.clear
        testuser.followers.clear
      end
    else
      testuser=User.create name: 'testuser',display_name:'Test User',password:'',email:'test@example.com',create_time:Time.now
    end
    testuser.to_json
  end