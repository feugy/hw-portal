App.Router = Ember.Router.extend location: 'history'

App.Router.map ->
  @route 'rankings', path: '/rankings'
