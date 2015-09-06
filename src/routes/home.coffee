AuthenticatedRoute = require './authenticated'
require '../models/challenge'
require '../components/display-activity'

App.HomeRoute = AuthenticatedRoute.extend

  # Home data is compound by multiple models (challenges, last activity...)
  # Get all these data once, an cast them down in different attributes
  model: ->
    new Ember.RSVP.Promise (resolve, reject) =>
      Ember.$.getJSON('/data/home.json')
        .done (data) =>
          # Enrich data with model when possible
          if data.challenges?
            data.challenges = (for challenge in data.challenges
              @store.push @store.normalize 'challenge', challenge
            )
          resolve data
        .fail reject

  # Instead of affecting a single model property to controller,
  # affects the different data to their respective properties (rank, challenges, activity)
  #
  # @param {Ember.Controller} controller - controller affected
  # @param {Object} data - data returned by the route.model() method, whose properties will
  # be copied into controller
  setupController: (controller, data) ->
    @_super controller, data
    controller.set 'user', @get 'session.content.currentUser'
