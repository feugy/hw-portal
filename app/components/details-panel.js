import Ember from 'ember';

export default Ember.Component.extend({

  classNames: 'off-canvas-wrap l-details-panel',

  // Bound falsy/truthy value used to open or close details
  open: false,

  // Foundation's off-canvas component
  attributeBindings: ['offCanvas:data-offcanvas'],
  offCanvas: true,

  // For multiple yields
  // @see https://coderwall.com/p/qkk2zq/components-with-structured-markup-in-ember-js-v1-10
  details: {isDetails: true},
  title: {isTitle: true},

  init(...args) {
    this._super(...args);
    // Private flag used to avoid closing already opened details
    this.isOpen = false;
  },

  actions: {
    // On close button, force details to hide
    close() {
      this.set('open', null);
      this.toggle();
    }
  },

  // Effectively apply isOpen value to Fondation's off-canvas component
  toggle() {
    const wasOpen = this.isOpen;
    this.isOpen = this.get('open');
    if (wasOpen !== this.isOpen) {
      this.$('').foundation('offcanvas', this.isOpen ? 'show' : 'hide', 'move-left');
    }
  },

  // When open value is externally modified, toggle visibility (only if open is falsy)
  updateState: Ember.on('init', Ember.observer('open', function() {
    Ember.run.scheduleOnce('afterRender', this, this.toggle);
  })),
});
