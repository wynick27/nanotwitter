class ChatGroup < ActiveRecord::Base
  has_many :conversations
  has_many :users,:through => :conversations
  has_many :messages
  
  def new_group(users,curuser)
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
        return group
      end
      return nil
  end
end