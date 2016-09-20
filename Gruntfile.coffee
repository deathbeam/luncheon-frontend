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
    pug:
      src:
        options:
          pretty: true
        files: [
          {
            expand: true,
            cwd: 'src/pug',
            src: '**/*.pug',
            dest: 'public/',
            ext: '.html'
          }
        ]
    stylus:
      src:
        options:
          compress: false
        files: [
          {
            expand: true,
            cwd: 'src/stylus',
            src: '**/*.styl',
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
      pug:
        files: 'src/pug/**/*.pug'
        tasks: 'pug:src'
      stylus:
        files: 'src/stylus/**/*.styl'
        tasks: 'stylus:src'
      coffee:
        files: 'src/coffee/**/*.coffee'
        tasks: 'coffee:src'

  grunt.loadNpmTasks 'grunt-contrib-pug'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'build', ['pug', 'stylus', 'coffee']
  grunt.registerTask 'serve', ['build', 'connect', 'watch']
  grunt.registerTask 'default', 'build'