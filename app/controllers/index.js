import Ember from 'ember';

export default Ember.Controller.extend({

  user: null,

  refreshUser: Ember.on('init', Ember.observer('session.content.currentUser', function() {
    this.set('user', this.get('session.content.currentUser'));
  })),

  actions: {

    /**
     * Scrolls to a particular target within the parallax element
     *
     * @param {String} target - css selector to find the target
     */
    scrollTo(target) {
      target = Ember.$(target);
      if (!target || !target.length) {
        throw new Error(`No target ${target} found`);
      }
      const parallax = Ember.$('.l-parallax');
      parallax.animate({
        scrollTop: target.position().top - parallax.children().first().position().top
      });
    }
  }
});
