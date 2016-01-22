import Translator from 'hw-portal/helpers/translate';
import AuthenticatedRoute from 'hw-portal/routes/authenticated';

const translate = new Translator().compute;

export default AuthenticatedRoute.extend({

  /**
   * Redirect to collection if challenge was not found.
   * Otherwise, update collection controller with selected model
   *
   * @param {Model} model - displayed delta, or null
   */
  afterModel(model) {
    /* jshint eqeqeq: false */
    if (model == null) {
      return this.transitionTo('challenges');
    }
    this.controllerFor('challenges').set('selected', model);
  },

  /**
   * Retrieve displayed model from inner Challenge cache.
   *
   * @param {Object} params - route parameters, containing displayed challenge id
   */
  model(params) {
    // Use peek that only looks into the cache to get challenge from collection
    // and not from server.
    return this.store.peekRecord('challenge', params.id);
  },

  setupController(controller, model) {
    this._super(controller, model);
    /* jshint eqeqeq: false */
    if (model != null) {
      // Because selected title and details are translated with a parametrized info,
      // we must get them manually in the controller
      controller.set('title', translate(`challenges.${model.id}.name`));
      controller.set('details', translate(`challenges.${model.id}.details`));
    }
  }
});
