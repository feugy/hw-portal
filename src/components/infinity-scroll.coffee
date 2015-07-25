# Freely inspired from https://github.com/hhff/ember-infinity
App.InfinityScrollComponent = Ember.Component.extend

  classNames: 'infinity-scroll'
  classNameBindings: 'model.ended'

  model: null
  loadMoreAction: 'load'

  # Unique id for event binding, and debounce for more reactive UI
  guid: null
  eventDebounce: 10

  # Provide here a selector to the scrollable DOM node. Whole window by default
  scrollable: null

  # On component insertion, get the scrollable node and bind event handlers
  didInsertElement: (args...) ->
    @_super args...
    @_setupScrollable()
    @set 'guid', Ember.guidFor @

    bindEvent = (eventName) =>
      @get('scrollable').on "#{eventName}.#{@guid}", () =>
        Ember.run.debounce @, @_checkIfInView, @eventDebounce

    bindEvent 'scroll'
    bindEvent 'resize'
    @_checkIfInView()

  # On component destruction, unbind event handlers
  willDestroyElement: (args...) ->
    @_super args...

    unbindEvent = (eventName) =>
      @get('scrollable').off "#{eventName}.#{@guid}"

    unbindEvent 'scroll'
    unbindEvent 'resize'

  # Get the scrollable node dimension and trigger loading action if scroll reach the bottom
  _checkIfInView: ->
    selfOffset = @$().offset().top
    scrollable = @get 'scrollable'
    scrollableBottom = scrollable.height() + scrollable.scrollTop()
    # Trigger loading action
    @sendAction 'loadMoreAction' if selfOffset < scrollableBottom

  # Get the scrollable element from DOM with a given selector.
  # Use window if no scrollable selector provided.
  #
  # @throws {Error} if a selector is provided does not aim at exactly one element
  _setupScrollable: ->
    scrollable = @get 'scrollable'
    # Use the whole window if no scrollable defined
    return @set 'scrollable', Ember.$(window) unless Ember.typeOf(scrollable) is 'string'

    items = Ember.$(scrollable)
    throw new Error "Multiple scrollable elements found for: #{scrollable}" if items.length > 1
    throw new Error "No scrollable element found for: #{scrollable}" unless items.length is 1
    @set 'scrollable', items.eq(0)

  # Refresh the component state when model changed
  infinityModelPushed: ( ->
    Ember.run.scheduleOnce 'afterRender', @, @_checkIfInView
  ).observes 'model.length'
