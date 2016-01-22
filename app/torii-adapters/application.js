import Ember from 'ember';

const storageKey = 'torii.authent';

/**# Session adapter: transfer the authentication provider's token to get
 * in return the current user.
 *
 * Freely inspired from http://www.sitepoint.com/twitter-authentication-ember-js-torii/
 */
export default Ember.Object.extend({

  /**
   * Tries to authenticate user with a given provided
   * A brand new session will be created, and authentication data stored into local storage
   *
   * @param {Object} authentication - authentication provider's data
   * @param {String} authentication.token - authorization token
   * @param {String} authentication.provider - provider's name
   * @return {Promise} resolved with the currentUser object
   */
  open(authentication) {
    localStorage.setItem(storageKey, JSON.stringify(authentication));
    return this.fetch();
  },

  /**
   * Used to validate an existing session from the local storage, if available
   *
   * @return {Promise} resolved with the currentUser object
   */
  fetch() {
    return new Ember.RSVP.Promise((resolve, reject) => {
      if (!localStorage.getItem(storageKey)) {
        return reject();
      }
      const authentication = JSON.parse(localStorage.getItem(storageKey));
      const provider = authentication.provider.replace('-oauth2', '');

      // TODO send autorization code to server to get real user
      Ember.$.getJSON('/data/current-user.json', {provider}).
        done(resolve).
        fail(reject);
    }).then(response => {
      return {
        currentUser: this.get('store').createRecord('gamer', response.user)
      };
    });
  },

  /**
   * Closes the session, cleaning local storage
   */
  close() {
    return new Ember.RSVP.Promise(resolve => {
      localStorage.removeItem(storageKey);
      console.log('session closed');
      resolve();
    });
  }
});
