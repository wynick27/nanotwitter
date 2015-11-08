class FullTextSearch < ActiveRecord::Migration
  def up
    execute("CREATE INDEX tweets_idx ON tweets USING gin(to_tsvector('english', text));")
 end
  def down
    execute("DROP INDEX tweets_idx;")
  end
end
