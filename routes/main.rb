

  #User Interface
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
      @baseurl = "/user/#{@user.name}"
      @curuser=get_cur_user
      @tweets=@user.tweets.where(reply_to:nil)
      erb :master, :layout=> :header do
        erb :user
      end
    else
      "Can't find user"
    end
  end

  NanoTwitter.get '/user/:username/with_replies/?' do
    @user=User.find_by name: params['username']
    if @user
      @curuser=get_cur_user
      @tweets=@user.tweets
      erb :master, :layout=> :header do
        erb :user
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

  NanoTwitter.get '/follow/:username/?' do
    @curuser=get_cur_user
    @user=User.find_by name: params['username']
    @curuser.followed_users << @user
    redirect "/user/#{params['username']}"
  end

  NanoTwitter.get '/unfollow/:username/?' do
    @curuser=get_cur_user
    @user=User.find_by name: params['username']
    @curuser.followed_users.destroy(@user)
    redirect "/user/#{params['username']}"
  end

  NanoTwitter.get '/settings' do
    @curuser=get_cur_user
    erb :settings
  end

  NanoTwitter.post '/settings' do

  end
