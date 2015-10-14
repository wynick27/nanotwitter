require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/persons'        #Model class
require './models/events'
require './models/registrations'

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
	erb :index
end

get '/person/new' do 
  erb :person_new
end

get '/event/new' do 
  erb :event_new
end

get '/registration/new' do 
  @persons=Person.all
  @events=Event.all
  erb :registration_new
end

post '/person/new' do
  pinfo = params[:person]
  pinfo[:gender] = pinfo[:gender] == 'male'
	person = Person.new(pinfo)
	if person.save
		redirect '/persons'
	else
		"Sorry, there was an error!"
	end
end

post '/event/new' do
	event = Event.new(params[:event])
	if event.save
		redirect '/events'
	else
		"Sorry, there was an error!"
	end
end

post '/registration/new' do
	reginfo = params[:reg]
  reg = Registration.find_or_initialize_by(person_id: reginfo[:person].to_i ,event_id:reginfo[:event].to_i)
  reg.status=reginfo[:status]
	if reg.save
		redirect '/registrations'
	else
		"Sorry, there was an error!"
	end
end

get '/persons' do
	@persons = Person.all
	erb :persons
end

get '/events' do
	@events = Event.all
	erb :events
end

get '/registrations' do
	@regs = Registration.all
	erb :regs
end