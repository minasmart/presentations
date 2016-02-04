require 'twitter'

module TwitterStream
  class << self
    def configure
      @client = Twitter::Streaming::Client.new do |config|
        config.consumer_key        = "voa81SelYqBkYj49R1Zg2cSZY"
        config.consumer_secret     = "Godf5No5saDSkuiGo7TomcU3AoW9QE1y8ysETCGxc1vPep5iyQ"
        config.access_token        = "27662657-9fgP2HCqppLeFVpPsslJtQ0jXswfCIXWGSng331qm"
        config.access_token_secret = "el9jj47Up6uzPGE5uI0dXSkS7W6jA92bJypCn9yrORSbq"
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
