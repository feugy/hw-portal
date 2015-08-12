require '../controllers/connect'
require '../adapters/auth'

App.ConnectRoute = Ember.Route.extend

  actions:

    logWith: (provider) ->
      console.log "log with #{provider}"

      options = {}
      if provider is 'huby-woky'
        controller = @controllerFor 'connect'
        loginLength = controller.login?.trim().length
        passwordLength = controller.password?.trim().length
        controller.set 'loginMissing', loginLength is 0 or not loginLength?
        controller.set 'passwordMissing', passwordLength is 0 or not passwordLength?
        options.login = controller.login
        options.password = controller.password
        return if controller.get('loginMissing') or controller.get 'passwordMissing'

      @get('session').open(provider, options).then () =>
        # access granted: redirect to home page
        console.log @get 'session'
        @transitionTo 'index'

      .catch (err) =>
        # access denied: display error
        @controllerFor('connect').set 'connectError', err
