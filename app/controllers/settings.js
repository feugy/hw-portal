import Ember from 'ember';

export default Ember.Controller.extend({

  // Distinguish between account coming from external providers (no password)
  isExternal: false,

  // Save result for main account
  mainSuccessfullySaved: null,

  // Secondary account enriched with bound success status
  secondaries: [],

  // When model is set, updates secondary enriched array.
  updateSecondary: Ember.on('init', Ember.observer('model.accounts.secondary', function() {
    if (!this.get('model.accounts.secondary')) {
      return this.set('secondaries', []);
    }
    this.set('secondaries', this.model.accounts.secondary.map(secondary =>
      Ember.Object.create({model: secondary, successfullySaved: null})
    ));
  })),

  // On module update, reset the isExternal status
  modelUpdated: Ember.on('init', Ember.observer('model', function() {
    this.set('mainSuccessfullySaved', null);
    // Only internal users can edit their password and email
    this.set('isExternal', 'huby-woky' !== this.get('model.accounts.main.provider'));
  })),

  actions: {

    /**
     * Triggered when main account needs to be saved
     * @param {Object} edited - new values for pseudo, email, password...
     */
    saveMainAccount(edited) {
      console.log('saved main', edited);
      Ember.$.post('/data/settings.json', edited, () => {
        this.set('mainSuccessfullySaved', true);
        // TODO update model from what returned server
      }, 'json').
      fail((xhr, status, err) => {
        this.set('mainSuccessfullySaved', err || status);
      });
    },

    /**
     * Triggered when secondary account needs to be saved
     * @param {Object} edited - new values for pseudo, email, password...
     * @param {Object} model - original secondary accounts values
     */
    saveSecondaryAccount(edited, model) {
      console.log('saved secondary', model.id);
      const secondary = this.get('secondaries').find(secondary => secondary.model === model);
      Ember.$.post('/data/settings.json', edited, () => {
        secondary.set('successfullySaved', true);
        // TODO update model from what returned server
      }, 'json').
      fail((xhr, status, err) => {
        secondary.set('successfullySaved', err || status);
      });
    }
  }
});
