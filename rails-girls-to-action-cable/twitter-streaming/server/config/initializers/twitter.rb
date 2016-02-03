require 'twitter'

module TwitterStream
  class << self
    def configure
      @client = Twitter::Streaming::Client.new do |config|
        config.consumer_key        = "<consumer_key>"
        config.consumer_secret     = "<consumer_secret>"
        config.access_token        = "<access_token>"
        config.access_token_secret = "<access_token_secret>"
      end
    end

    def stream(keyword, &block)
      @client.filter(track: keyword) do |object|
        if object.is_a? Twitter::Tweet
          block.call object
        end
      end
    end
  end
end

TwitterStream.configure
