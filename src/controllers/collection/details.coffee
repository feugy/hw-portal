require '../../components/delta-placeholder'
translate = new (require '../../helpers/translate')().compute

App.CollectionDetailsController = Ember.Controller.extend

  needs: 'collection'
  placeholder: Ember.computed.alias 'controllers.collection.placeholder'

  placeholderUpdate: (->
    @set 'title', translate "deltas.#{@get 'placeholder.kind'}.name"
    @set 'details', translate "deltas.#{@get 'placeholder.kind'}.details"
  ).observes('placeholder').on 'init'
