require '../models/challenge'
require '../controllers/challenges'
AuthenticatedRoute = require './authenticated'

App.ChallengesRoute = AuthenticatedRoute.extend

  model: ->  @store.find 'challenge'
