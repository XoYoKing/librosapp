///<reference path="def/jquery.d.ts"/>
///<reference path="def/angular.d.ts"/>
///<reference path="def/underscore.d.ts"/>

// Require stuff (modules.js must be first! to initialize modules)
///<reference path="modules.ts"/>
///<reference path="controls/Admin.ts"/>
// require controllers here

console.log("Register: App3")

var app = angular.module('app', ['controllers'], function ($routeProvider: ng.IRouteProviderProvider, $locationProvider: ng.ILocationProvider) {
  $locationProvider.html5Mode(true)
  $routeProvider.when('/404', {templateUrl: 'partials/404.html'})
  $routeProvider.when('/admin', {templateUrl: 'partials/admin.html', controller: "AdminCtrl"})
  //$routeProvider.when('/admin/:gameId', {templateUrl: 'partials/game.html', controller: "GameCtrl"})
  $routeProvider.otherwise({redirectTo: '/404'})
})

// ng-app wasn't always working. Make sure you don't have both!
angular.bootstrap($(document), ['app'])
