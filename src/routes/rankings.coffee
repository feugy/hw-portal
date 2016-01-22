require '../controllers/rankings'
require '../models/gamer'

App.RankingsRoute = Ember.Route.extend

  # Initialize flags to allow first loading
  hasMore: true
  loading: false
  # Keep last query parameters for next loading
  params: null

  queryParams:
    # Sort query parameter change will trigger a full refresh
    sort:
      refreshModel: true

  model: (params) ->
    unless _.isEqual @params, params
      # If query parameters has changed, then reload everything
      @params = params
      @get('controller')?.set 'scrollPosition', 0
      @get('controller')?.set 'model', []
      return @_loadNext true

    @get('controller.model') or @_loadNext()

  actions:
    # Action invoked when a new page of models need to be loaded
    # Does nothing if all models were already loaded
    #
    # @return {Promise|null} with all availble models if a new page was loaded
    load: ->
      return unless @hasMore and not @loading
      @_loadNext().then (models) =>
        return unless models?
        # We cannot return just the loaded models, but instead we must enrich the
        # current controller model array.
        # It ensure template refreshing while keeping already fetched models
        # updates the controller's model ended flag because we don't return the loaded models
        @set 'controller.model.ended', true unless @hasMore
        @get('controller.model').pushObjects models.get 'content'

  # @private
  # Loads the next model page on server.
  # The page will be loaded only if some data are available, based on previous server metadatas
  # The `loading` and `hasMore` flags are updated, and `ended` attribute on model as well
  #
  # @param {Boolean} reset - true when metadata are to be ignored, resulting in loading from begining
  # @return {Promise} with the loaded models
  _loadNext: (reset = false) ->
    # Metas will indicate if some gamers are available
    {offset, limit, total} = @store.metadataFor 'gamer' unless reset
    offset = -10 unless offset?
    limit = 10 unless limit?
    total = 0 unless total?

    # Depending on remaining models, ask for a new page of models
    return new Ember.RSVP.Promise((resolve) -> Ember.run.later {}, resolve) unless total >= offset + limit

    # Refresh flags to inhibit new loading and reflect remaining models
    @loading = true
    @store.find('gamer', offset: offset + limit, limit: limit, sort: @params.sort)
      .then (models) =>
        # If request succeeded, refresh flags using last server data
        {offset, limit, total} = @store.metadataFor('gamer')
        @hasMore = total > offset + limit
        models.set 'ended', true unless @hasMore
        models
      .then (models) -> new Ember.RSVP.Promise (resolve) ->
        # TODO Delay to simulate server latency
        Ember.run.later (-> resolve models), 500
      .catch (err) -> console.error 'failed to fetch gamers: ', err
      .finally => @loading = false
