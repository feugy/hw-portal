import Ember from 'ember';

export default Ember.Component.extend({

  tagName: 'li',
  classNames: 'challenge-card',
  model: null,
  selected: null,

  init(...args) {
    this._super(...args);
    this.set('overlay', ('right: 100%;').htmlSafe());
  },

  actions: {
    select() {
      this.sendAction('action', this.model);
    }
  },

  /**
   * Once mode is available, compute toooltip content and trigger progress animation
   */
  initAfterModel: Ember.on('init', Ember.observer('model', function() {
    Ember.run.scheduleOnce('afterRender', this, () =>
      Ember.run.later(() => {
        this.set('overlay', (`right: ${100 - (this.model ? this.model.get('done') : 0)}%;`).htmlSafe());
      }, 100)
    );
  })),

  /**
   * When selected model or model itself is modified, update the selected attribute
   */
  updateSelected: Ember.on('init', Ember.observer('model', 'selected', function() {
    Ember.run.scheduleOnce('afterRender', this, () => this.$('').toggleClass('selected', this.model === this.selected));
  }))

});
