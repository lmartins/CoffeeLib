'use strict';

var gulp = require('gulp'),
    gutil      = require('gulp-util'),
    sass       = require('gulp-sass'),
    prefix     = require('gulp-autoprefixer'),
    coffee     = require('gulp-coffee'),
    coffeelint = require('gulp-coffeelint'),
    concat     = require('gulp-concat'),
    plumber    = require('gulp-plumber'),
    changed    = require('gulp-changed'),
    uglify     = require('gulp-uglify'),
    imagemin   = require('gulp-imagemin'),

    livereload = require('gulp-livereload'),
    notify     = require('gulp-notify');

var options = {
  // HTML
  HTML_SOURCE     : ['*.html', '01patterns/*.html'],

  // SASS / CSS
  SASS_SOURCE     : "src/sass/**/*.scss",
  SASS_BUILD      : "build/css/",

  // JavaScript
  COFFEE_SOURCE   : "src/coffee/**/*.coffee",
  COFFEE_BUILD    : "build/js/",

  // Images
  IMAGE_SOURCE    : "src/images/**/*",
  IMAGE_BUILD     : "build/images",

  // Icons
  ICONS_SOURCE    : "src/sass/app/components/icons/svg/*.svg",
  ICONS_BUILD     : "build/css/fonts/",

  // Live reload
  LIVE_RELOAD_PORT: 35729
}


// Compile Our Sass
gulp.task('sass', function() {
  gulp.src(options.SASS_SOURCE)
    .pipe(plumber())
    .pipe(sass({
      outputStyle: 'compressed'
      }))
    .on("error", notify.onError())
    .on("error", function (err) {
      console.log("Error:", err);
    })
    .pipe(prefix( "last 1 version" ))
    .pipe(gulp.dest(options.SASS_BUILD))
    .pipe(livereload());
});

// Compile Our Coffee
gulp.task('coffee', function () {
  gulp.src( options.COFFEE_SOURCE )
    .pipe(changed( options.COFFEE_BUILD, {extension: '.js'} ))
    .pipe(coffee({
      bare: true,
      sourceMap: true
      })
    .on('error', gutil.log))
    .pipe(gulp.dest( options.COFFEE_BUILD ))
    .pipe(livereload());
});


gulp.task('lint', function () {
  gulp.src( options.COFFEE_SOURCE )
    .pipe(changed( options.COFFEE_BUILD ))
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())
});


gulp.task('html', function () {
  gulp.src( options.HTML_SOURCE )
    .pipe(livereload());
});


gulp.task ('bowerCopy', function () {
  gulp.src ([
      'src/vendor/jquery/dist/jquery.min.js'
      ])
    .pipe (uglify())
    .pipe (gulp.dest( "build/vendor/" ))
});

gulp.task ('bowerMerge', function () {
  gulp.src ([
      'src/vendor/jquery-easing/jquery.easing.js'
    ])
    .pipe (concat ("bundle.js"))
    .pipe (uglify())
    .pipe (gulp.dest ("build/vendor/"))
});


gulp.task('default', function(){
  gulp.watch(options.SASS_SOURCE, ['sass']);
  gulp.watch(options.COFFEE_SOURCE, ['coffee','lint']);
});

gulp.task('bower', [ 'bowerCopy', 'bowerMerge' ]);

gulp.task('watch', function () {
  // server = livereload();
  gulp.watch(options.HTML_SOURCE, ['html']);
  gulp.watch(options.COFFEE_SOURCE, ['coffee', 'lint']);
  // gulp.watch(options.IMAGE_SOURCE, ['images']);
  gulp.watch(options.SASS_SOURCE, ['sass']  );

  // server.listen( options.LIVE_RELOAD_PORT , function (err) {
  //   if (err) return console.log(err);
  //   gulp.watch(options.HTML_SOURCE, ['html']);
  //   gulp.watch(options.COFFEE_SOURCE, ['coffee','lint']);
  //   // gulp.watch(options.IMAGE_SOURCE, ['images']);
  //   gulp.watch(options.SASS_SOURCE, ['sass']  );
  // });
});
