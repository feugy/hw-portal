# Helper allows to format number with currency within templates, with
# [i18n.js](https://github.com/fnando/i18n-js)
module.exports = App.CurrencyHelper = Ember.Helper.extend

  compute: ([number]) -> I18n.localize 'currency', number
