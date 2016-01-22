import Ember from 'ember';

/**
 * Provider for huby-woky authentication
 */
export default Ember.Object.extend({

  /**
   * Ask server to authenticate current user from its credentials
   *
   * @param {Object} credentials - user's credentials
   * @param {String} credentials.login - user login
   * @param {String} credentials.password - user password
   * @return {Promise} resolved with the authentication data
   */
  open(credentials) {
    return new Ember.RSVP.Promise((resolve, reject) =>
      Ember.$.ajax({
        url: '/data/authenticate.json',
        dataType: 'json',
        headers: credentials,
        success: data => {
          data.provider = 'huby-woky';
          resolve(data);
        },
        error: (xhr, status, err) => reject(err)
      })
    );
  }

});

