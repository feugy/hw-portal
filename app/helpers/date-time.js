import Ember from 'ember';

/**
 * Helper allows to format date within templates, with
 * [i18n.js](https://github.com/fnando/i18n-js)
 *
 * Acceptable arguments are:
 * - format {String = default}: to set used format
 * (as defined in translation file under date.formats or time.formats)
 * - time {Boolean = false}: to use time format instead of date format
 */
export default Ember.Helper.extend({

  compute(params, {format, time} = {}) {
    let date = _.isArray(params) ? params[0] : params;
    if (!_.isDate(date)) {
      date = new Date(date);
    }
    if (!format) {
      format = 'default';
    }
    if (!time) {
      time = false;
    }
    return I18n.localize(`${time ? 'time' : 'date'}.formats.${format}`, date);
  }
});
