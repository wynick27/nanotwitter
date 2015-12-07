  #authentication
  NanoTwitter.get '/login' do
    @user = nil
    erb :master, :layout=> :header do
      erb :login
    end
  end

  #Generates user login form.
  NanoTwitter.post '/login' do
    @user=User.find_by name: params['name'],password:params['password']
    @user=@user || User.find_by(email: params['name'],password:params['password'])
    if @user
      session['user']=@user.id
      @success = "Success".to_json
      #redirect '/'
    else
      @err = "User not found or password is not correct".to_json
    end
  end
  #Checks user login information and puts session.
  NanoTwitter.get '/logout' do
    session.clear
    redirect '/'
  end

  NanoTwitter.get '/register' do
    @baseurl = "/"
    erb :master, :layout=> :header do
      erb :register
    end
  end

  NanoTwitter.post '/register' do
    @user=User.new name:params['name'],display_name:params['display_name'],email:params['email'],password:params['password']
     if @user.valid?
       @user.save
       [].to_json
       session['user']=@user.id
       redirect '/'
     else
       @user.errors.messages.to_json
     end
     
  end
