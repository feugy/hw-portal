_ = require 'lodash'

# Helper allows to format date within templates, with
# [i18n.js](https://github.com/fnando/i18n-js)
#
# Acceptable arguments are:
# - format {String = default}: to set used format
# (as defined in translation file under date.formats or time.formats)
# - time {Boolean = false}: to use time format instead of date format
module.exports = App.DateTimeHelper = Ember.Helper.extend

  compute: (params, {format, time} = {}) ->
    date = if _.isArray params then params[0] else params
    date = new Date date unless _.isDate date
    format = 'default' unless format?
    time = false unless time?
    I18n.localize "#{if time then 'time' else 'date'}.formats.#{format}", date
