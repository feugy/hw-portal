require '../components/panel-layout'
translator = new (require '../helpers/translate')()

App.ConnectController = Ember.Controller.extend

  login: null
  password: null

  loginMissing: false
  passwordMissing: false

  connectError: null

  init: (args...) ->
    @_super args...
    @emailPlaceholder = translator.compute 'plh.email'
    @passwordPlaceholder = translator.compute 'plh.password'

  actions:
    closeConnectError: -> @set 'connectError', null
