require '../components/panel-layout'
translator = new (require '../helpers/translate')()

App.ConnectController = Ember.Controller.extend

  init: (args...) ->
    @_super args...
    @emailPlaceholder = translator.compute 'plh.email'
    @passwordPlaceholder = translator.compute 'plh.password'
    console.log @
