AuthenticatedRoute = require './authenticated'
require '../controllers/settings'
require '../models/gamer'

App.SettingsRoute = AuthenticatedRoute.extend

  # Get model for the main controller
  # @return {Object} the current connected user, retrieved from session
  model: ->
    new Ember.RSVP.Promise (resolve, reject) =>
      Ember.$.getJSON('/data/settings.json')
        .done (data) =>
          # Enrich data with model when possible
          if data.accounts?
            # TODO until server is mocked, main account is set client side
            # It's always the current user
            data.accounts.main = @get 'session.content.currentUser'
            data.accounts.secondary = (for account in data.accounts.secondary
              @store.push @store.normalize 'gamer', account
            )
          resolve data
        .fail reject

  # Redirect to home if not the main account
  #
  # @param {Object} model - settings containing accounts
  afterModel: (model) ->
    @transitionTo 'home' if @get('session.content.currentUser.id') isnt model?.accounts?.main?.get 'id'
