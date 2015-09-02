App.ApplicationRoute = Ember.Route.extend

  actions:

    # Top level logout action: redirect to index.
    backToHome: ->
      @transitionTo 'index'
