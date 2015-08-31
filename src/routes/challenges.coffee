require '../models/challenge'
require '../controllers/challenges'

App.ChallengesRoute = Ember.Route.extend

  beforeModel: ->
    @transitionTo 'index' unless @get 'session.isAuthenticated'

  model: (params) ->  @store.find 'challenge'
