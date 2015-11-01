NanoTwitter.get '/api/v1/users/username/:name' do
  user = User.find_by name: params[:name]
  if user
    user.to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

#find user info by user_id
NanoTwitter.get '/api/v1/users/userid/:id' do
	user = User.find_by id: params[:id]
  if user
    user.to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

# find tweet id by tweet_id
NanoTwitter.get '/api/v1/tweets/tweetid/:id' do
	user = Tweet.find_by id: params[:id]
  if user
    user.to_json
  else
    error 404, {:error => "tweet not found"}.to_json
  end
end

# find the user time_line by username
NanoTwitter.get '/api/v1/tweets/username/:name' do
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
NanoTwitter.get '/api/v1/tweets/userid/:id' do
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

NanoTwitter.get '/api/v1/tweets/recent/:number' do
  tweets = Tweet.all
  tweets=tweets.order(create_time: :desc)
  count = params[:number].to_i
  tweets_return = tweets[0...count]
  if tweets
    tweets_return.to_json
  else
    error 404, {:error => "no tweets founds"}.to_json
  end
end

# find the followers of a user by username
NanoTwitter.get '/api/v1/followers/username/:name' do
	user = User.find_by name: params[:name]
  followers = user.followers
	if user
    followers.to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

# find the followers of a user by userid
NanoTwitter.get '/api/v1/followers/userid/:id' do
	user = User.find_by id: params[:id]
  followers = user.followers
	if user
    followers.to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

# find the people that user following by the username
NanoTwitter.get '/api/v1/followings/username/:name' do
  user = User.find_by name: params[:name]
  following = user.followed_users
  if user
    following .to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end

# find the people that user following by the userid
NanoTwitter.get '/api/v1/followings/userid/:id' do
  user = User.find_by id: params[:id]
  following = user.followed_users
  if user
    following .to_json
  else
    error 404, {:error => "user not found"}.to_json
  end
end


################ RESTful API starts here #################

# params: userid, username -- if meet find the user's tweet, else find all tweets
# params: recent, limit
NanoTwitter.get '/api/v1/tweets' do
  if params[:username] || params[:userid]
    if params[:username]
      user = User.find_by name: params[:username]
    else
      user = User.find_by id: params[:userid]
    end
    # find all the user's tweets
    if user
      tweets = user.tweets
      if params[:recent] == "true"
        tweets=tweets.order(create_time: :desc)
      elsif params[:recent] == "false"
        tweets=tweets.order(create_time: :asc)
      end
      if params[:limit]
        num = params[:limit].to_i
      else
        num = 10
      end
      tweets[0..num].to_json
    else
      error 404, {:error => "user not found, check your params"}.to_json
    end
  else
    tweets = Tweet.all
    if params[:recent] == "true"
      tweets=tweets.order(create_time: :desc)
    elsif params[:recent] == "false"
      tweets=tweets.order(create_time: :asc)
    end
    if params[:limit]
      num = params[:limit].to_i
    else
      num = 50
    end
    tweets[0..num].to_json
  end
end

# params: userid, username
NanoTwitter.get '/api/v1/users' do
  if params[:username] || params[:userid]
    if params[:username]
      user = User.find_by name: params[:username]
    else
      user = User.find_by id: params[:userid]
    end
    if user
      user.to_json
    else
      error 404, {:error => "user not found"}.to_json
    end
  else
    error 404, {:error => "user not found, check your params"}.to_json
  end
end

# params: userid, username, limit
NanoTwitter.get '/api/v1/followers' do
  if params[:username] || params[:userid]
    if params[:username]
      user = User.find_by name: params[:username]
    else
      user = User.find_by id: params[:userid]
    end
    if user
      followers = user.followers
      if params[:limit]
        num = params[:limit].to_i
      else
        num = 10
      end
      followers[0..num].to_json
    else
      error 404, {:error => "user not found"}.to_json
    end
  else
    error 404, {:error => "user not found, check your params"}.to_json
  end
end

# params: userid, username, limit
NanoTwitter.get '/api/v1/followings' do
  if params[:username] || params[:userid]
    if params[:username]
      user = User.find_by name: params[:username]
    else
      user = User.find_by id: params[:userid]
    end
    if user
      followings = user.followed_users
      if params[:limit]
        num = params[:limit].to_i
      else
        num = 10
      end
      followings[0..num].to_json
    else
      error 404, {:error => "user not found"}.to_json
    end
  else
    error 404, {:error => "user not found, check your params"}.to_json
  end

end

# params: userid, username, oneterm, terms, recent, limit
NanoTwitter.get '/api/v1/search' do
  if params[:username] || params[:userid]
    if params[:username]
      user = User.find_by name: params[:username]
    else
      user = User.find_by id: params[:userid]
    end

    if user
      pattern1 = /^[a-zA-Z]+$/
      if params[:oneterm] && pattern1 =~ params[:oneterm]
        result = search_one(params[:oneterm],user)
        if params[:limit]
          result = result[0..params[:limit].to_i-1]
        end
        result.to_json
      elsif params[:terms]
        spliter = params[:terms].split
      else
        error 404, {:error => "please check your input search terms"}.to_json
      end
    else
      error 404, {:error => "user not found"}.to_json
    end

  else
    error 404, {:error => "user not found"}.to_json
  end
end

################ methods are here ################
def search_one(term,user)
  result = []
  tweets = user.tweets
  tweets.each_with_index do |single|
    if /#{term}/.match(single.text)
      count = 0
      spliter = single.text.split
      spliter.each do |word|
        if /#{term}/.match(word)
          num = /#{term}/.match(word).length
          count += num
        end
      end
      pair = {:username => user.name, :tweet => single.text, :count => count}
      result << pair
    end
  end
  sorted_result = result.sort_by { |s| -s[:count] }
  return sorted_result
end
