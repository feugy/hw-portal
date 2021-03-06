/*jshint node:true*/
/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  var app = new EmberApp(defaults, {
  });


  app.import('bower_components/lodash/lodash.js');
  app.import('bower_components/d3/d3.js');
  app.import('bower_components/i18n/index.js', {
    exports: {
      'I18n': 'i18n'
    }
  });
  app.import('vendor/rounding.js');

  app.import('bower_components/foundation/css/normalize.css');
  app.import('bower_components/foundation/css/foundation.css');
  app.import('vendor/foundation-icons.css');

  return app.toTree();
};
