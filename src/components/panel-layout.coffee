App.PanelLayoutComponent = Ember.Component.extend

  classNames: 'off-canvas-wrap l-panel-layout'

  # Current session to get authenticated user
  session: null
  user: null

  # Logout checker
  isLogout: false

  # On session changes, refresh user
  refreshUser: ( ->
    @set 'user', @session?.content?.currentUser
  ).observes('session.content.currentUser').on 'init'

  # On logout change, performs logout
  logout: ( ->
    @session?.close()
  ).observes 'isLogout'

  # Foundation's off-canvas component
  attributeBindings: ['offCanvas:data-offcanvas']
  offCanvas: true
