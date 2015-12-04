  require 'typhoeus'
  require 'json'

  class Follow
    class << self; attr_accessor :base_uri end

      def self.find_follower_by_name(name)
        response = Typhoeus::Request.get("#{base_uri}/api/v1/followers/username/#{name}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
      end

      def self.find_follower_by_id(id)
        response = Typhoeus::Request.get("#{base_uri}/api/v1/followers/userid/#{id}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
      end

      def self.find_following_by_name(name)
        response = Typhoeus::Request.get("#{base_uri}/api/v1/followings/username/#{name}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
      end

      def self.find_following_by_id(id)
        response = Typhoeus::Request.get("#{base_uri}/api/v1/followings/userid/#{id}")
        if response.code == 200
            JSON.parse(response.body)
        elsif response.code == 404
            nil
        else
            raise response.body
        end
      end
end 