# too allow foundation JavaScript components embedded in template to be initialized,
# extends component didInsertElement to perform intialization
Ember.Component.reopen

  didInsertElement: (args...) ->
    @_super args...
    Ember.run.scheduleOnce 'afterRender', @, () =>
      @$(document).foundation 'reflow'

window.App = Ember.Application.create()

require './initializers/i18n'
require './helpers'
require './router'
