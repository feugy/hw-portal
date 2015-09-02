App.CollectionDetailsRoute = Ember.Route.extend

  # Redirect to index if not authenticated
  beforeModel: ->
    @transitionTo 'index' unless @get 'session.isAuthenticated'

  # Update collection controller with selected models, that may not exists (empty array)
  #
  # @param {Model} model - displayed delta, or null
  afterModel: (model) ->
    @controllerFor('collection').set 'selected', model

  # Retrieve available delta (in local cache) of a given kind
  #
  # @param {Object} params - route parameters, containing displayed delta kind
  model: (params) ->
    # Update collection controller to set selected kind
    @controllerFor('collection').set 'selectedKind', params.kind
    # Use filter that only looks into the cache to get delta from collection
    # and not from server.
    @store.filter 'delta', (delta) ->
      params.kind is delta.get 'kind'
    .then (deltas) ->
      deltas.content

