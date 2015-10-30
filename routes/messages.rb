
  NanoTwitter.post '/messages/?' do
    uid=session['user']
    @curuser=uid && User.find(uid)
    (@curuser.chat_groups.map { |c|  
      {:id=>c.id,:time=>c.create_time,:html=>"<a role='button' class='btn btn-success' href='/messages/#{c.id}' >#{(c.users.map {|u| u.name }).join ', '}</a>"}}).to_json
    #binding.pry
  end

  NanoTwitter.get '/messages/:conversation_id/?' do
    uid=session['user']
    @curuser=uid && User.find(uid)
    cid=params['conversation_id']
    @chatgroup=cid && ChatGroup.find_by(:id=>cid)
    erb :conversation_content
  end

  NanoTwitter.post '/messages/new' do
    uid=session['user']
    @curuser=uid && User.find_by(:id=>uid)
    
    usernames=params['users'].split(',')
    users=User.where :name=>usernames
    
    if users && @curuser
      group=ChatGroup.create :create_time=>Time.now
      #binding.pry
      users.each do |user|
        if user.id==uid then return end
        group.users << user
      end
      group.users << @curuser
      #group.messages.create :user_id=>uid,:text=>text,:create_time=>Time.now
      group.save
    end
  end

  NanoTwitter.post '/messages/:conversation_id/new' do
    text=params['text']
    uid=session['user']
    @curuser=uid && User.find_by(:id=>uid)
    cid=params['conversation_id']
    @chatgroup=cid && ChatGroup.find_by(:id=>cid)
    @chatgroup.messages.create :user_id=>uid,:text=>text,:create_time=>Time.now
  end