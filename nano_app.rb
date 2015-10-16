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
require 'pry-byebug'

set :public_folder, File.dirname(__FILE__) + '/static'
enable :sessions

get '/api/v1/users/username/:name' do
  user = User.find_by name: params[:name]
  if user
    user.to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

get '/api/v1/users/id/:id' do
	user = User.find_by id: params[:id]
  if user
    user.to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

get '/api/v1/tweets/id/:id' do
	user = Tweet.find_by id: params[:id]
  if user
    user.to_json
  else
    error 404, {:error => "tweet not found"}.to_json
  end
end

get '/api/v1/tweets/username/:name' do
	user = User.find_by name: params[:name]
	user_id = user.id
	comb_user = user_id && User.find(user_id)
	tweets = comb_user ? Tweet.user_timeline(comb_user) : Tweet.all
	# tweets=tweets.order(create_time: :desc)
  if user
    tweets.to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end




# sample
