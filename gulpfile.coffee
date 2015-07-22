gulp = require 'gulp'
plumber = require 'gulp-plumber'
coffee = require 'gulp-coffee'
stylus = require 'gulp-stylus'
stylint = require 'gulp-stylint'
lint = require 'gulp-coffeelint'
concat = require 'gulp-concat'
sourcemaps = require 'gulp-sourcemaps'
run = require 'run-sequence'
{log, beep, colors} = require 'gulp-util'
rimraf = require 'rimraf'
htmlbars = require 'gulp-htmlbars'
declare = require 'gulp-declare'
replace = require 'gulp-replace'
webserver = require 'gulp-webserver'
gulpFilter = require 'gulp-filter'
{resolve, basename, dirname} = require 'path'

paths =
  src: 'src/**/*.coffee'
  mainSource: 'app.js'
  tpl: 'src/templates/**/*.hbs'
  tplRoot: resolve 'src/templates'
  styles: 'src/styles/**/*.styl'
  mainStyles: 'app.styl'
  dest: 'build'


gulp.task 'clean', (done) ->
  rimraf paths.dest, done

handleError = (error) ->
  beep()
  log colors.red('Got error:\n'), error.toString()
  @emit('end')

buildStylus = ->
  gulp.src(paths.styles)
    .pipe(plumber(errorHandler: handleError))
    .pipe(stylint failOnError: true, config: '.stylintrc')
    .pipe(sourcemaps.init())
    .pipe(gulpFilter paths.mainStyles)
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
  gulp.src(paths.src)
    .pipe(plumber(errorHandler: handleError))
    .pipe(lint optFile: '.coffeelintrc')
    .pipe(lint.reporter())
    .pipe(lint.reporter 'fail')
    .pipe(sourcemaps.init())
    .pipe(coffee bare: true)
    .pipe(concat paths.mainSource)
    .pipe(sourcemaps.write '.')
    .pipe(gulp.dest paths.dest)

gulp.task 'build:coffee', buildCoffee
gulp.task 'build:htmlbars', buildHtmlbars
gulp.task 'build:stylus', buildStylus

# TODO tests with testem and coverage

gulp.task 'dev', ->
  gulp.watch paths.tpl, ['build:htmlbars']
  gulp.watch paths.src, ['build:coffee']
  gulp.watch paths.styles, ['build:stylus']
  gulp.src('.')
    .pipe(webserver
      livereload:
        enable: true
        filter: (filename) ->
          not(filename.match /.map$/) and filename.match /(build|index.html$)/
      fallback: 'index.html'
    )

gulp.task 'default', ['dev']

gulp.task 'build', ->
  run 'clean', ['build:coffee', 'build:htmlbars', 'build:stylus']
