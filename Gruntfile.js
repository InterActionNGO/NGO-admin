'use strict';

module.exports = function(grunt) {

  require('load-grunt-tasks')(grunt);
  require('time-grunt')(grunt);

  grunt.initConfig({

    root: {
      app: 'public/app',
      dist: 'public/dist'
    },

    clean: {
      all: [
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
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= root.app %>',
          dest: '<%= root.app %>',
          src: [
            '<%= root.app %>/fonts'
          ]
        }]
      }
    },

    compass: {
      options: {
        sassDir: '<%= root.app %>/stylesheets',
        cssDir: '<%= root.app %>/stylesheets',
        generatedImagesDir: '<%= root.app %>/images/sprite',
        fontsDir: '<%= root.app %>/fonts',
        imagesDir: '<%= root.app %>/images',
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
            '<%= root.app %>/vendor/cartodb/themes/css/cartodb.css',
            '<%= root.app %>/stylesheets/{,*/}*.css'
          ]
        }
      }
    },

    imagemin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= root.app %>/images',
          src: '{,*/}*.{png,jpg,jpeg,gif}',
          dest: '<%= root.dist %>/images'
        }, {
          expand: true,
          cwd: '<%= root.app %>/vendor/cartodb/themes/img',
          src: '{,*/}*.{png,jpg,jpeg,gif}',
          dest: '<%= root.dist %>/img'
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
    'compass:dist',
    'cssmin'
  ]);

};
