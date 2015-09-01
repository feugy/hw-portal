translate = new (require '../../helpers/translate')().compute

App.ChallengesDetailsRoute = Ember.Route.extend

  # Redirect to index if not authenticated
  beforeModel: ->
    @transitionTo 'index' unless @get 'session.isAuthenticated'

  # Redirect to collection if challenge was not found.
  # Otherwise, update collection controller with selected model
  #
  # @param {Model} model - displayed delta, or null
  afterModel: (model) ->
    return @transitionTo 'challenges' unless model?
    @controllerFor('challenges').set 'selected', model

  # Retrieve displayed model from inner Challenge cache.
  #
  # @param {Object} params - route parameters, containing displayed challenge id
  model: (params) ->
    # Use peek that only looks into the cache to get challenge from collection
    # and not from server.
    @store.peekRecord 'challenge', params.id

  setupController: (controller, model) ->
    @_super controller, model
    if model?
      # Because selected title and details are translated with a parametrized info,
      # we must get them manually in the controller
      controller.set 'title', translate "challenges.#{model.id}.name"
      controller.set 'details', translate "challenges.#{model.id}.details"
