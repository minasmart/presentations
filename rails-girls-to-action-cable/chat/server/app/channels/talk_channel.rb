# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class TalkChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'messages'
    ActionCable.server.broadcast('messages', {
      body: "Say hi to our new friend: #{params[:username]}!",
      username: 'Chat Bot'
    })
  end

  def talk(data)
    ActionCable.server.broadcast('messages', {
      body: data['body'],
      username: data['username']
    })
  end

  def unsubscribed
    ActionCable.server.broadcast('messages', {
      body: "Bye #{params[:username]}!",
      username: 'Chat Bot'
    })
  end
end
