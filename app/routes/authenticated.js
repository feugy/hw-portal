import Ember from 'ember';

export default Ember.Route.extend({

  // Redirect to index if not authenticated
  beforeModel() {
    const sessionRestore = this.container.lookup('service:session-restore');
    return sessionRestore.restore().then(() => {
      if (!this.get('session.isAuthenticated')) {
        console.log('access to authenticated route without current user');
        this.transitionTo('index');
      }
    });
  },

  actions: {
    // Top level logout action: redirect to index.
    backToHome() {
      this.transitionTo('index');
    }
  }
});
