import Ember from 'ember';

export default Ember.Controller.extend({

  // Currently selected challenge, for right panel displayal
  selected: null,

  /**
   * When the selected challenge is reseted to null, return back to challenges route
   * The transition to details route must only be performed in the select action
   * Do not performs on init, because we must wait for Challenges.Details route
   * to set this value
   */
  updateSelected: Ember.observer('selected', function() {
    if (!this.selected) {
      this.transitionToRoute('challenges');
    }
  }),

  actions: {

    /**
     * Set currently selected challenge: change if different from previous,
     * or reinit to null if toggleing the same challenge.
     * Transition to the selected challenge details
     *
     * @param {Object} challenge - newly selected challenge.
     */
    select(challenge) {
      const selected = this.get('selected');
      if (challenge === selected || !challenge) {
        this.set('selected', null);
      } else {
        this.set('selected', challenge);
        if (challenge) {
          this.transitionToRoute('challenges.details', challenge.id);
        }
      }
    }
  }

});
