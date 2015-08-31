require '../models/challenge'
require '../controllers/challenges'
require '../components/display-challenge'

App.ChallengesRoute = Ember.Route.extend

  beforeModel: ->
    @transitionTo 'index' unless @get 'session.isAuthenticated'

  model: (params) ->  @store.find 'challenge'
