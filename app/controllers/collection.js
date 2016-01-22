import Ember from 'ember';

export default Ember.Controller.extend({

  // Selected deltas (an array), currently displayed in details
  selected: null,

  // Selected kind placeholder, set by CollectionDetails controller
  selectedKind: null,

  // Selected placeholder
  placeholder: null,

  /**
   * When the selected delta is reseted to null, return back to collection route
   * The transition to details route must only be performed in the select action
   * Do not performs on init, because we must wait for Collection.Details route
   * to set this value
   */
  updateSelected: Ember.observer('selected', function() {
    if (!this.selected) {
      this.set('placeholder', null);
      this.transitionToRoute('collection');
    }
  }),

  /**
   * When model is available, set the selected placeholder using selectedKind set
   * by Collection.Details route. Can't be done on init.
   */
  updatePlaceholder: Ember.observer('model', function() {
    if (this.selectedKind) {
      for (let scene of this.get('model.scenes')) {
        const placeholder = scene.get('placeholders').find(placeholder => placeholder.kind === this.selectedKind);
        if (placeholder) {
          this.set('placeholder', placeholder);
          break;
        }
      }
    }
  }),

  actions: {

    /**
     * On delta placeholder selection, navigate to relevant detailed view
     * Navigate to full colleciton if re-selecting the previous delta placeholder
     *
     * @param {Object} placeholder - delta placeholder selected
     */
    select(placeholder) {
      const selected = this.get('placeholder');
      if (placeholder === selected) {
        this.set('selected', null);
        // In this case, selected placeholder will be reset to null, and navigation will occur
      } else {
        this.set('placeholder', placeholder);
        if (placeholder) {
          this.transitionToRoute('collection.details', placeholder.kind);
        }
      }
    }
  }
});
