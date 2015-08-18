require '../controllers/index'

App.IndexRoute = Ember.Route.extend

  beforeModel: ->
    @transitionTo 'home' if @get 'session.isAuthenticated'
