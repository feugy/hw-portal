import Ember from 'ember';

// Freely inspired from https://github.com/hhff/ember-infinity
export default Ember.Component.extend({

  classNames: 'infinity-scroll',
  classNameBindings: 'model.ended',

  model: null,

  // Actions names
  loadMoreAction: 'load',

  // Unique id for event binding, and debounce for more reactive UI
  guid: null,
  eventDebounce: 10,

  // Provide here a selector to the scrollable DOM node. Whole window by default
  scrollable: null,
  node: null,

  position: 0,

  actions: {
    scrollToTop() {
      if (this.get('node')) {
        this.get('node').animate({scrollTop: 0});
      }
    }
  },

  // On component insertion, get the scrollable node and bind event handlers
  didInsertElement(...args) {
    this._super(...args);
    this._setupScrollable();
    // reset initial position if specified
    this.get('node').scrollTop(this.get('position'));
    this.set('guid', Ember.guidFor(this));

    const bindEvent = (eventName) =>
      this.get('node').on(`${eventName}.${this.guid}`, () =>
        Ember.run.debounce(this, this._checkIfInView, this.eventDebounce));

    bindEvent('scroll');
    bindEvent('resize');
    this._checkIfInView();
  },

  // On component destruction, unbind event handlers
  willDestroyElement(...args) {
    this._super(...args);

    const unbindEvent = (eventName) => this.get('node').off(`${eventName}.${this.guid}`);

    unbindEvent('scroll');
    unbindEvent('resize');
  },

  // Get the scrollable node dimension and trigger loading action if scroll reach the bottom
  _checkIfInView() {
    const offset = this.$().offset().top;
    const node = this.get('node');
    const bottom = node.height() + node.scrollTop();
    this.set('position', node.scrollTop());
    // Trigger loading action
    if (offset < bottom) {
      this.sendAction('loadMoreAction');
    }
  },

  /**
   * Get the scrollable element from DOM with a given selector.
   * Use window if no scrollable selector provided.
   *
   * @throws {Error} if a selector is provided does not aim at exactly one element
   */
  _setupScrollable() {
    const scrollable = this.get('scrollable');
    // Use the whole window if no scrollable defined
    if (Ember.typeOf(scrollable) !== 'string') {
      return this.set('node', Ember.$(window));
    }

    const items = Ember.$(scrollable);
    if (items.length > 1) {
      throw new Error(`Multiple scrollable elements found for: ${scrollable}`);
    }
    if (items.length !== 1) {
      throw new Error(`No scrollable element found for: ${scrollable}`);
    }
    this.set('node', items.eq(0));
  },

  // Refresh the component state when model changed
  infinityModelPushed: Ember.observer('model.length', function() {
    Ember.run.scheduleOnce('afterRender', this, this._checkIfInView);
  })
});
