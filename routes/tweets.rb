
  
  #if user is matches the current user then show new tweet otherwise just show the user's tweets
  NanoTwitter.post '/tweet/new' do
    @curuser=get_cur_user
    if @curuser
      tweet=@curuser.tweets.create(text:params[:text],create_time:Time.now)
      tweet.conversation_root=tweet.id
      tweet.save
      extract_hashtag params[:text] do |name| 
        HashTag.create :name=>name,:tweet_id=>tweet.id
      end
      redirect '/'
    else
      redirect '/login'
    end
  end
  
  #If user is not logged in then error else post a new tweet in users profile
  NanoTwitter.post '/tweet/:tweet_id/retweet' do
    @curuser=get_cur_user
    begin
      tweetid=params['tweet_id']
      comment=params['comment']
      if comment
        tweet=@curuser.tweets.create text:params['comment'],create_time:Time.now,reference:tweetid
        tweet.save
        {:created=>true,:count=>0}.to_json
      else
        retweet=@curuser.retweets.find_by tweet_id:tweetid
        if retweet
          retweet.destroy
          {:created=>false,:count=>Tweet.find(tweetid).retweets.count}.to_json
        else
          @curuser.retweets.create tweet_id:tweetid,create_time:Time.now
          {:created=>true,:count=>Tweet.find(tweetid).retweets.count}.to_json
        end
      end
    rescue
      404
    end
  end

  NanoTwitter.post '/tweet/:tweet_id/comment/new' do
    @curuser=get_cur_user
    begin
      tweetid=params['tweet_id']
      tweet=Tweet.find_by :id=>tweetid
      comment=params['comment']
      if comment && tweet
        tweet=@curuser.tweets.create text:params['comment'],create_time:Time.now,reply_to:tweetid,conversation_root:tweet.conversation_root
        tweet.save
      end
    rescue
      404
    end
  end

  NanoTwitter.post '/tweet/:tweet_id/expand' do
    begin
      tweetid=params['tweet_id']
      tweet=Tweet.find_by :id=>tweetid
      if tweet && tweet.id==tweet.conversation_root
        @tweets=Tweet.find_by(:conversation_root=>tweet.conversation_root).order(create_time: :desc)
        {:ancestors=>nil,:descendants=>(erb :comments)}.to_json
      elsif tweet && tweet.id!=tweet.conversation_root
        @tweets=Tweet.find_by(:conversation_root=>tweet.conversation_root)
        {:ancestors=>(erb :conversation),:descendants=>nil}.to_json
      end
    rescue
      404
    end
  end


  NanoTwitter.post '/tweet/:tweet_id/favourite' do
    @curuser=get_cur_user
    begin
      tweetid=params['tweet_id']
      fav=@curuser.favourites.find_by :tweet_id=>tweetid
      if fav
        fav.destroy
        {:created=>false,:count=>Tweet.find(tweetid).favourites.count}.to_json
      else
        @curuser.favourites.create tweet_id:tweetid,create_time:Time.now
        {:created=>true,:count=>Tweet.find(tweetid).favourites.count}.to_json
      end
    rescue
      404
    end
  end
