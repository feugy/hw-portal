/*jshint node:true*/

// To use it create some files under `mocks/`
// e.g. `server/mocks/ember-hamsters.js`
//
// module.exports = function(app) {
//   app.get('/ember-hamsters', function(req, res) {
//     res.send('hello');
//   });
// };

module.exports = function(app) {
  // Log proxy requests
  var morgan  = require('morgan');
  app.use(morgan('dev'));

  app.get('/data/*', function(req, res, next) {
    if (Object.keys(req.query).length === 0) {
      return next();
    }
    var args = '';
    Object.keys(req.query).sort().forEach(function(param) {
      args += '_' + param + '_' + req.query[param];
    });
    var sep = req.path.lastIndexOf('.');
    res.redirect(req.path.slice(0, sep) + args + req.path.slice(sep));
  });

};
