
#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path

class Configure < Sinatra::Base
configure :production do
	db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/nanotwitter')

	ActiveRecord::Base.establish_connection(
			:adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
			:host     => db.host,
			:username => db.user,
			:password => db.password,
			:database => db.path[1..-1],
			:encoding => 'utf8'
	)
end

configure :development, :test do
  puts "[develoment or test Environment]"
end
end