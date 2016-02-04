import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    const filter = localStorage.getItem('filter');
    this.cable = window.ActionCable.createConsumer('http://localhost:3000/cable');

    return { filter, tweets: Ember.A([]) };
  },

  setupController(controller, model) {
    this._super(...arguments);

    if (model.filter) {
      this.connect();
    }
  },

  connect() {
    this.subscription = this.cable.subscriptions.create({
      channel: 'TwitsChannel',
      filter: this.controller.get('model.filter')
    }, {
      disconnected() {
        console.info('dun\' broke the connection!');
      },
      received: this.receivedTweet.bind(this)
    });
  },

  disconnect() {
    this.subscription.unsubscribe();
  },

  receivedTweet(data) {
    this.controller.get('model.tweets').unshiftObject(data);
    console.info('got a tweet');
  },

  actions: {
    storeFilter(filter) {
      this.controller.set('model.filter', filter);
      localStorage.setItem('filter', filter);
      this.connect();
    },

    forgetFilter() {
      localStorage.removeItem('filter');
      this.controller.set('model.filter', null);
      this.disconnect();
    }
  }

});
