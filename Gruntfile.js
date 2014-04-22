'use strict';

module.exports = function(grunt) {

  require('load-grunt-tasks')(grunt);
  require('time-grunt')(grunt);

  grunt.initConfig({

    root: {
      app: 'app/assets',
      dist: 'public/'
    },

    clean: {
      all: [
        '<%= root.dist %>/javascripts',
        '<%= root.dist %>/stylesheets',
        '<%= root.dist %>/images',
        '<%= root.dist %>/fonts'
      ]
    },

    jshint: {
      options: {
        jshintrc: '.jshintrc',
        reporter: require('jshint-stylish')
      },
      all: [
        'Gruntfile.js',
        '<%= root.app %>/javascripts/{,*/}{,*/}*.js'
      ]
    },

    uglify: {
      options: {
        mangle: false
      },
      dist: {
        files: {
          '<%= root.dist %>/vendor/requirejs/require.js': ['<%= root.app %>/vendor/requirejs/require.js']
        }
      }
    },

    copy: {
      app: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= root.app %>',
          dest: '<%= root.dist %>',
          src: [
            'fonts/**/*',
            'images/**/*'
          ]
        }]
      },
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= root.app %>',
          dest: '<%= root.dist %>',
          src: [
            'fonts/**/*'
          ]
        }]
      }
    },

    compass: {
      options: {
        sassDir: '<%= root.app %>/stylesheets',
        cssDir: '<%= root.dist %>/stylesheets',
        generatedImagesDir: '<%= root.dist %>/images/sprite',
        fontsDir: '<%= root.dist %>/fonts',
        imagesDir: '<%= root.dist %>/images',
        relativeAssets: false,
        assetCacheBuster: true
      },
      dist: {
        options: {
          httpStylesheetsPath: '/dist/stylesheets',
          httpImagesPath: '/dist/images',
          httpGeneratedImagesPath: '/dist/images/sprite',
          httpFontsPath: '/dist/fonts',
          environment: 'production'
        }
      },
      app: {
        options: {
          debugInfo: true,
          assetCacheBuster: false,
          force: true,
          environment: 'development'
        }
      }
    },

    cssmin: {
      dist: {
        files: {
          '<%= root.dist %>/stylesheets/main.css': [
            '<%= root.dist %>/stylesheets/{,*/}*.css'
          ]
        }
      }
    },

    imagemin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= root.app %>/images',
          src: '{,*/}*{,*/}*{,*/}*.{png,jpg,jpeg,gif}',
          dest: '<%= root.dist %>/images'
        }]
      }
    },

    watch: {
      options: {
        nospawn: true
      },
      styles: {
        files: [
          '<%= root.app %>/stylesheets/{,*/}*{,*/}*.{scss,sass}'
        ],
        tasks: ['compass:app']
      },
      scripts: {
        files: '<%= jshint.all %>',
        tasks: ['jshint']
      },
      images: {
        files: [
          '<%= root.app %>/images/{,*/}*{,*/}*{,*/}*.{png,jpg,jpeg,gif}'
        ],
        tasks: ['copy:app']
      }
    }

  });

  grunt.registerTask('default', [
    'clean',
    'copy:app',
    'jshint',
    'compass:app'
  ]);

  grunt.registerTask('build', [
    'clean',
    'jshint',
    'uglify',
    'copy:dist',
    'imagemin',
    'compass:dist',
    'cssmin'
  ]);

};
