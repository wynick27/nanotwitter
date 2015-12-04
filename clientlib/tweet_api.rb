  require 'typhoeus'
  require 'json'

  class Tweet
    class << self; attr_accessor :base_uri end

    def self.find_tweet_by_id(id)
      response = Typhoeus::Request.get("#{base_uri}/api/v1/tweets/tweetid/#{id}")
      if response.code == 200
        JSON.parse(response.body)
      elsif response.code == 404
          nil
      else
          raise response.body
      end
    end

      def self.find_user_tweet_by_username(name)
        response = Typhoeus::Request.get("#{base_uri}/api/v1/tweets/username/#{name}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
          raise response.body
        end
      end

      def self.find_user_tweet_by_userid(id)
        response = Typhoeus::Request.get("#{base_uri}/api/v1/tweets/userid/#{id}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
      end
  end