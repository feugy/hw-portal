App.DetailsPanelComponent = Ember.Component.extend

  classNames: 'off-canvas-wrap l-details-panel'

  # Bound falsy/truthy value used to open or close details
  open: false

  # Foundation's off-canvas component
  attributeBindings: ['offCanvas:data-offcanvas']
  offCanvas: true

  # For multiple yields
  # @see https://coderwall.com/p/qkk2zq/components-with-structured-markup-in-ember-js-v1-10
  details: isDetails: true
  title: isTitle: true

  init: (args...) ->
    @_super args...
    # Private flag used to avoid closing already opened details
    @isOPen = false

  actions:
    # On close button, force details to hide
    close: () ->
      @set 'open', null
      @toggle()

  # Effectively apply isOpen value to Fondation's off-canvas component
  toggle: () ->
    wasOpen = @isOpen
    @isOpen = if @get 'open' then true else false
    if wasOpen isnt @isOpen
      @$('').foundation 'offcanvas', (if @isOpen then 'show' else 'hide'), 'move-left'

  # When open value is externally modified, toggle visibility (only if open is falsy)
  updateState: (->
    Ember.run.scheduleOnce 'afterRender', @, @toggle
  ).observes('open').on 'init'
