module Sinatra
module NanoTwitter
module Helpers

    def html(text)
      Rack::Utils.escape_html(text)
    end
    
    def parse_tweet(text)
      text=html(text)
      text.gsub(/@[\w\d]+|#[\w\d]+/) do |s|
         "<a href='/#{s[0]=='@'? 'user' : 'hashtag'}/#{s[1..-1]}'>#{s}</a>"
      end
    end
    
    def extract_hashtag(text)
      text.scan(/#[\w\d]+/) do |s|
         yield s[1..-1]
      end
    end
    
    def get_cur_user()
      uid=session['user']
      uid && User.find(uid)
    end
  end
end
end