require '../components/details-panel'

App.CollectionController = Ember.Controller.extend

  # Selected delta, currently displayed in details
  selected: null

  # When the selected delta is reseted to null, return back to collection route
  # The transition to details route must only be performed in the select action
  # Do not performs on init, because we must wait for Collection.DeltaDetails route
  # to set this value
  updateSelected: (->
    @transitionToRoute 'collection' unless @selected?
  ).observes 'selected'
