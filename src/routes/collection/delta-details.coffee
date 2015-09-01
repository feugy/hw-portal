App.CollectionDeltaDetailsRoute = Ember.Route.extend

  # Redirect to index if not authenticated
  beforeModel: ->
    @transitionTo 'index' unless @get 'session.isAuthenticated'

  # Redirect to collection if delta was not found.
  # Otherwise, update collection controller with selected model
  #
  # @param {Model} model - displayed delta, or null
  afterModel: (model) ->
    return @transitionTo 'collection' unless model?
    @controllerFor('collection').set 'selected', model

  # Retrieve displayed model from inner Delta cache.
  #
  # @param {Object} params - route parameters, containing displayed delta id
  model: (params) ->
    # Use peek that only looks into the cache to get delta from collection
    # and not from server.
    @store.peekRecord 'delta', params.id
