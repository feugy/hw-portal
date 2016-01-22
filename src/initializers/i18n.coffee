require '../translations/fr'

Ember.Application.initializer
  name: 'i18n-init'

  initialize: ->
    I18n.fallbacks = true
    I18n.defaultLocale = 'fr'
    I18n.locale = navigator.userLanguage or navigator.language or 'en'
    console.log "Current locale is #{I18n.currentLocale()}"
