# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
require 'thread'

class TwitsChannel < ApplicationCable::Channel
  def subscribed
    filter = params[:filter]
    stream_name = "tweet_stream_#{filter}"
    stream_from stream_name
    TwitterStream.stream filter do |tweet|
      ActionCable.server.broadcast stream_name, { id: tweet.id }
    end
  end

  def unsubscribed
  end
end
