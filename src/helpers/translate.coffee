_ = require 'lodash'

# Helper allows to translate text within templates, with
# [i18n.js](https://github.com/fnando/i18n-js)
#
# Argument in the helper will be passed to `I18n.t()` for interpolation
# Special arguments are:
# - defaultValue: displayed values used if no translation found
# - defaults: hash used to found expected arguments that were not supplied
# - count: value used for pluralization
module.exports = App.TranslateHelper = Ember.Helper.extend

  compute: (params, args = {}) ->
    key = if _.isArray params then params[0] else params
    # Always set count because if the translated value supports pluralization
    # and we don't, '[Object object]'' will be displayed
    args.count = if 'count' of args then args.count else 1
    I18n.translate key, args
