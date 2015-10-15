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

set :public_folder, File.dirname(__FILE__) + '/static'
enable :sessions

#authentication
get '/login' do
  erb :login
end

#Generates user login form.
post '/login' do
  user=User.find_by name: params['name'],password:params['password']
  if user
    session['user']=user.id
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
  erb :register
end

post '/register' do
  user=User.new name:params['name'],email:params['email'],password:params['password']
  begin
   if user.valid?
     user.save
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
  user=uid && User.find(uid)
  erb :user,:locals=> {:user=>user}
end

#if user logged in return its tweets otherwise return all recent tweets of the site
get '/user/:username' do
  user=User.find_by name: params['username']
  if user
    uid=session['user']
    curuser=uid && User.find(uid)
    erb :user,:locals=> {:user=>user} do 
      if uid==user.id
        erb :new_tweet
      elsif uid
        erb :follow,:locals=> {:curuser=>curuser,:user=>user}
      else
        ""
      end
    end
  else
    "Can't find user"
  end
end

#if user is matches the current user then show new tweet otherwise just show the user's tweets
post '/tweet/new' do
  uid=session['user']
  user=uid && User.find(uid)
  if user
    tweet=user.tweets.create(text:params[:text],create_time:Time.now)
    tweet.save
    redirect '/'
  else
    redirect '/login'
  end
end
#If user is not logged in then error else post a new tweet in users profile
get '/tweet/:id/retweet' do

end
post '/tweet/:id/comments' do

end
post '/tweet/:id/favourate' do
	
end

#test interface
get '/test/reset' do

end
#creates a testuser if not exist, delete all its follows and tweets
