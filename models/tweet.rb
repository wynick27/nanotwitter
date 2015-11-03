class Tweet < ActiveRecord::Base
  has_many :mentions
	has_many :favourites
	has_many :hashtags
  has_many :retweets
	belongs_to :user
  
  def self.user_timeline(user) 
    Tweet.includes(:user).from("(#{user.tweets.to_sql} UNION #{Tweet.where(:user_id=>user.followed_users).to_sql}) as tweets")
  end
  
  def self.user_tweets(user)
    Tweet.includes(:user,:retweets).order(create_time: :desc).from("(select tweets.* from tweets where tweets.user_id = #{user.id} and tweets.reply_to is null
union
select tweets.id,tweets.text,retweets.create_time,tweets.user_id,tweets.reference,tweets.reply_to,tweets.conversation_root,tweets.reply_level,tweets.retweets_count,tweets.favourites_count from tweets join retweets  where tweets.id = retweets.tweet_id and retweets.user_id = #{user.id})  as tweets")
  end
  
  def self.user_tweets_with_replies(user)
    Tweet.includes(:user,:retweets).order(create_time: :desc).from("(select tweets.* from tweets where tweets.user_id = #{user.id}
union
select tweets.id,tweets.text,retweets.create_time,tweets.user_id,tweets.reference,tweets.reply_to,tweets.conversation_root,tweets.reply_level,tweets.retweets_count,tweets.favourites_count from tweets join retweets  where tweets.id = retweets.tweet_id and retweets.user_id = #{user.id})  as tweets")
  end
  def retweeted_by?(user)
    self.retweets.size== 0 ? false : self.retweets.any? {|r| r.user_id==user.id}
  end
  def favourited_by?(user)
    self.favourites.size== 0 ? false : self.retweets.any? {|f| f.user_id==user.id}
  end
  def reply_ancestors()
    if self.id==self.conversation_root then
      nil
    else
      tmap=Tweet.includes(:user).where("conversation_root = ? and id != ? and create_time < ?",self.conversation_root,self.id,self.create_time).order(:create_time).map {|t| [t.id,t] }
      tmap=tmap.to_h
      plist=[self]
      while plist[0].reply_to
        plist.unshift(tmap[plist[0].reply_to])
      end
      plist.pop
      plist
    end
  end
  def reply_descendants()
    if self.id==self.conversation_root then
      Tweet.includes(:user).where("conversation_root = ? and id != ?",self.conversation_root,self.id).order(:create_time)
    else
      pset=Set.new [self.id]
      tweets=Tweet.includes(:user).where("conversation_root = ? and id != ? and create_time > ?",self.conversation_root,self.id,self.create_time).order(:reply_level).select do |t|
        ismember=pset.include?(t.reply_to)
        if ismember then pset<<t.id end
        ismember
      end
      tweets.sort_by { |t| t.create_time}
      tweets
    end
  end
  def to_html
    erb :show_tweet,:locals=>{:tweet=>self}
  end
end