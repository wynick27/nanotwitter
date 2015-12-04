module Sinatra
module NanoTwitter
module Helpers

    def html(text)
      Rack::Utils.escape_html(text)
    end
    
    
    def hashtag(text)
      text.scan(/#[\w\d]+/) do |s|
         yield s[1..-1]
      end
    end
    
    def get_cur_user()
      uid=session['user']
      uid && User.find(uid)
    end
    
    def update_tweet_cache(tweet,isnew=true)
      settings.redis.set "tweet_#{tweet.id}",(erb :show_tweet,:locals=>{:tweet=>tweet})
      if isnew && settings.redis.exists(:recenttweets)
        settings.redis.rpop :recenttweets
        settings.redis.lpush :recenttweets,tweet.id
      end
    end
    
  end
end
end