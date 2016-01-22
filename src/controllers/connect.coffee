require '../components/panel-layout'
translate = new (require '../helpers/translate')().compute

signInEvents = ['signIn.login', 'signIn.password', 'signIn.confirm']
logInEvents = ['logIn.login', 'logIn.password']

App.ConnectController = Ember.Controller.extend

  connectError: null

  # Log-in form fields and state
  logIn:
    valid: false
    login: null
    password: null
    loginMissing: false
    passwordMissing: false

  # Sign-in form fields and state
  signIn:
    valid: false
    login: null
    password: null
    confirm: null
    loginMissing: false
    passwordMissing: false
    confirmDiffers: false

  # Updates error flags when editing sign-in fields.
  # Clear log-in fields.
  checkSignIn: ->
    loginLength = @signIn.login?.trim().length
    passwordLength = @signIn.password?.trim().length
    @set 'signIn.loginMissing', loginLength is 0 or not loginLength?
    @set 'signIn.passwordMissing', passwordLength is 0 or not passwordLength?
    @set 'signIn.confirmDiffers', @signIn.password isnt @signIn.confirm
    @set 'signIn.valid', not (@signIn.loginMissing or @signIn.passwordMissing or @signIn.confirmDiffers)

    @removeObserver event, @, @checkLogIn for event in logInEvents
    @set 'logIn',
      valid: false
      login: null
      password: null
      loginMissing: false
      passwordMissing: false
      inhibit: false
    @addObserver event, @, @checkLogIn for event in logInEvents

  # Updates error flags when editing log-in fields.
  # Clear sign-in fields.
  checkLogIn: ->
    loginLength = @logIn.login?.trim().length
    passwordLength = @logIn.password?.trim().length
    @set 'logIn.loginMissing', loginLength is 0 or not loginLength?
    @set 'logIn.passwordMissing', passwordLength is 0 or not passwordLength?
    @set 'logIn.valid', not (@logIn.loginMissing or @logIn.passwordMissing)

    @removeObserver event, @, @checkSignIn for event in signInEvents
    @set 'signIn',
      valid: false
      login: null
      password: null
      confirm: null
      loginMissing: false
      passwordMissing: false
      confirmDiffers: false
    @addObserver event, @, @checkSignIn for event in signInEvents

  init: (args...) ->
    @_super args...
    @emailPlaceholder = translate 'plh.email'
    @passwordPlaceholder = translate 'plh.password'
    @passwordConfirmPlaceholder = translate 'plh.passwordConfirm'

    # Because of their cyclic nature, checkLogIn and checkSignIn must be manually
    # wired and unwired, and not use Ember.run.Once to keep their synchronism
    @addObserver event, @, @checkLogIn for event in logInEvents
    @addObserver event, @, @checkSignIn for event in signInEvents

  actions:
    closeConnectError: -> @set 'connectError', null
