require './routes/rankings'
require './controllers/index'
require './controllers/rankings'
require './controllers/connect'

App.Router = Ember.Router.extend location: 'history'

App.Router.map ->
  @route 'connect'
  @route 'rankings'
