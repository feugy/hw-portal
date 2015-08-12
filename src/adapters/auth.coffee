App.ApplicationToriiAdapter = Ember.Object.extend

  open: (authentication) ->
    # TODO send autorization code to server to get real user
    console.log authentication
    provider = authentication.provider.replace '-oauth2', ''
    new Ember.RSVP.Promise (resolve, reject) ->
      Ember.$.getJSON('/data/current-user.json', provider: provider).done(resolve).fail reject
    .then (response) ->
      currentUser: response.user
