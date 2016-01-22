import Ember from 'ember';

/**
 * Helper allows to format number within templates, with
 * [i18n.js](https://github.com/fnando/i18n-js)
 */
export default Ember.Helper.extend({
  compute([num]) {
    return I18n.localize('number', num);
  }
});
