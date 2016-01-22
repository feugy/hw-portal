import Ember from 'ember';

/**
 * Helper allows to translate text within templates, with
 * [i18n.js](https://github.com/fnando/i18n-js)
 *
 * Argument in the helper will be passed to `I18n.t()` for interpolation
 * Special arguments are:
 * - defaultValue: displayed values used if no translation found
 * - defaults: hash used to found expected arguments that were not supplied
 * - fieldSep: set to true to add the default field separator for this locale
 * - count: value used for pluralization
 */
export default Ember.Helper.extend({

  compute(params, args = {}) {
    const key = _.isArray(params) ? params[0] : params;
    // Always set count because if the translated value supports pluralization
    // and we don't, '[Object object]'' will be displayed
    args.count = 'count' in args ? args.count : 1;
    let value = I18n.translate(key, args);
    if (args.fieldSep) {
      value = value + I18n.translate('fieldSep');
    }
    return value;
  }

});
