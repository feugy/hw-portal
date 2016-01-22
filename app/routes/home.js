import Ember from 'ember';
import AuthenticatedRoute from 'hw-portal/routes/authenticated';

export default AuthenticatedRoute.extend({

  /**
   * Home data is compound by multiple models (challenges, last activity...)
   * Get all these data once, an cast them down in different attributes
   */
  model() {
    return new Ember.RSVP.Promise((resolve, reject) =>
      Ember.$.getJSON('/data/home.json')
        .done(data => {
          // Enrich data with model when possible
          if (data.challenges) {
            data.challenges = data.challenges.map(challenge =>
              this.store.push(this.store.normalize('challenge', challenge))
            );
          }
          resolve(data);
        }).fail(reject)
    );
  },

  /**
   * Instead of affecting a single model property to controller,
   * affects the different data to their respective properties (rank, challenges, activity)
   *
   * @param {Ember.Controller} controller - controller affected
   * @param {Object} data - data returned by the route.model() method, whose properties will
   * be copied into controller
   */
  setupController(controller, data) {
    this._super(controller, data);
    controller.set('user', this.get('session.content.currentUser'));
  }
});
