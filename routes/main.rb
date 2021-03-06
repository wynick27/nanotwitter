

  #User Interface
  NanoTwitter.get '/loaderio-a7b57ae62ee883c50113f255febc07de/?' do
    "loaderio-a7b57ae62ee883c50113f255febc07de"
  end
  
  NanoTwitter.get '/user_avatars/:file' do
    if File.exist? "static/user_avatars/#{params[:file]}"
      send_file("static/user_avatars/#{params[:file]}", :disposition => 'inline')
    else
      send_file("static/images/profile.jpg", :disposition => 'inline')
    end
    
  end

  NanoTwitter.get '/' do
    @curuser=get_cur_user
    @curpage='home'
    @user=@curuser
    @redis=settings.redis
    if @curuser then
      @tweets=Tweet.user_timeline(@curuser).limit(50).order(create_time: :desc)
    else
      if @redis.exists :recenttweets
        @tweets=@redis.lrange(:recenttweets,0,49).map{|i| @redis.get "tweet_#{i}"}
      else
         @tweets=Tweet.includes(:user).all.limit(50)
         @tweets=@tweets.order(create_time: :desc).map do |t| 
           html=erb :show_tweet,:locals=>{:tweet=>t}
           @redis.rpush :recenttweets,t.id
           @redis.set "tweet_#{t.id}",html
           html
         end
      end
      
    end
   
    
    erb :master, :layout=> :header do
      erb :index
    end
  end

  NanoTwitter.get '/following' do
    @curuser=get_cur_user
    if @curuser
      @user=@curuser
      erb :master, :layout=> :header do
        erb :show_user_list ,locals:{users:@user.followed_users}
      end
    else
      "Not logged in"
    end
  end

  NanoTwitter.get '/followers' do
    @curuser=get_cur_user
    if @curuser
      @user=@curuser
      erb :master, :layout=> :header do
        erb :show_user_list ,locals:{users:@user.followers}
      end
    else
      "Not logged in"
    end
  end

  #if user logged in return its tweets otherwise return all recent tweets of the site
  
  NanoTwitter.get '/user/:username/timeline/?' do
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      @tweets=Tweet.user_timeline(@user).limit(50)
      erb :master, :layout=> :header do
        erb :user ,locals:{content:0}
      end
    else
      "Can't find user"
    end
  end
  
  NanoTwitter.post '/user/:username/timeline' do
    @post_url="/user/#{params[:username]}/timeline"
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      @tweets=Tweet.user_timeline(@user).limit(params[:limit].to_i).offset(params[:offset].to_i)
      {html:erb(:raw_tweet_list),has_more:@tweets.count==params[:limit].to_i,count:@tweets.count}.to_json
    else
      "Can't find user"
    end
  end
  
  NanoTwitter.get '/user/:username/?' do
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      @tweets=Tweet.user_tweets(@user).limit(50)
      erb :master, :layout=> :header do
        erb :user ,locals:{content:2}
      end
    else
      "Can't find user"
    end
  end
  
  NanoTwitter.post '/user/:username' do
    @post_url="/user/#{params[:username]}"
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      @tweets=Tweet.user_tweets(@user).limit(params[:limit].to_i).offset(params[:offset].to_i)
      {html:erb(:raw_tweet_list),has_more:@tweets.count==params[:limit].to_i,count:@tweets.count}.to_json
    else
      "Can't find user"
    end
  end

  NanoTwitter.get '/user/:username/with_replies/?' do
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      @tweets=Tweet.user_tweets_with_replies(@user).limit(50)
      erb :master, :layout=> :header do
        erb :user,locals:{content:1}
      end
    else
      "Can't find user"
    end
  end
  
  NanoTwitter.post '/user/:username/with_replies' do
    @post_url="/user/#{params[:username]}/with_replies"
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      @tweets=Tweet.user_tweets_with_replies(@user).limit(params[:limit].to_i).offset(params[:offset].to_i)
      {html:erb(:raw_tweet_list),has_more:@tweets.count==params[:limit].to_i,count:@tweets.count}.to_json
    else
      "Can't find user"
    end
  end

  NanoTwitter.get '/user/:username/favourites/?' do
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      @user.favourites.includes(:tweet)
      @tweets=@user.favourites.map {|fav| fav.tweet }
      erb :master, :layout=> :header do
        erb :favourites
      end
    else
      "Can't find user"
    end
  end

  NanoTwitter.get '/user/:username/following/?' do
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      erb :master, :layout=> :header do
        erb :show_user_list ,locals:{users:@user.followed_users}
      end
    else
      "Not logged in"
    end
  end

  NanoTwitter.get '/user/:username/followers/?' do
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      erb :master, :layout=> :header do
        erb :show_user_list ,locals:{users:@user.followers}
      end
    else
      "Not logged in"
    end
  end

  NanoTwitter.post '/follow/:username/?' do
    @curuser=get_cur_user
    @user=User.find_by name: params['username']
    @curuser.followed_users << @user
    {success:true,followstatus:true}.to_json
  end

  NanoTwitter.post '/unfollow/:username/?' do
    @curuser=get_cur_user
    @user=User.find_by name: params['username']
    @curuser.followed_users.destroy(@user)
    {success:true,followstatus:false}.to_json
  end

  NanoTwitter.get '/settings' do
    @curuser=get_cur_user
    @curpage='settings'
    erb :master, :layout=> :header do
      erb :settings
    end
  end

  NanoTwitter.post '/settings' do
    @curuser=get_cur_user
    if params['avatar'] then
    File.open("static/user_avatars/#{@curuser.name}.jpg", "wb") do |f|
      f.write(params['avatar'][:tempfile].read)
    end

    end
    [:display_name,:email,:bio].each do |param|
      if params[param] then
        @curuser.update(param=>params[param])
      end
    end
    if params['oldpwd']==@curuser.password  then
      @curuser.password=params['newpwd']
    end
    if @curuser.valid? then
      @curuser.save
      redirect '/'
    else
      @curuser.errors.messages.to_json
    end
  end
