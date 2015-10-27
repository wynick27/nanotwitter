require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/user'        #Model class
require './models/tweet'
require './models/retweet'
require './models/hashtag'
require './models/follow'
require './models/mention'
require './models/favourite'
require './models/conversation'
require './models/chat_group'
require './models/message'
require './utils/seed_generator'
require 'pry-byebug'
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
  @user=@user || User.find_by(name: params['email'],password:params['password'])
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
  @user=User.new name:params['name'],display_name:params['display_name'],email:params['email'],password:params['password']
  #begin
   if @user.valid?
     @user.save
     redirect '/'
   else
     @user.errors.messages.to_s
   end
  #rescue
  #  "Can't create user"
  #end
end

#User Interface
get '/' do
  uid=session['user']
  @curuser=uid && User.find(uid)
  @user=@curuser
  @tweets=@curuser ? Tweet.user_timeline(@curuser) : Tweet.includes(:user).all.limit(50)
  @tweets=@tweets.order(create_time: :desc)
  erb :master, :layout=> :header do
    erb :index
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
get '/user/:username/?' do
  @user=User.find_by name: params['username']
  if @user
    @baseurl = "/user/#{@user.name}"
    uid=session['user']
    @curuser=uid && User.find(uid)
    @tweets=@user.tweets.where(reply_to:nil)
    erb :master, :layout=> :header do
      erb :user 
    end
  else
    "Can't find user"
  end
end

get '/user/:username/with_replies/?' do
  @user=User.find_by name: params['username']
  if @user
    @baseurl = "/user/#{@user.name}"
    uid=session['user']
    @curuser=uid && User.find(uid)
    @tweets=@user.tweets
    erb :master, :layout=> :header do
      erb :user 
    end
  else
    "Can't find user"
  end
end

get '/user/:username/favourites/?' do 
  @user=User.find_by name: params['username']
  if @user
    @baseurl = "/user/#{@user.name}"
    uid=session['user']
    @curuser=uid && User.find(uid)
    @user.favourites.includes(:tweet)
    erb :master, :layout=> :header do
      erb :favourites
    end
  else
    "Not logged in"
  end
end

get '/user/:username/following/?' do 
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

get '/user/:username/followers/?' do
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
    tweet.conversation_root=tweet.id
    tweet.save
    extract_hashtag params[:text] do |name| 
      HashTag.create :name=>name,:tweet_id=>tweet.id
    end
    redirect '/'
  else
    redirect '/login'
  end
end
get '/follow/:username/?' do
  uid=session['user']
  @curuser=uid && User.find(uid)
  @user=User.find_by name: params['username']
  @curuser.followed_users << @user
  redirect "/user/#{params['username']}"
end

get '/unfollow/:username/?' do
  uid=session['user']
  @curuser=uid && User.find(uid)
  @user=User.find_by name: params['username']
  @curuser.followed_users.destroy(@user)
  redirect "/user/#{params['username']}"
end

#If user is not logged in then error else post a new tweet in users profile
post '/tweet/:tweet_id/retweet' do
  uid=session['user']
  @curuser=uid && User.find(uid)
  begin
    tweetid=params['tweet_id']
    comment=params['comment']
    if comment
      tweet=@curuser.tweets.create text:params['comment'],create_time:Time.now,reference:tweetid
      tweet.save
      {:created=>true,:count=>0}.to_json
    else
      retweet=@curuser.retweets.find_by tweet_id:tweetid
      if retweet
        retweet.destroy
        {:created=>false,:count=>Tweet.find(tweetid).retweets.count}.to_json
      else
        @curuser.retweets.create tweet_id:tweetid,create_time:Time.now
        {:created=>true,:count=>Tweet.find(tweetid).retweets.count}.to_json
      end
    end
  rescue
    404
  end
end

post '/tweet/:tweet_id/comment/new' do
	begin
    tweetid=params['tweet_id']
    tweet=Tweet.find_by :id=>tweetid
    comment=params['comment']
    if comment && tweet
      tweet=@curuser.tweets.create text:params['comment'],create_time:Time.now,reply_to:tweetid,conversation_root:tweet.conversation_root
      tweet.save
    end
  rescue
    404
  end
