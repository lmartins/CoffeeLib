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

  coffee: {
    src: ["src/coffee/**/*.coffee"],
    build: "build/css/"
  },

  // HTML
  HTML_SOURCE     : ['*.html', '01patterns/*.html'],

  // SASS / CSS
  sass: {
    src: "src/sass/**/*.scss",
    build: "build/css/"
  },

  // Images
  IMAGE_SOURCE    : "src/images/**/*",
  IMAGE_BUILD     : "build/images",

  // Icons
  ICONS_SOURCE    : "src/sass/app/components/icons/svg/*.svg",
  ICONS_BUILD     : "build/css/fonts/",

  // Live reload
  LIVE_RELOAD_PORT: 35729
}

var server;

gulp.task('livereload', function() {
  server = livereload();
});

// Compile Our Sass
gulp.task('sass', function() {
  gulp.src( options.sass.src )
    .pipe(plumber())
    .pipe(sass({
      outputStyle: 'compressed'
      }))
    .on("error", notify.onError())
    .on("error", function (err) {
      console.log("Error:", err);
    })
    .pipe(prefix( "last 1 version" ))
    .pipe(gulp.dest( options.sass.build ))
    .pipe(livereload());
});

// Compile Our Coffee
gulp.task('coffee', function () {
  gulp.src( options.coffee.src )
    .pipe(changed( options.coffee.build , {extension: '.js'} ))
    .pipe(coffee({
      bare: true,
      sourceMap: true
      })
    .on('error', gutil.log))
    .pipe(gulp.dest( options.coffee.build ))
    .pipe(livereload());
});

gulp.task('lint', function(){
  gulp.src( options.coffee.src )
    .pipe(coffeelint())
    .pipe(coffeelint.reporter());
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

gulp.watch(options.HTML_SOURCE, ['html']);
  gulp.watch( options.coffee.src , ['coffee', 'lint']);
  // gulp.watch(options.IMAGE_SOURCE, ['images']);
  gulp.watch( options.sass.src , ['sass']  );

});
