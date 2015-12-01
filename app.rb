require 'sinatra/base'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './utils/helpers'
require './models/init'        #Model class
require 'redis'

require 'pry-byebug'

class NanoTwitter < Sinatra::Application
  set :public_folder, File.dirname(__FILE__) + '/static'
  set :root, File.dirname(__FILE__)
  set :redis, Redis.new(url: ENV["REDIS_URL"])
  enable :sessions
  
  helpers Sinatra::NanoTwitter::Helpers
  
end

require './routes/init'
NanoTwitter.run! if NanoTwitter.app_file == $0