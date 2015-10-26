class ChatGroup < ActiveRecord::Base
  has_many :conversations
  has_many :users,:through => :conversations
  has_many :messages
end