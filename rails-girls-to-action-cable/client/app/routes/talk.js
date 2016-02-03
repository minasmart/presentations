import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    const username = localStorage.getItem('username');
    this.cable = window.ActionCable.createConsumer('http://localhost:3000/cable');

    if (username) {
      this.connect();
    }
    return { username, messages: Ember.A([]) };
  },

  connect() {
    this.subscription = this.cable.subscriptions.create('TalkChannel', {
      disconnected() {
        alert('dun\' broke the connection!');
      },
      received: this.receivedMessage.bind(this)
    });
  },

  disconnect() {
    this.subscription.unsubscribe();
  },

  receivedMessage(data) {
    this.controller.get('model.messages').pushObject(data);
  },

  actions: {
    storeUsername(username) {
      this.controller.set('model.username', username);
      localStorage.setItem('username', username);
      this.connect();
    },

    forgetUsername() {
      localStorage.removeItem('username');
      this.controller.set('model.username', null);
      this.disconnect();
    },

    sendMessage(body) {
      const username = this.controller.get('model.username');
      this.subscription.perform('talk', { body, username });
    }
  }
});
