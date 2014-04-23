'use strict';

module.exports = function(grunt) {

  require('load-grunt-tasks')(grunt);
  require('time-grunt')(grunt);

  grunt.initConfig({

    root: {
      app: 'public/app',
      tmp: 'public/.tmp',
      dist: 'public/dist'
    },

    clean: {
      all: [
        '<%= root.tmp %>',
        '<%= root.dist %>'
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
      all: {
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
      }
    },

    compass: {
      options: {
        sassDir: '<%= root.app %>/stylesheets',
        cssDir: '<%= root.tmp %>/stylesheets',
        generatedImagesDir: '<%= root.tmp %>/images/sprite',
        fontsDir: '<%= root.app %>/fonts',
        imagesDir: '<%= root.app %>/images',
        relativeAssets: true,
        assetCacheBuster: true
      },
      dist: {
        options: {
          httpStylesheetsPath: '/dist/stylesheets',
          httpImagesPath: '/dist/images',
          httpGeneratedImagesPath: '/dist/images/sprite',
          httpFontsPath: '/dist/fonts',
          relativeAssets: false,
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
      }
    }

  });

  grunt.registerTask('default', [
    'clean',
    'jshint',
    'compass:app'
  ]);

  grunt.registerTask('build', [
    'clean',
    'jshint',
    'uglify',
    'copy',
    'imagemin',
    'compass:dist'
  ]);

};
