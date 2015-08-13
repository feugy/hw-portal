require '../controllers/connect'
require '../adapters/auth'

App.ConnectRoute = Ember.Route.extend

  beforeModel: ->
    @transitionTo 'index' if @get 'session.isAuthenticated'

  actions:

    logWith: (provider) ->
      console.log "log with #{provider}"

      options = {}
      if provider is 'huby-woky'
        controller = @controllerFor 'connect'
        return unless controller.logIn.valid
        options.login = controller.logIn.login
        options.password = controller.logIn.password

      @get('session').open(provider, options).then () =>
        # access granted: redirect to home page
        @transitionTo 'index'

      .catch (err) =>
        # access denied: display error
        @controllerFor('connect').set 'connectError', err
