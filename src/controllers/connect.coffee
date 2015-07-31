require '../components/panel-layout'
translator = new (require '../helpers/translate')()

App.ConnectController = Ember.Controller.extend

  login: null
  password: null

  loginMissing: false
  passwordMissing: false

  init: (args...) ->
    @_super args...
    @emailPlaceholder = translator.compute 'plh.email'
    @passwordPlaceholder = translator.compute 'plh.password'

  actions:
    connect: () ->
      @set 'loginMissing', @login?.trim().length is 0
      @set 'passwordMissing', @password?.trim().length is 0
      console.log 'credentials:', @login, @password
