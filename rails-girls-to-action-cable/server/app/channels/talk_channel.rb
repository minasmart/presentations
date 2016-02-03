# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class TalkChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'messages'
  end

  def talk(data)
    ActionCable.server.broadcast('messages', {
      body: data['body'],
      username: data['username']
    })
  end
end
