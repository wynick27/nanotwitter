
  
  #if user is matches the current user then show new tweet otherwise just show the user's tweets
  NanoTwitter.post '/tweet/new' do
    @curuser=get_cur_user
    if @curuser
      tweet=@curuser.new_tweet(text:params[:text])
      tweet.save
      update_tweet_cache tweet
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
      curtweet=Tweet.find_by :id=>tweetid
      if curtweet && curtweet.user_id != @curuser.id
        if comment
          tweet=@curuser.new_tweet text:params['comment'],reference:tweetid
          tweet.save
          {:created=>true,:count=>0}.to_json
        else
          retweet=@curuser.retweets.find_by tweet_id:tweetid
          if retweet
            retweet.destroy
            {:created=>false,:count=>curtweet.retweets.count}.to_json
          else
            @curuser.retweets.create tweet_id:tweetid,create_time:Time.now
            {:created=>true,:count=>curtweet.retweets.count}.to_json
          end
        end
      else
        {:created=>false,:count=>(curtweet ? curtweet.retweets.count : 0)}.to_json
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
        tweet=@curuser.new_reply tweet,params['comment']
        tweet.save
        @tweets=[tweet]
        {:created=>true,:html=>(erb :reply_list)}.to_json
      else
        {:created=>false}.to_json
      end
    rescue
      404
    end
  end

  NanoTwitter.post '/tweet/:tweet_id/comment' do
    #begin
      tweetid=params['tweet_id']
      tweet=Tweet.find_by :id=>tweetid
      if tweet
        @tweets=tweet.reply_ancestors() || []
        ancestors=(erb :reply_list)
        @tweets=tweet.reply_descendants() || []
        {:ancestors=>ancestors,:descendants=>(erb :reply_list)}.to_json
      end
    #rescue
    #  404
    #end
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
