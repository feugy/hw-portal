# Helper allows to format number within templates, with
# [i18n.js](https://github.com/fnando/i18n-js)
App.NumberHelper = Ember.Helper.extend

  compute: ([number]) -> I18n.localize 'number', number
