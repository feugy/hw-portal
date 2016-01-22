import Ember from 'ember';

export default Ember.Route.extend({

  // Initialize flags to allow first loading
  hasMore: true,
  loading: false,
  // Keep last query parameters for next loading
  params: null,

  queryParams: {
    // Sort query parameter change will trigger a full refresh
    sort: {refreshModel: true}
  },

  // tries to restore session if available
  beforeModel() {
    return this.container.lookup('service:session-restore').restore();
  },

  model(params) {
    if (!_.isEqual(this.params, params)) {
      // If query parameters has changed, then reload everything
      this.params = params;
      const ctrl = this.get('controller');
      if (ctrl) {
        ctrl.set('scrollPosition', 0);
        ctrl.set('model', []);
      }
      return this._loadNext(true);
    }

    return this.get('controller.model') || this._loadNext();
  },

  actions: {
    /**
     * Action invoked when a new page of models need to be loaded
     * Does nothing if all models were already loaded
     *
     * @return {Promise|null} with all availble models if a new page was loaded
     */
    load() {
      if(!this.hasMore || this.loading) {
        return;
      }
      return this._loadNext().then(models => {
        if (!models) {
          return;
        }
        // We cannot return just the loaded models, but instead we must enrich the
        // current controller model array.
        // It ensure template refreshing while keeping already fetched models
        // updates the controller's model ended flag because we don't return the loaded models
        if (!this.hasMore) {
          this.set('controller.model.ended', true);
        }
        this.set('controller.model.meta', models.get('meta'));
        this.get('controller.model').pushObjects(models.get('content'));
      });
    }
  },

  /**
   * @private
   * Loads the next model page on server.
   * The page will be loaded only if some data are available, based on previous server metadatas
   * The `loading` and `hasMore` flags are updated, and `ended` attribute on model as well
   *
   * @param {Boolean} reset - true when metadata are to be ignored, resulting in loading from begining
   * @return {Promise} with the loaded models
   */
  _loadNext(reset = false) {
    // Metas will indicate if some gamers are available
    const meta = reset ? {} : this.get('controller.model.meta') || {};
    /* jshint eqeqeq: false */
    let offset = meta.offset == null ? -10 : meta.offset;
    /* jshint eqeqeq: false */
    let limit = meta.limit == null ? 10 : meta.limit;
    /* jshint eqeqeq: false */
    let total = meta.total == null ? 0 : meta.total;

    // Depending on remaining models, ask for a new page of models
    if (total < offset + limit) {
      return new Ember.RSVP.Promise(resolve => Ember.run.later({}, resolve));
    }

    // Refresh flags to inhibit new loading and reflect remaining models
    this.loading = true;

    return this.store.query('gamer', {offset: offset + limit, limit: limit, sort: this.params.sort}).
      then(models => {
        // If request succeeded, refresh flags using last server data
        const meta = models.get('meta');

        offset = meta.offset;
        limit = meta.limit;
        total = meta.total;
        this.hasMore = total > offset + limit;
        if(this.hasMore) {
          models.set('ended', true);
        }
        return models;
      }).
      then(models => new Ember.RSVP.Promise(resolve =>
        // TODO Delay to simulate server latency
        Ember.run.later(() => {
          resolve(models);
        }, 500)
      )).
      catch(err => console.error('failed to fetch gamers: ', err)).
      finally(() => this.loading = false);
  }
});
