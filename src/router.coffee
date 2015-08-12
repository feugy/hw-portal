require './controllers/index'
require './routes/rankings'
require './routes/connect'

App.Router = Ember.Router.extend location: 'history'

App.Router.map ->
  @route 'connect'
  @route 'rankings'
