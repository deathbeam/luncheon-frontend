module.exports = (grunt) ->
  grunt.initConfig
    bower:
      install:
        options:
          targetDir: "public/vendor"
    connect:
      app:
        options:
          base: "public/",
          port: 9000,
          keepalive: true
    copy:
      css:
        expand: true,
        cwd: 'src/css',
        src: '**/*.css',
        dest: 'public/css/'
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
    mustache_render:
      luncheon:
        files: [
          {
            template: 'src/templates/luncheon.mustache.html',
            data: 'src/data/luncheon.json',
            dest: 'public/luncheon.html'
          }
        ]

  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-mustache-render'

  grunt.registerTask 'default', ['bower', 'copy', 'coffee', 'mustache_render']