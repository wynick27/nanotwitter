class FullTextSearch < ActiveRecord::Migration
  def up
    connection = ActiveRecord::Base.connection
    connection.execute("CREATE VIRTUAL TABLE tweet_index USING fts3(tweet);") 
    connection.execute("CREATE VIRTUAL TABLE user_index USING fts3(name,display_name);")
 end
  def down
    connection = ActiveRecord::Base.connection
    connection.execute("DROP TABLE tweet_index;") 
    connection.execute("DROP TABLE user_index;")
  end
end
