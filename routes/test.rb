require './utils/seed_generator'

  NanoTwitter.get %r{^/test/seed/(\d+)$} do |num|
    num=num.to_i
    num.times do 
        FakeData::gen_user
    end
  end

  NanoTwitter.get %r{^/test/tweets/(\d+)$} do |num|
    num=num.to_i
    begin
      testuser=User.find_by name: 'testuser'
      FakeData::gen_tweets(testuser,num)
    end
  end

  NanoTwitter.get %r{^/test/follow/(\d+)$} do |num|
    num=num.to_i
      testuser=User.find_by name: 'testuser'
      FakeData::gen_followers(testuser,num)
  end

  #test interface
  NanoTwitter.get '/test/reset' do
    
    testuser=User.find_by name: 'testuser'
    if !testuser.nil?
      ActiveRecord::Base.transaction do 
        testuser.tweets.destroy_all
        testuser.followed_users.clear
        testuser.followers.clear
      end
    else
      testuser=User.create name: 'testuser',display_name:'Test User',password:'',email:'test@example.com'
    end
  end