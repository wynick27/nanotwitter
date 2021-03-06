  NanoTwitter.get '/autocomplete' do
    name=params['q']
    User.search(name).limit(5).pluck(:name,:display_name).to_json
  end

  NanoTwitter.get '/search' do
    @curuser=get_cur_user
    @query=params['q']
    @searchtype=params['type'] || 'tweets'
    @result= @searchtype.downcase == 'users' ? User.search(@query) : Tweet.search(@query)
    erb :master, :layout=> :header do
      erb :search_result 
    end
  end
  
  NanoTwitter.get '/hashtag/:hashtag/?' do
    @curuser=get_cur_user
    @user=@curuser
    ids=HashTag.where('name = ?',params[:hashtag]).pluck(:tweet_id)
    @tweets=ids==[] ? [] : Tweet.where("id in (?)",ids)
    @hashtag=params[:hashtag]
    
    erb :master, :layout=> :header do
      erb :hashtag 
    end
  end