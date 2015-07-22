App.PanelLayoutComponent = Ember.Component.extend

  classNames: 'off-canvas-wrap l-panel-layout'

  attributeBindings: ['offCanvas:data-offcanvas']
  offCanvas: true

  title: Ember.computed 'current',
    get: -> 'nav.' + @get 'current'
