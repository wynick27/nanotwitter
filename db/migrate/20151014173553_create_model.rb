class CreateModel < ActiveRecord::Migration
  def change
    create_table :user do |t|
  		t.string :name
      t.string :display_name
      t.string :password
      t.time :create_time
  	end
  	create_table :follow do |t|
  		t.references :user
      t.integer :follower_id
  	end
  	create_table :tweet do |t|
  		t.integer :id
      t.text :text
      t.time :create_time
      t.references :user
      t.integer :reference #referenced tweet
      t.integer :reply_to
  	end
    create_table :retweet do |t|
      t.references :tweet
      t.references :user
    end
    create_table :mention do |t|
      t.references :tweet
      t.references :user
    end
    create_table :hashtag do |t|
      t.string :name
      t.references :tweet
    end
  end
end
