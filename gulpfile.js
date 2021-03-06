var gulp      = require('gulp');
var uglify    = require('gulp-uglify');
var compass   = require('gulp-compass');
var minifyCss = require('gulp-clean-css');
var concat    = require('gulp-concat')
var path      = require('path');
var es        = require('event-stream');

gulp.task('default', ['compress-js', 'compress-css', 'put-templates']);

gulp.task('watch', ['default', 'do_watch']);

gulp.task('do_watch', function() {
  gulp.watch('web/static/**/*.js', function() {
    gulp.run('compress-js');
  });
  gulp.watch('web/static/scss/*.scss', function() {
    gulp.run('compress-css');
  });
  gulp.watch('web/static/js/templates/**/*.html', function() {
    gulp.run('put-templates');
  });
})

gulp.task('put-templates', function() {
  return gulp.src(['web/static/js/templates/**/*.html'])
    .pipe(gulp.dest('priv/static/js/templates'))
});

gulp.task('compress-js', function() {
  return gulp.src(['web/static/**/*.js'])
    .pipe(uglify())
    .pipe(concat('app.js'))
    .pipe(gulp.dest('priv/static/js'))
});

gulp.task('compress-css', function() {
  var vendorFiles = gulp.src('web/static/vendor/**/*.css')
  var appFiles = gulp.src('web/static/scss/*.scss')
    .pipe(compass({
      project: path.join(__dirname, 'web/static'),
      css: 'css',
      sass: 'scss'
    }))
  return es.concat(vendorFiles, appFiles)
    .pipe(concat('style.css'))
    .pipe(minifyCss())
    .pipe(gulp.dest('priv/static/css'));
});
