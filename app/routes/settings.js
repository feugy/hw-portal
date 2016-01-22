import Ember from 'ember';
import AuthenticatedRoute from 'hw-portal/routes/authenticated';

export default AuthenticatedRoute.extend({

  /**
   * Get model for the main controller
   * @return {Object} the current connected user, retrieved from session
   */
  model() {
    return new Ember.RSVP.Promise((resolve, reject) =>
      Ember.$.getJSON('/data/settings.json').
        done(data => {
          // Enrich data with model when possible
          if (data.accounts) {
            // TODO until server is mocked or available, main account is set client side
            // It's always the current user
            data.accounts.main = this.get('session.content.currentUser');
            data.accounts.secondary = data.accounts.secondary.map(account =>
              this.store.push(this.store.normalize('gamer', account))
            );
          }
          resolve(data);
        }).fail(reject)
    );
  },

  /**
   * Redirect to home if not the main account
   *
   * @param {Object} model - settings containing accounts
   */
  afterModel(model) {
    if (!(model && model.accounts && model.accounts.main &&
        model.accounts.main.get('id') === this.get('session.content.currentUser.id'))) {
      this.transitionTo('home');
    }
  }
});
