  NanoTwitter.get '/autocomplete' do
    name=params['q']
    User.where("lower(name) like ? or lower(display_name) like ?",name+"%",name+"%").limit(5).pluck(:name,:display_name).to_json
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