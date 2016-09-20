module.exports = (grunt) ->
  grunt.initConfig
    connect:
      app:
        options:
          livereload: true,
          base: "public/",
          port: 9000
    copy:
      resources:
        expand: true,
        cwd: 'src/resources',
        src: '**/*',
        dest: 'public/'
      src:
        expand: true,
        cwd: 'src/',
        src: '**/*.html',
        dest: 'public/'
    less:
      src:
        options:
          compress: false
        files: [
          {
            expand: true,
            cwd: 'src/less',
            src: '**/*.less',
            dest: 'public/css/',
            ext: '.css'
          }
        ]
    coffee:
      src:
        files: [
          {
            expand: true,
            cwd: 'src/coffee',
            src: '**/*.coffee',
            dest: 'public/js/',
            ext: '.js'
          }
        ]
    watch:
      html:
        files: 'src/**/*.html'
        tasks: 'copy:src'
      less:
        files: 'src/less/**/*.less'
        tasks: 'less:src'
      coffee:
        files: 'src/coffee/**/*.coffee'
        tasks: 'coffee:src'
  
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'

  grunt.registerTask 'build', ['copy', 'less', 'coffee']
  grunt.registerTask 'serve', ['build', 'connect', 'watch']
  grunt.registerTask 'default', 'build'