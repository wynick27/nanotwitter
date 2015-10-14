require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/persons'        #Model class
require './models/events'
require './models/registrations'

set :public_folder, File.dirname(__FILE__) + '/static'

#authentication
get '/login' do
end

#Generates user login form.
post '/login' do

end
#Checks user login information and puts session.
get '/logout' do

end

get '/register/:username' do

end

#User Interface
get '/' do

end

#if user logged in return its tweets otherwise return all recent tweets of the site
get '/user/:username' do

end

#if user is matches the current user then show new tweet otherwise just show the user's tweets
post '/tweet/new' do

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
