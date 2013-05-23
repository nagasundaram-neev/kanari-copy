// var module = angular.module("app", []);
// 
// module.config(function($routeProvider,$locationProvider) {
	// $routeProvider.when('/home', {
        // templateUrl: 'blank.html',
        // jqmOptions: {transition: 'slide'}
    // });
    // $routeProvider.when('/settings', {
        // templateUrl: 'settings.html',
        // jqmOptions: {transition: 'slide'}
    // });
	// $routeProvider.when('/login', {
        // templateUrl: 'login.html',
        // jqmOptions: {transition: 'slide'}
    // });
    // $locationProvider.jqmCompatMode(false);
// });


var module = angular.module("app", []).config(function($routeProvider,$locationProvider){
    // bring back /# urls by turning OFF html5 paths
    // JQueryMobileAngularAdapter turns in ON by default
    // https://github.com/tigbro/jquery-mobile-angular-adapter/issues/163#issuecomment-16928255
    $locationProvider.html5Mode(false);
    $locationProvider.hashPrefix("");
    // routes
    console.log("in router");
    $routeProvider
        .when('/home',{templateUrl:'#home'}) // this is the default JQueryMobile view in index.html
        .when('/register',{templateUrl:'register.html'}) // this is a familiar AngularJS route using a partial ...
        .when('/login',{templateUrl:'/login.html'}) // ... and so is this
});