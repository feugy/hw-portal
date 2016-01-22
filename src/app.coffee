# too allow foundation JavaScript components embedded in template to be initialized,
# extends component didInsertElement to perform intialization
Ember.Component.reopen

  didInsertElement: (args...) ->
    @_super args...
    Ember.run.scheduleOnce 'afterRender', @, () =>
      @$(document).foundation 'reflow'

# register add-on configuration before loading them, in synchronous code
window.ENV = {} unless window.ENV?
require './config/auth'

window.App = Ember.Application.create()

require './initializers/i18n'
require './initializers/auth'
require './helpers'
require './router'
