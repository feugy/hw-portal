import AuthenticatedRoute from 'hw-portal/routes/authenticated';

export default AuthenticatedRoute.extend({

  /**
   * Update collection controller with selected models, that may not exists (empty array)
   *
   * @param {Model} model - displayed delta, or null
   */
  afterModel(model) {
    // Update collection controller to set displayed models
    this.controllerFor('collection').set('selected', model);
  },

  /**
   * Retrieve available delta (in local cache) of a given kind
   *
   * @param {Object} params - route parameters, containing displayed delta kind
   */
  model(params) {
    // Use filter that only looks into the cache to get delta from collection
    // and not from server.
    const deltas = this.store.peekAll('delta').filter(delta => params.kind === delta.get('kind'));
    // Set collection's selected kind to allow placeholder detection
    this.controllerFor('collection').set('selectedKind', params.kind);
    return deltas;
  }
});
