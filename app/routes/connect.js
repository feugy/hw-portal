import Ember from 'ember';
import ENV from 'hw-portal/config/environment';

export default Ember.Route.extend({

  // Redirect to index if already authenticated
  beforeModel() {
    const sessionRestore = this.container.lookup('service:session-restore');
    return sessionRestore.restore().then(() => {
      if (this.get('session.isAuthenticated')) {
        console.log('already connected');
        this.transitionTo('index');
      }
    });
  },

  actions: {

    logWith(provider) {
      ENV.torii.providers['google-oauth2'].redirectUri = `${window.location.protocol}//${window.location.host}${window.location.pathname}`;

      console.log(`log with ${provider}`);

      const options = {};
      if (provider === 'huby-woky') {
        const controller = this.controllerFor('connect');
        if (!controller.logIn.valid) {
          return;
        }
        options.login = controller.logIn.login;
        options.password = controller.logIn.password;
      }

      this.get('session').
        open(provider, options).
        // access granted: redirect to home page
        then(user => {
          console.log('connected user', user);
        }).
        then(() => this.transitionTo('home')).
        // access denied: display error
        catch(err => this.controllerFor('connect').set('connectError', err));
    }
  }
});
