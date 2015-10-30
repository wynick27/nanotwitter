
  NanoTwitter.post '/messages/?' do
    uid=session['user']
    @curuser=uid && User.find(uid)
    # {@curuser.chat_groups.map { |c| {:id=>c.id,:time=>c.create_time}}.to_json
    #binding.pry
    {:html=>(erb :chat_groups)}.to_json
  end


  
  NanoTwitter.post '/messages/new' do
    uid=session['user']
    @curuser=uid && User.find_by(:id=>uid)
    
    usernames=params['users'].split(',')
    users=User.where :name=>usernames
    
    if users && @curuser
      group=ChatGroup.create(:create_time=>Time.now)
      count=0
      users.each do |user|
        if user.id==uid then return {:created=>false}.to_json end
        group.users << user
        count+=1
      end
      if count>0 then
        group.users << @curuser
        group.save
        return {:created=>true,:group_id=>group.id}.to_json
      end
    end
    {:created=>false}.to_json
  end

  NanoTwitter.post '/messages/:conversation_id/?' do
    uid=session['user']
    @curuser=uid && User.find(uid)
    cid=params['conversation_id']
    @chatgroup=cid && ChatGroup.find_by(:id=>cid)
    {:html=>(erb :chat_content),:group_id=>cid}.to_json
  end
  
  NanoTwitter.post '/messages/:conversation_id/new' do
    text=params['text']
    uid=session['user']
    @curuser=uid && User.find_by(:id=>uid)
    cid=params['conversation_id']
    @chatgroup=cid && ChatGroup.find_by(:id=>cid)
    m=@chatgroup.messages.create(:user_id=>uid,:text=>text,:create_time=>Time.now)
    {:created=>true,:html=>erb(:chat_message,:locals=>{:m=>m})}.to_json
  end