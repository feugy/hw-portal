gulp = require 'gulp'
plumber = require 'gulp-plumber'
stylus = require 'gulp-stylus'
stylint = require 'gulp-stylint'
lint = require 'gulp-coffeelint'
sourcemaps = require 'gulp-sourcemaps'
run = require 'run-sequence'
{log, beep, colors} = require 'gulp-util'
rimraf = require 'rimraf'
htmlbars = require 'gulp-htmlbars'
declare = require 'gulp-declare'
replace = require 'gulp-replace'
webserver = require 'gulp-webserver'
gulpFilter = require 'gulp-filter'
concat = require 'gulp-concat'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
{assign} = require 'lodash'
{resolve, basename, dirname} = require 'path'
{parse} = require 'url'
{parse: parseQuery} = require 'querystring'

paths =
  src: 'src/**/*.coffee'
  srcEntry: 'src/app.coffee'
  tpl: 'src/templates/**/*.hbs'
  tplRoot: resolve 'src/templates'
  styles: 'src/styles/**/*.styl'
  stylesEntry: 'app.styl'
  dest: 'build'
  destEntry: 'app.js'

gulp.task 'clean', (done) ->
  rimraf paths.dest, done

handleError = (error) ->
  beep()
  log colors.red('Got error:\n'), error.toString()
  @emit('end')

buildStylus = ->
  gulp.src(paths.styles)
    .pipe(plumber(errorHandler: handleError))
    #.pipe(stylint failOnError: true, config: '.stylintrc')
    .pipe(sourcemaps.init())
    .pipe(gulpFilter paths.stylesEntry)
    .pipe(stylus())
    .pipe(sourcemaps.write '.')
    .pipe(gulp.dest paths.dest)

buildHtmlbars = ->
  gulp.src(paths.tpl)
    .pipe(plumber(errorHandler: handleError))
    .pipe(htmlbars
      templateCompiler: require './vendor/ember-template-compiler'
    )
    .pipe(replace /export default /, '')
    .pipe(declare
      namespace: 'Ember.TEMPLATES'
      noRedeclare: true
      processName: (name) ->
        # if template is in subfolder, keep subfolders in name, replacing \ per /
        path = dirname(name).replace paths.tplRoot, ''
        path = path.replace(/\\/g, '/').slice(1) + '/' if path
        path + basename name, '.hbs'
    )
    .pipe(concat 'templates.js')
    .pipe(gulp.dest paths.dest)

buildCoffee = ->
  bundler = browserify paths.srcEntry,
    debug: true
    extensions: ['.coffee']

  bundler.transform coffeeify
  bundler.bundle()
    .pipe(source paths.destEntry)
    .pipe(buffer())
    .pipe(sourcemaps.init loadMaps: true)
    .pipe(sourcemaps.write '.')
    .pipe(gulp.dest paths.dest)

gulp.task 'lint:coffee', ->
  gulp.src(paths.src)
    .pipe(lint optFile: '.coffeelintrc')
    .pipe(lint.reporter())
    .pipe(lint.reporter 'fail')

gulp.task 'build:coffee', ['lint:coffee'], buildCoffee
gulp.task 'build:htmlbars', buildHtmlbars
gulp.task 'build:stylus', buildStylus

# TODO tests with testem and coverage

gulp.task 'dev', ->
  gulp.watch paths.tpl, ['build:htmlbars']
  gulp.watch paths.src, ['build:coffee']
  gulp.watch paths.styles, ['build:stylus']
  gulp.src('.')
    .pipe(webserver
      # Custom middleware to append query params in file name for data fixtures
      middleware: (req, res, next) ->
        url = parse req.url
        return next() unless /^\/data/.test url.pathname
        args = ''
        query = parseQuery url.query
        for param in Object.keys(query).sort()
          args += "_#{param}_#{query[param]}"
        sep = url.pathname.lastIndexOf '.'
        req.url = url.pathname[0...sep] + args + url.pathname[sep..]
        req.method = 'GET'
        console.log "serve fixture #{req.url}"
        next()
      livereload:
        enable: true
        filter: (filename) ->
          not(filename.match /.map$/) and filename.match /(build|index.html$)/
      fallback: 'index.html'
    )

gulp.task 'default', ['dev']

gulp.task 'build', ->
  run 'clean', ['build:coffee', 'build:htmlbars', 'build:stylus']
