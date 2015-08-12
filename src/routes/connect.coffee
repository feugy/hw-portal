require '../controllers/connect'
require '../adapters/auth'

App.ConnectRoute = Ember.Route.extend

  actions:

    logWith: (provider) ->
      console.log "log with #{provider}"
      @get('session').open(provider).then () =>
        # access granted: redirect to home page
        console.log @get 'session'
      .catch (err) =>
        # access denied: TODO display error
        console.error err

    connect: () ->
      controller = @controllerFor 'connect'
      controller.set 'loginMissing', controller.login?.trim().length is 0
      controller.set 'passwordMissing', controller.password?.trim().length is 0
      console.log 'credentials:', controller.login, controller.password
