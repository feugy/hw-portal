require '../models/stats'

# Displays responsive navigation side panels
# As it will be in every pages, this component fetch it's own data, except session
#
# http://discuss.emberjs.com/t/how-to-make-ember-component-fetch-data-from-server-put-ajax-call-
# inside-the-component-seems-not-a-good-practise-to-handle-this/6984/13
App.PanelLayoutComponent = Ember.Component.extend

  classNames: 'off-canvas-wrap l-panel-layout'

  # Current session to get authenticated user
  session: null
  user: null

  # Logout checker
  isLogout: false

  # General statistics displayed
  stats: null

  # Link to home, depending on connection state
  homeLink: 'index'

  # On session changes, refresh user
  refreshUser: ( ->
    @set 'user', @session?.content?.currentUser
    @set 'homeLink', if @get('user')? then 'home' else 'index'
  ).observes('session.content.currentUser').on 'init'

  # On logout change, performs logout
  logout: ( ->
    @session?.close()
  ).observes 'isLogout'

  # Foundation's off-canvas component
  attributeBindings: ['offCanvas:data-offcanvas']
  offCanvas: true

  init: (args...) ->
    @_super args...
    @get('targetObject.store').find('stats').then (stats) =>
      @set 'stats', stats.objectAt 0
