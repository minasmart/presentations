import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'div',
  tweetId: null,

  didInsertElement: function() {
    var tweetId = this.get('tweetId');

    if (Ember.isEmpty(tweetId)) { return; }

    window.twttr.widgets.createTweet(tweetId.toString(), this.$('.the-tweet')[0]);
  }
});
