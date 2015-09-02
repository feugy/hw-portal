require '../../controllers/collection/details'

App.CollectionDetailsRoute = Ember.Route.extend

  # Redirect to index if not authenticated
  beforeModel: ->
    @transitionTo 'index' unless @get 'session.isAuthenticated'

  # Update collection controller with selected models, that may not exists (empty array)
  #
  # @param {Model} model - displayed delta, or null
  afterModel: (model) ->
    # Update collection controller to set displayed models
    @controllerFor('collection').set 'selected', model

  # Retrieve available delta (in local cache) of a given kind
  #
  # @param {Object} params - route parameters, containing displayed delta kind
  model: (params) ->
    # Use filter that only looks into the cache to get delta from collection
    # and not from server.
    @store.filter 'delta', (delta) ->
      params.kind is delta.get 'kind'
    .then (deltas) =>
      # Set collection's selected kind to allow placeholder detection
      @controllerFor('collection').set 'selectedKind', params.kind
      deltas.content
