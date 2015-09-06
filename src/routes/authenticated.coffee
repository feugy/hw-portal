module.exports = App.AuthenticatedRoute = Ember.Route.extend

  # Redirect to index if not authenticated
  beforeModel: ->
    @transitionTo 'index' unless @get 'session.isAuthenticated'

  actions:

    # Top level logout action: redirect to index.
    backToHome: ->
      @transitionTo 'index'
