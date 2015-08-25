require '../models/challenge'
require '../components/display-challenge'

App.ChallengesRoute = Ember.Route.extend

  beforeModel: ->
    @transitionTo 'index' unless @get 'session.isAuthenticated'

  model: (params) ->  @store.find 'challenge'