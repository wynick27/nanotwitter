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

# find user info by username
get '/api/v1/users/username/:name' do
  user = User.find_by name: params[:name]
  if user
    user.to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

#find user info by user_id
get '/api/v1/users/userid/:id' do
	user = User.find_by id: params[:id]
  if user
    user.to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

# find tweet id by tweet_id
get '/api/v1/tweets/tweetid/:id' do
	user = Tweet.find_by id: params[:id]
  if user
    user.to_json
  else
    error 404, {:error => "tweet not found"}.to_json
  end
end

# find the user time_line by username
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
# find the user time_line by user_id
get '/api/v1/tweets/userid/:id' do
	user = User.find_by id: params[:id]
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

# find the followers of a user by username
get '/api/v1/followers/username/:name' do
	user = User.find_by name: params[:name]
  followers = user.followers
	if user
    followers.to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

# find the followers of a user by userid
get '/api/v1/followers/userid/:id' do
	user = User.find_by id: params[:id]
  followers = user.followers
	if user
    followers.to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

# find the people that user following by the username
get '/api/v1/following/username/:name' do
  user = User.find_by name: params[:name]
  following = user.followed_users
  if user
    following .to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

# find the people that user following by the userid
get '/api/v1/following/userid/:id' do
  user = User.find_by id: params[:id]
  following = user.followed_users
  if user
    following .to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end



# here sample
