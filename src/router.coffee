require './routes/index'
require './routes/rankings'
require './routes/connect'
require './routes/home'

App.Router = Ember.Router.extend location: 'history'

App.Router.map ->
  @route 'connect'
  @route 'rankings'
  @route 'home'
