import Ember from 'ember';
import Translator from 'hw-portal/helpers/translate';

const translate = new Translator().compute;

/**
 * Sends two different actions:
 * - default one when save button is pressed, with edited value and original model
 * - 'updateFromProvider' with original model when external provider data must be retrieved
 */
export default Ember.Component.extend({

  tagName: 'form',
  classNames: 'account',

  // Distinguish between account coming from external providers, that has no password (set by controller)
  isExternal: false,
  // Edidted account (set by controller)
  model: null,
  /**
   * Set to true if successfully saved, to an object in case of error,
   * or to null if no save operation triggered (set by controller)
   */
  successfullySaved: null,

  // On component initialization, set locale dependent fields
  init(...args) {
    this._super(...args);
    this.passwordType = 'password';
    this.passwordPlaceholder = translate('plh.passwordEdition');
  },

  // When model is updated, set edited values to reflect it
  modelUpdated: Ember.on('init', Ember.observer('model', function() {
    Ember.run.once(this, () => {
      if(!this.model) {
        return;
      }
      this.set('edited', {
        pseudo: this.get('model.pseudo'),
        email: this.get('model.email'),
        password: ''
      });
    });
  })),

  // Updates the canSave flag everytime an edited value changes
  editedUpdate: Ember.on('init', Ember.observer('edited.pseudo', 'edited.email', 'edited.password', function() {
    Ember.run.once(this, () => {
      if(this.model && this.edited) {
        this.set('canSave', this.edited.pseudo !== this.get('model.pseudo') ||
          this.edited.email !== this.get('model.email') ||
          this.edited.password !== '');
      } else {
        this.set('canSave', false);
      }
    });
  })),

  // Updates saveResult and saveResultStyles to reflect the current status.
  statusUpdated: Ember.on('init', Ember.observer('successfullySaved', function() {
    Ember.run.once(this, () => {
      // Bu default, hides alert-box
      let result = null;
      this.set('saveResultStyle', 'success');

      /* jshint eqeqeq: false */
      if (this.successfullySaved != null) {
        // if truthy, display success message
        if (this.successfullySaved) {
          result = translate('msg.accountSaved');
        } else {
          // Or consider as an error object
          this.set('saveResultStyle', 'alert');
          result = translate('err.accountNotSaved', {err: this.successfullySaved});
        }
      this.set('saveResult', result);
      this.modelUpdated();
      }
    });
  })),

  actions: {
    // When password field gains focus, its content becames readable
    editPassword() {
      this.set('passwordType', 'text');
    },

    // When password field looses focus, it's obfuscated
    stopEditPassword() {
      this.set('passwordType', 'password');
    },

    // Retrieve email address from external provider if needed
    updateFromProvider() {
      if (!this.isExternal) {
        return;
      }
      // trigger update on server
      this.sendAction('updateFromProvider', this.model);
    },

    // Closes  alert-box displaying save result
    closeSaveResult() {
      this.set('saveResult', null);
    },

    // Save edited values to server
    save() {
      if (!this.canSave) {
        return;
      }
      this.send('closeSaveResult');
      this.sendAction('action', this.edited, this.model);
    }
  }
});
