require './routes/index'
require './routes/rankings'
require './routes/connect'
require './routes/home'
require './routes/challenges'
require './routes/challenges/details'
require './routes/collection'
require './routes/collection/details'
require './routes/settings'
require './adapters/fixtures'

App.Router = Ember.Router.extend location: 'history'

App.Router.map ->
  @route 'connect'
  @route 'rankings'
  @route 'home'
  @route 'challenges', ->
    @route 'details', path: '/:id'
  @route 'collection', ->
    @route 'details', path: '/:kind'
  @route 'settings'
