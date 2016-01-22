import Ember from 'ember';
import Translator from 'hw-portal/helpers/translate';

const translate = new Translator().compute;

export default Ember.Controller.extend({

  // Shortcuts to Collection parent controller attributes
  //needs: 'collection',
  collection: Ember.inject.controller(),
  placeholder: Ember.computed.alias('collection.placeholder'),
  losses: Ember.computed.alias('collection.model.losses'),

  // Flag indicating that player got a delta of this kind in the past
  isLost: false,

  // When Collection controller's placeholder is set, updates name and details
  updatePlaceholder: Ember.on('init', Ember.observer('placeholder', function() {
    const placeholderKind = this.get('placeholder.kind');
    this.set('title', translate(`deltas.${placeholderKind}.name`));
    this.set('details', translate(`deltas.${placeholderKind}.details`));
  })),

  // When Collection controller model is available, update isLost flag
  updateLost: Ember.on('init', Ember.observer('losses', 'placeholder', function() {
    const placeholderKind = this.get('placeholder.kind');
    /* jshint eqeqeq: false */
    this.set('isLost', this.get('losses').find(kind => kind === placeholderKind) != null);
  }))
});
