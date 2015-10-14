class CreateModel < ActiveRecord::Migration
  def change
    create_table :users do |t|
  		t.string :name
      t.string :display_name
      t.string :password
      t.time :create_time
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
  	end
    create_table :retweets do |t|
      t.references :tweet
      t.references :user
    end
    create_table :mentions do |t|
      t.references :tweet
      t.references :user
    end
    create_table :favourates do |t|
      t.references :user
      t.references :tweet
    end
    create_table :hashtags do |t|
      t.string :name
      t.references :tweet
    end
  end
end
