class CreateModel < ActiveRecord::Migration
  def change
    create_table :users do |t|
  		t.string :name
      t.string :display_name
      t.string :password
      t.string :email
      t.text :bio
      t.date :birthday
      t.datetime :create_time
  	end
  	create_table :follows do |t|
  		t.references :user
      t.integer :follower_id
  	end
  	create_table :tweets do |t|
      t.text :text
      t.time :create_time
      t.references :user
      t.integer :reference #referenced tweet
      t.integer :reply_to
      t.integer :conversation_root
  	end
    create_table :retweets do |t|
      t.references :tweet
      t.references :user
      t.datetime :create_time
    end
    create_table :messages do |t|
      t.references :chat_group
      t.references :user
      t.text :text
      t.datetime :create_time
    end
    create_table :chat_groups do |t|
      t.datetime :create_time
    end
    create_table :conversations do |t|
      t.references :chat_group
      t.references :user
    end
    create_table :favourites do |t|
      t.references :user
      t.references :tweet
      t.datetime :create_time
    end
    create_table :hashtags do |t|
      t.string :name
      t.references :tweet
    end
  end
end
