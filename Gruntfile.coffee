module.exports = (grunt) ->
  grunt.initConfig
    connect:
      app:
        options:
          livereload: true,
          base: "public/",
          port: 9000
    copy:
      assets:
        expand: true,
        cwd: 'assets/',
        src: [ '**/*', '!**/*.less' ],
        dest: 'public/assets/'
      html:
        expand: true,
        cwd: 'app/',
        src: '**/*.html',
        dest: 'public/app/'
      index:
        src: 'index.html',
        dest: 'public/index.html'
    less:
      compile:
        options:
          compress: false
        files: [
          {
            expand: true,
            cwd: 'assets/css/',
            src: '**/*.less',
            dest: 'public/assets/css/',
            ext: '.css'
          }
        ]
    coffee:
      compile:
        files: [
          {
            expand: true,
            cwd: 'app/',
            src: '**/*.coffee',
            dest: 'public/app/',
            ext: '.js'
          }
        ]
    watch:
      index:
        files: 'index.html'
        tasks: 'copy:index'
      html:
        files: 'app/**/*.html'
        tasks: 'copy:html'
      less:
        files: 'assets/css/**/*.less'
        tasks: 'less:compile'
      coffee:
        files: 'app/**/*.coffee'
        tasks: 'coffee:compile'
  
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'

  grunt.registerTask 'build', ['less', 'coffee', 'copy']
  grunt.registerTask 'serve', ['build', 'connect', 'watch']
  grunt.registerTask 'default', 'build'