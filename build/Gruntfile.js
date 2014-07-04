//////////////////////////////////////////////
// CSS & JS BUILD TOOL
// Written By Mason Berkshire
// TODO: CREATE UNIT TEST via PhantomJS and QUnit
//////////////////////////////////////////////

module.exports = function(grunt) {
    grunt.registerTask('watch', [ 'watch' ]);
    grunt.initConfig({
        requirejs: {
            compile: {
                options: {
                    baseUrl: '../public/js/',
                    mainConfigFile: '../public/js/config.js',
                    name: 'main',  out: '../public/js/dist/main.min.js',
                    findNestedDependencies: true
                }
            }
        },
        bower: {
            target: {
                rjsConfig: '../public/js/config.js',
                options: {
                    transitive: true
                }
            }
        },
        less: {
            dev: {
                files: {'../public/css/dist/app.css': '../public/css/app.less'},
                options: {
                    livereload: true,
                    cleancss: false
                }
            },
            prod: {
                files: {'../public/css/dist/app.min.css': '../public/css/app.less'},
                options: {
                    livereload: true,
                    cleancss: true
                }
            }
        },
        watch: {
            requirejs: {
                files: ['../public/js/**/*.js', '!../public/js/dist**/*.js'],
                tasks: ['buildjs:requirejs']
            },
            bower: {
                files: ['bower_components/**/*'],
                tasks: ['bower:target']
            },
            css: {
                files: ['../public/css/*.less' , '!../public/css/dist**/*.css'],
                tasks: ['less:prod']
            }
        }
    });
    grunt.loadNpmTasks('grunt-bower-requirejs');
    grunt.loadNpmTasks('grunt-contrib-requirejs');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.registerTask('package', [ 'bower:target' ]);
    grunt.registerTask('buildjs', [ 'requirejs' ]);
    grunt.registerTask('dev', [ 'less:dev' ]);
    grunt.registerTask('prod', [ 'less:prod' ]);
};
