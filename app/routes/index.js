import Ember from 'ember';

export default Ember.Route.extend({

  // Redirect to home if already authenticated
  beforeModel() {
    const sessionRestore = this.container.lookup('service:session-restore');
    return sessionRestore.restore().then(() => {
      if (this.get('session.isAuthenticated')) {
        console.log('already connected');
        this.transitionTo('home');
      }
    });
  }

});
