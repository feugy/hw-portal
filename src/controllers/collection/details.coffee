require '../../components/delta-placeholder'
translate = new (require '../../helpers/translate')().compute

App.CollectionDetailsController = Ember.Controller.extend

  # Shortcuts to Collection parent controller attributes
  needs: 'collection'
  placeholder: Ember.computed.alias 'controllers.collection.placeholder'
  losses: Ember.computed.alias 'controllers.collection.model.losses'

  # Flag indicating that player got a delta of this kind in the past
  isLost: false

  # When Collection controller's placeholder is set, updates name and details
  updatePlaceholder: (->
    @set 'title', translate "deltas.#{@get 'placeholder.kind'}.name"
    @set 'details', translate "deltas.#{@get 'placeholder.kind'}.details"
  ).observes('placeholder').on 'init'

  # When Collection controller model is available, update isLost flag
  updateLost: (->
    placeholderKind = @get 'placeholder.kind'
    @set 'isLost', @get('losses').find((kind) -> kind is placeholderKind)?
  ).observes('losses', 'placeholder').on 'init'