end

post '/tweet/:tweet_id/expand' do
	begin
    tweetid=params['tweet_id']
    tweet=Tweet.find_by :id=>tweetid
    if tweet && tweet.id==tweet.conversation_root
      @tweets=Tweet.find_by(:conversation_root=>tweet.conversation_root).order(create_time: :desc)
      {:ancestors=>nil,:descendants=>(erb :comments)}.to_json
    elsif tweet && tweet.id!=tweet.conversation_root
      @tweets=Tweet.find_by(:conversation_root=>tweet.conversation_root)
      {:ancestors=>(erb :conversation),:descendants=>nil}.to_json
    end
  rescue
    404
  end
end


post '/tweet/:tweet_id/favourite' do
  uid=session['user']
  @curuser=uid && User.find(uid)
	begin
    tweetid=params['tweet_id']
    fav=@curuser.favourites.find_by :tweet_id=>tweetid
    if fav
      fav.destroy
      {:created=>false,:count=>Tweet.find(tweetid).favourites.count}.to_json
    else
      @curuser.favourites.create tweet_id:tweetid,create_time:Time.now
      {:created=>true,:count=>Tweet.find(tweetid).favourites.count}.to_json
    end
  rescue
    404
  end
end

get '/messages/?' do
  uid=session['user']
  @curuser=uid && User.find(uid)
  erb :conversation_list
end

get '/messages/:conversation_id/?' do
  uid=session['user']
  @curuser=uid && User.find(uid)
  cid=params['conversation_id']
  @chatgroup=cid && ChatGroup.find_by(:id=>cid)
  erb :conversation_content
end

post '/messages/new' do
  text=params['text']
  uid=session['user']
  @curuser=uid && User.find_by(:id=>uid)
  
  usernames=params['users'].split(';')
  users=User.where :name=>usernames
  if users
    group=ChatGroup.create :create_time=>Time.now
    #binding.pry
    users.each do |user|
      if user.id==uid then return end
      group.users << user
    end
    group.users << @curuser
    group.messages.create :user_id=>uid,:text=>text,:create_time=>Time.now
    group.save
  end
end

post '/messages/:conversation_id/new' do
  text=params['text']
  uid=session['user']
  @curuser=uid && User.find_by(:id=>uid)
  cid=params['conversation_id']
  @chatgroup=cid && ChatGroup.find_by(:id=>cid)
  @chatgroup.messages.create :user_id=>uid,:text=>text,:create_time=>Time.now
end

get '/hashtag/:hashtag/?' do
  uid=session['user']
  @curuser=uid && User.find(uid)
  @user=@curuser
  ids=HashTag.where('name = ?',params[:hashtag]).pluck(:tweet_id)
  @tweets=ids==[] ? [] : Tweet.where("id in (?)",ids)
  #binding.pry
  erb :master, :layout=> :header do
    erb :hashtag 
  end
end

get '/settings' do
  uid=session['user']
  @curuser=uid && User.find_by(:id=>uid)
  erb :settings
end

post '/settings' do

end

get '/autocomplete' do
  name=params['q']
  #binding.pry
  User.where("lower(name) like ? or lower(display_name) like ?",name+"%",name+"%").limit(5).pluck(:name,:display_name).to_json
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
      FakeData::gen_user
  end
end

get %r{^/test/tweets/(\d+)$} do |num|
  num=num.to_i
  begin
    testuser=User.find_by name: 'testuser'
    FakeData::gen_tweets(testuser,num)
  end
end

get %r{^/test/follow/(\d+)$} do |num|
  num=num.to_i
    testuser=User.find_by name: 'testuser'
    FakeData::gen_followers(testuser,num)
end



helpers do
  def html(text)
    Rack::Utils.escape_html(text)
  end
  
  def parse_tweet(text)
    text=html(text)
    text.gsub(/@[\w\d]+|#[\w\d]+/) do |s|
       "<a href='/#{s[0]=='@'? 'user' : 'hashtag'}/#{s[1..-1]}'>#{s}</a>"
    end
  end
  
  def extract_hashtag(text)
    text.scan(/#[\w\d]+/) do |s|
       yield s[1..-1]
    end
  end
  
end