require './routes/index'
require './routes/rankings'
require './routes/connect'
require './routes/home'
require './routes/challenges'
require './adapters/fixtures'

App.Router = Ember.Router.extend location: 'history'

App.Router.map ->
  @route 'connect'
  @route 'rankings'
  @route 'home'
  @route 'challenges'
