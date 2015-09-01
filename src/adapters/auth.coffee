storageKey = 'torii.authent'

# Session adapter: transfer the authentication provider's token to get
# in return the current user.
#
# Freely inspired from http://www.sitepoint.com/twitter-authentication-ember-js-torii/
App.ApplicationToriiAdapter = Ember.Object.extend

  # Tries to authenticate user with a given provided
  # A brand new session will be created, and authentication data stored into local storage
  #
  # @param {Object} authentication - authentication provider's data
  # @param {String} authentication.token - authorization token
  # @param {String} authentication.provider - provider's name
  # @return {Promise} resolved with the currentUser object
  open: (authentication) ->
    localStorage.setItem storageKey, JSON.stringify authentication
    @fetch()

  # Used to validate an existing session from the local storage, if available
  #
  # @return {Promise} resolved with the currentUser object
  fetch: ->
    new Ember.RSVP.Promise (resolve, reject) ->
      return reject() unless localStorage.getItem storageKey
      authentication = JSON.parse localStorage.getItem storageKey
      provider = authentication.provider.replace '-oauth2', ''

      # TODO send autorization code to server to get real user
      Ember.$.getJSON('/data/current-user.json', provider: provider).done(resolve).fail reject
    .then (response) =>
      store = @get 'store'
      user = store.createRecord 'gamer', response.user
      currentUser: user

  # Closes the session, cleaning local storage
  close: ->
    return new Ember.RSVP.Promise (resolve, reject) ->
      localStorage.removeItem storageKey
      console.log 'session closed'
      resolve()

# Provider for huby-woky authentication
App.HubyWokyToriiProvider = Ember.Object.extend

  # Ask server to authenticate current user from its credentials
  #
  # @param {Object} credentials - user's credentials
  # @param {String} credentials.login - user login
  # @param {String} credentials.password - user password
  # @return {Promise} resolved with the authentication data
  open: (credentials) ->
    return new Ember.RSVP.Promise (resolve, reject) ->
      Ember.$.ajax
        url: '/data/authenticate.json'
        dataType: 'json',
        headers: credentials
        success: (data) ->
          data.provider = 'huby-woky'
          resolve data
        error: (xhr, status, err) -> reject err
