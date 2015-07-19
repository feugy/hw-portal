gulp = require 'gulp'
plumber = require 'gulp-plumber'
coffee = require 'gulp-coffee'
stylus = require 'gulp-stylus'
stylint = require 'gulp-stylint'
lint = require 'gulp-coffeelint'
concat = require 'gulp-concat'
sourcemaps = require 'gulp-sourcemaps'
run = require 'run-sequence'
{log, beep} = require 'gulp-util'
rimraf = require 'rimraf'
htmlbars = require 'gulp-htmlbars'
declare = require 'gulp-declare'
replace = require 'gulp-replace'
webserver = require 'gulp-webserver'
gulpFilter = require 'gulp-filter'

paths =
  src: 'src/**/*.coffee'
  mainSource: 'app.js'
  tpl: 'src/templates/**/*.hbs'
  styles: 'src/styles/**/*.styl'
  mainStyles: 'app.styl'
  dest: 'build'

gulp.task 'clean', (done) ->
  rimraf paths.dest, done

buildStylus = ->
  gulp.src(paths.styles)
    .pipe(plumber())
    .pipe(stylint failOnError: true, config: '.stylintrc')
    .pipe(sourcemaps.init())
    .pipe(gulpFilter paths.mainStyles)
    .pipe(stylus())
    .pipe(sourcemaps.write '.')
    .pipe(plumber.stop())
    .pipe(gulp.dest paths.dest)

buildHtmlbars = ->
  gulp.src(paths.tpl)
    .pipe(plumber())
    .pipe(htmlbars
      templateCompiler: require './vendor/ember-template-compiler'
    )
    .pipe(replace /export default /, '')
    .pipe(declare
      namespace: 'Ember.TEMPLATES'
      noRedeclare: true
    )
    .pipe(concat 'templates.js')
    .pipe(plumber.stop())
    .pipe(gulp.dest paths.dest)

buildCoffee = ->
  gulp.src(paths.src)
    .pipe(plumber())
    .pipe(lint optFile: '.coffeelintrc')
    .pipe(lint.reporter())
    .pipe(lint.reporter 'fail')
    .pipe(sourcemaps.init())
    .pipe(coffee bare: true)
    .pipe(concat paths.mainSource)
    .pipe(sourcemaps.write '.')
    .pipe(plumber.stop())
    .pipe(gulp.dest paths.dest)

gulp.task 'build:coffee', buildCoffee
gulp.task 'build:htmlbars', buildHtmlbars
gulp.task 'build:stylus', buildStylus

# TODO tests with testem and coverage

gulp.task 'dev', ['build'], ->
  gulp.watch paths.tpl, ->
    buildHtmlbars().on('error', -> beep()).on 'end', -> log('htmlbars recompiled')
  gulp.watch paths.src, ->
    buildCoffee().on('error', -> beep()).on 'end', -> log('coffee recompiled')
  gulp.watch paths.styles, ->
    buildStylus().on('error', -> beep()).on 'end', -> log('stylus recompiled')
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
