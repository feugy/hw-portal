# Session adapter: transfer the authentication provider's token to get
# in return the current user.
App.ApplicationToriiAdapter = Ember.Object.extend

  # Ask server for the current user
  #
  # @param {Object} authentication - authentication provider's data
  # @param {String} authentication.token - authorization token
  # @param {String} authentication.provider - provider's name
  # @return {Promise} resolved with the currentUser object
  open: (authentication) ->
    # TODO send autorization code to server to get real user
    provider = authentication.provider.replace '-oauth2', ''
    new Ember.RSVP.Promise (resolve, reject) ->
      Ember.$.getJSON('/data/current-user.json', provider: provider).done(resolve).fail reject
    .then (response) ->
      currentUser: response.user

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
