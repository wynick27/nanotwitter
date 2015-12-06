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
      t.integer :tweets_count, :default => 0
      t.integer :favourites_count, :default => 0
      t.integer :followers_count, :default => 0
      t.integer :followed_users_count, :default => 0
  	end
  	create_table :follows do |t|
  		t.references :user, :index => true
      t.integer :follower_id, :index => true
  	end
  	create_table :tweets do |t|
      t.text :text
      t.datetime :create_time,:index => true
      t.references :user,:index => true
      t.integer :reference #referenced tweet
      t.integer :reply_to
      t.integer :conversation_root,:index => true
      t.integer :reply_level,:default => 0
      t.integer :retweets_count, :default => 0
      t.integer :favourites_count, :default => 0
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
    create_table :hash_tags do |t|
      t.string :name
      t.references :tweet
    end
  end
end
