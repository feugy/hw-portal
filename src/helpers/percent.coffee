# Helper allows to format number with currency within templates, with
# [i18n.js](https://github.com/fnando/i18n-js)
App.PercentHelper = Ember.Helper.extend

  compute: ([number]) -> I18n.localize 'percentage', number
