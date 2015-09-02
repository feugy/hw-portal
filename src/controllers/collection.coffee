require '../components/details-panel'
require '../components/delta-scene'

App.CollectionController = Ember.Controller.extend

  # Selected deltas (an array), currently displayed in details
  selected: null

  # Selected kind placeholder, set by CollectionDetails controller
  selectedKind: null

  # Selected placeholder
  placeholder: null

  # When the selected delta is reseted to null, return back to collection route
  # The transition to details route must only be performed in the select action
  # Do not performs on init, because we must wait for Collection.Details route
  # to set this value
  updateSelected: (->
    unless @selected?
      @set 'placeholder', null
      @transitionToRoute 'collection'
  ).observes 'selected'

  # When model is available, set the selected placeholder using selectedKind set
  # by Collection.Details route. Can't be done on init.
  updatePlaceholder: (->
    if @selectedKind?
      for scene in @get 'model.scenes'
        placeholder = scene.get('placeholders').find (placeholder) => placeholder.kind is @selectedKind
        if placeholder?
          @set 'placeholder', placeholder
          break
  ).observes 'model'

  actions:

    # On delta placeholder selection, navigate to relevant detailed view
    # Navigate to full colleciton if re-selecting the previous delta placeholder
    #
    # @param {Object} placeholder - delta placeholder selected
    select: (placeholder) ->
      selected = @get 'placeholder'
      if placeholder is selected
        @set 'selected', null
        # In this cas, selected placeholder will be reset to null, and navigation will occur
      else
        @set 'placeholder', placeholder
        @transitionToRoute 'collection.details', placeholder.kind if placeholder?
