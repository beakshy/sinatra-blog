requirejs.config({
    baseUrl: './js/',
    waitSeconds: 0,
    paths: {
        jquery: '../../build/bower_components/jquery/dist/jquery',
        parsleyjs: '../../build/bower_components/parsleyjs/dist/parsley',
        site: 'app/site',
        moment: '../../build/bower_components/moment/moment'
    },
    shim: {
        site: [
           
        ]
    },
    packages: [

    ]
});