require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/user'        #Model class
require './models/tweet'
require './models/retweet'
require './models/hashtag'
require './models/follow'
require './models/mention'
#require './models/favourate'
require 'pry-byebug'

set :public_folder, File.dirname(__FILE__) + '/static'
enable :sessions

# find user info by username

