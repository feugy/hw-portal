require '../components/details-panel'
require '../components/delta-scene'

App.CollectionController = Ember.Controller.extend

  # Selected deltas (an array), currently displayed in details
  selected: null

  # Selected placeholder kind
  selectedKind: null

  # When the selected delta is reseted to null, return back to collection route
  # The transition to details route must only be performed in the select action
  # Do not performs on init, because we must wait for Collection.DeltaDetails route
  # to set this value
  updateSelected: (->
    unless @selected?
      @set 'selectedKind', null
      @transitionToRoute 'collection'
  ).observes 'selected'

  actions:

    # On delta placeholder selection, navigate to relevant detailed view
    # Navigate to full colleciton if re-selecting the previous delta placeholder
    #
    # @param {String} kind - delta kind selected
    select: (kind) ->
      selected = @get 'selectedKind'
      if kind is selected
        @set 'selected', null
        # In this cas, selected kind will be reset to null, and navigation will occur
      else
        @set 'selectedKind', kind
        @transitionToRoute 'collection.details', kind if kind?
