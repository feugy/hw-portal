App.RankingsRoute = Ember.Route.extend

  # initialize flags to allow first loading
  hasMore: true
  loading: false

  model: ->
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
        # we cannot return just the loaded models, but instead we must enrich the
        # current controller model array.
        # it ensure template refreshing while keeping already fetched models
        # updates the controller's model ended flag because we don't return the loaded models
        @set 'controller.model.ended', true unless @hasMore
        @get('controller.model').pushObjects models.get 'content'

  # @private
  # Loads the next model page on server.
  # The page will be loaded only if some data are available, based on previous server metadatas
  # The `loading` and `hasMore` flags are updated, and `ended` attribute on model as well
  #
  # @return {Promise} with the loaded models
  _loadNext: ->
    # metas will indicate if some gamers are available
    {offset, limit, total} = @store.metadataFor 'gamer'
    offset = -10 unless offset?
    limit = 10 unless limit?
    total = 0 unless total?

    # depending on remaining models, ask for a new page of models
    return new Ember.RSVP.Promise((resolve) => Ember.run.later {}, resolve) unless total >= offset + limit

    # refresh flags to inhibit new loading and reflect remaining models
    @loading = true
    console.log ">>> load from #{offset + limit} to #{offset + limit} until #{total} (has more: #{@hasMore})"
    @store.find('gamer', offset: offset + limit, limit: limit)
      .then (models) =>
        # if request succeeded, refresh flags using last server data
        {offset, limit, total} = @store.metadataFor('gamer')
        @hasMore = total > offset + limit
        models.set 'ended', true unless @hasMore
        models
      .then (models) -> new Ember.RSVP.Promise (resolve) -> Ember.run.later (-> resolve models), 1000
      .catch (err) -> console.error 'failed to fetch gamers: ', err
      .finally => @loading = false
