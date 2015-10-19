require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/user'        #Model class
require './models/tweet'
require './models/retweet'
require './models/hashtag'
require './models/follow'
require './models/mention'
require './models/favourate'
require 'faker'
set :public_folder, File.dirname(__FILE__) + '/static'
enable :sessions

#authentication
get '/login' do
  @user = nil
  erb :master, :layout=> :header do
    erb :login
  end
end

#Generates user login form.
post '/login' do
  @user=User.find_by name: params['name'],password:params['password']
  if @user
    session['user']=@user.id
    redirect '/'
  else
    "User not found or password is not correct"
  end
end
#Checks user login information and puts session.
get '/logout' do
  session.clear
  redirect '/'
end

get '/register' do
  @baseurl = "/"
  erb :master, :layout=> :header do
    erb :register
  end
end

post '/register' do
  @user=User.new name:params['name'],email:params['email'],password:params['password']
  begin
   if @user.valid?
     @user.save
     redirect '/'
   else
     person.errors.messages[:name] + person.errors.messages[:email]
   end
  rescue
    "Can't create user"
  end
end

#User Interface
get '/' do
  uid=session['user']
  @curuser=uid && User.find(uid)
  @user=@curuser
  tweets=@curuser ? Tweet.user_timeline(@curuser) : Tweet.includes(:user).all
  tweets=tweets.order(create_time: :desc)
  erb :master, :locals=> {:tweets=>tweets}, :layout=> :header do
    erb :index, :locals=> {:tweets=>tweets} do
      if @curuser
        erb :new_tweet
      else
        ""
      end
    end
  end
end

get '/following' do 
  uid=session['user']
  @curuser=uid && User.find(uid)
  if @curuser
    @user=@curuser
    erb :master, :layout=> :header do
      erb :following
    end
  else
    "Not logged in"
  end
end

get '/followers' do
  uid=session['user']
  @curuser=uid && User.find(uid)
  if @curuser
    @user=@curuser
    erb :master, :layout=> :header do
      erb :followers
    end
  else
    "Not logged in"
  end
end

#if user logged in return its tweets otherwise return all recent tweets of the site
get '/user/:username' do
  @user=User.find_by name: params['username']
  if @user
    @baseurl = "/user/#{@user.name}"
    uid=session['user']
    @curuser=uid && User.find(uid)
    erb :master, :layout=> :header do
      erb :user do 
        if uid==@user.id
          erb :new_tweet
        elsif uid
          erb :follow,:locals=> {:curuser=>@curuser}
        else
          ""
        end
      end
    end
  else
    "Can't find user"
  end
end

get '/user/:username/following' do 
  @user=User.find_by name: params['username']
  if @user
    @baseurl = "/user/#{@user.name}"
    uid=session['user']
    @curuser=uid && User.find(uid)
    erb :master, :layout=> :header do
      erb :following
    end
  else
    "Not logged in"
  end
end

get '/user/:username/followers' do
  @user=User.find_by name: params['username']
  if @user
    @baseurl = "/user/#{@user.name}"
    uid=session['user']
    @curuser=uid && User.find(uid)
    erb :master, :layout=> :header do
      erb :followers
    end
  else
    "Not logged in"
  end
end

#if user is matches the current user then show new tweet otherwise just show the user's tweets
post '/tweet/new' do
  uid=session['user']
  @user=uid && User.find(uid)
  if @user
    tweet=@user.tweets.create(text:params[:text],create_time:Time.now)
    tweet.save
    redirect '/'
  else
    redirect '/login'
  end
end
get '/follow/:username' do
  uid=session['user']
  @curuser=uid && User.find(uid)
  @user=User.find_by name: params['username']
  @curuser.followed_users << @user
  redirect "/user/#{params['username']}"
end

get '/unfollow/:username' do
  uid=session['user']
  @curuser=uid && User.find(uid)
  @user=User.find_by name: params['username']
  @curuser.followed_users.destroy(@user)
  redirect "/user/#{params['username']}"
end

#If user is not logged in then error else post a new tweet in users profile
post '/tweet/:tweet_id/retweet' do
  begin
    tweetid=Tweet.find params['tweet_id']
    comment=params['comment']
    if comment
      tweet=@user.tweets.create text:params[:text],create_time:Time.now,reference:tweetid
      tweet.save
    else
      @user.retweets.create tweet_id:tweetid,create_time:Time.now
    end
  rescue
    404
  end
end
post '/tweet/:tweet_id/comments' do
	begin
    tweetid=params['tweet_id'] && Tweet.find(params['tweet_id'])
    begin
      tweet=@user.tweets.find tweetid
      @user.favourites.destroy tweet
    rescue
      @user.favourites.create tweet_id:tweetid,create_time:Time.now
    end
  rescue
    404
  end
end

post '/tweet/:tweet_id/favourite' do
	begin
    tweetid=params['tweet_id'] && Tweet.find(params['tweet_id'])
    begin
      tweet=@user.tweets.find tweetid
      @user.favourites.destroy tweet
    rescue
      @user.favourites.create tweet_id:tweetid,create_time:Time.now
    end
  rescue
    404
  end
end

#test interface
get '/test/reset' do
  
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
#creates a testuser if not exist, delete all its follows and tweets


get %r{^/test/seed/(\d+)$} do |num|
  num=num.to_i
  num.times do 
    #while true
      dname = Faker::Name.name
      name = dname.sub(/ /,'').downcase
      user=User.create name: name,display_name:dname ,password:'',email:Faker::Internet.email
      if user.valid?
        user.save
      end
  end
end

get %r{^/test/tweets/(\d+)$} do |num|
  num=num.to_i
  begin
    testuser=User.find_by name: 'testuser'
    ActiveRecord::Base.transaction do  
      num.times do
        tweet=testuser.tweets.create(text:Faker::Lorem.paragraph(1, false, 4),create_time:Faker::Date.backward(60))
        tweet.save
      end
    end
  end
end

get %r{^/test/follow/(\d+)$} do |num|
  num=num.to_i
  
    testuser=User.find_by name: 'testuser'
    usercount=User.count
    num.times do
      userid=Random.rand(usercount)+ 1
      if userid!=testuser.id
        user=User.find_by id:userid
        if user 
          testuser.followers << user
        end
      end
    end
  
end