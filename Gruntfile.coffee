path = require('path')

stylesheetsDir = 'assets/stylesheets'
rendrDir = 'node_modules/rendr'
rendrModulesDir = "#{rendrDir}/node_modules"

module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    bgShell:
      runNode:
        cmd: './node_modules/nodemon/nodemon.js index.coffee'
        bg: true

    stylus:
      compile:
        options:
          paths: [stylesheetsDir]
          'include css': true
        files:
          'public/styles.css': "#{stylesheetsDir}/index.styl"

    watch:
      scripts:
        files: [
          'app/**/*.coffee'
          'rendr-teacup/**/*.coffee'
        ]
        tasks: ['rendr_stitch']
        options:
          interrupt: true
      stylesheets:
        files: "#{stylesheetsDir}/**/*.styl"
        tasks: ['stylus']
        options:
          interrupt: true

    rendr_stitch:
      compile:
        options:
          dependencies: [
            "#{rendrDir}/assets/vendor/**/*.js"
            "#{rendrModulesDir}/underscore/underscore.js"
            "#{rendrModulesDir}/backbone/backbone.js"
            "#{rendrModulesDir}/async/lib/async.js"
            'assets/vendor/**/*.js'
          ]
          aliases: [
            {from: "#{rendrDir}/client", to: 'rendr/client'},
            {from: "#{rendrDir}/shared", to: 'rendr/shared'},
            {from: 'node_modules/teacup/lib/teacup', to: 'teacup'}
          ]
        files: [
          dest: 'public/mergedAssets.js'
          src: [
            'app/**/*.coffee'
            'rendr-teacup/**/*.coffee'
            'node_modules/teacup/lib/teacup.js'
            "#{rendrDir}/client/**/*.coffee"
            "#{rendrDir}/shared/**/*.coffee"
          ]
        ]

  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-bg-shell'
  grunt.loadNpmTasks 'grunt-rendr-stitch'

  grunt.registerTask 'compile', ['rendr_stitch', 'stylus']

  # Run the server and watch for file changes
  grunt.registerTask 'server', ['bgShell:runNode', 'compile', 'watch']

  # Default task(s).
  grunt.registerTask 'default', ['compile']
