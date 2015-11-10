

  #User Interface
  NanoTwitter.get '/loaderio-476cc1bb3c2f091992b5dc49fe9f7c98/?' do
    "loaderio-476cc1bb3c2f091992b5dc49fe9f7c98"
  end

  NanoTwitter.get '/' do
    @curuser=get_cur_user
    @user=@curuser
    @tweets=@curuser ? Tweet.user_timeline(@curuser) : Tweet.includes(:user).all.limit(50)
    @tweets=@tweets.order(create_time: :desc)
    erb :master, :layout=> :header do
      erb :index
    end
  end

  NanoTwitter.get '/following' do
    @curuser=get_cur_user
    if @curuser
      @user=@curuser
      erb :master, :layout=> :header do
        erb :following
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
        erb :followers
      end
    else
      "Not logged in"
    end
  end

  #if user logged in return its tweets otherwise return all recent tweets of the site
  NanoTwitter.get '/user/:username/?' do
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      @tweets=Tweet.user_tweets(@user)
      erb :master, :layout=> :header do
        erb :user ,locals:{reply:false}
      end
    else
      "Can't find user"
    end
  end

  NanoTwitter.get '/user/:username/with_replies/?' do
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      @tweets=Tweet.user_tweets_with_replies(@user)
      erb :master, :layout=> :header do
        erb :user,locals:{reply:true}
      end
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
        erb :following
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
        erb :followers
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
    erb :settings
  end

  NanoTwitter.post '/settings' do

  end
