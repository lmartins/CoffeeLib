gulp       = require 'gulp'
gutil      = require 'gulp-util'
sass       = require 'gulp-sass'
prefix     = require 'gulp-autoprefixer'
coffee     = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
concat     = require 'gulp-concat'
plumber    = require 'gulp-plumber'
changed    = require 'gulp-changed'
uglify     = require 'gulp-uglify'
imagemin   = require 'gulp-imagemin'
livereload = require 'gulp-livereload'
lr         = require 'tiny-lr'
server     = lr()
notify     = require 'gulp-notify'

options =
  # HTML
  HTML_SOURCE     : "*.html",

  # SASS / CSS
  SASS_SOURCE     : "src/sass/**/*.scss",
  SASS_BUILD      : "build/css/",

  # JavaScript
  COFFEE_SOURCE   : "src/coffee/**/*.coffee",
  COFFEE_BUILD    : "build/js/",

  # Images
  IMAGE_SOURCE    : "src/images/**/*",
  IMAGE_BUILD     : "build/images",

  # Icons
  ICONS_SOURCE    : "src/sass/app/components/icons/svg/*.svg",
  ICONS_BUILD     : "build/css/fonts/",

  # Live reload
  LIVE_RELOAD_PORT: 35729


# Compile Our Sass
gulp.task 'sass', ->
  gulp.src options.SASS_SOURCE
    .pipe plumber()
    .pipe sass
      outputStyle: 'compressed'
    .on "error", notify.onError()
    .on "error", (err) ->
      console.log("Error:", err)
    .pipe prefix "last 1 version"
    .pipe gulp.dest options.SASS_BUILD
    .pipe livereload( server )


# Compile Our Coffee
gulp.task 'coffee', ->
  gulp.src options.COFFEE_SOURCE
    .pipe changed options.COFFEE_SOURCE
    .pipe coffee
      bare: true
      sourceMap: true
    .on 'error', gutil.log
    .pipe gulp.dest( options.COFFEE_BUILD )
    .pipe livereload( server )


gulp.task 'lint', ->
  gulp.src options.COFFEE_SOURCE
    .pipe coffeelint()
    .pipe coffeelint.reporter()


gulp.task 'html', ->
  gulp.src options.HTML_SOURCE
    .pipe livereload( server )


gulp.task 'bowerCopy', ->
  gulp.src [
    'src/vendor/jquery/dist/jquery.min.js'
    ]
    .pipe uglify()
    .pipe gulp.dest( "build/vendor/" )

gulp.task 'bowerMerge', ->
  gulp.src [
    'src/vendor/jquery-easing/jquery.easing.js'
    ]
    .pipe concat "bundle.js"
    .pipe uglify()
    .pipe gulp.dest "build/vendor/"


gulp.task 'images', ->
  gulp.src IMAGE_SRC
    .pipe imagemin()
    .pipe gulp.dest( IMAGE_BUILD )


gulp.task 'default', ->
  gulp.watch options.SASS_SOURCE, ['sass']
  gulp.watch options.COFFEE_SOURCE, ['coffee','lint']

gulp.task 'bower', [ 'bowerCopy', 'bowerMerge' ]

gulp.task 'watch', ->
  server.listen options.LIVE_RELOAD_PORT, (err) ->
    if (err) then console.log(err)

    gulp.watch options.HTML_SOURCE, ['html']
    gulp.watch options.COFFEE_SOURCE, ['coffee','lint']
    gulp.watch options.IMAGE_SOURCE, ['images']
    gulp.watch options.SASS_SOURCE, ['sass']
