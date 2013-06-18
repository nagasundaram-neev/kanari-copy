'use strict';

/* App Module */

var module = angular.module('kanari', []).
  config(['$routeProvider','$locationProvider', function($routeProvider,$locationProvider) {
  	
  $routeProvider.
     when('/login', {title: "Product",templateUrl: "<%= asset_path 'login.html' %>"}).
     when('/forgot_pass', {templateUrl: "<%= asset_path 'forgot_password.html' %>"}).
     when('/api/users/password/edit', {templateUrl: "<%= asset_path 'reset_password.html' %>"}).
     when('/outlets', {templateUrl: "<%= asset_path 'home.html' %>"}).
     when('/createInvitation', {templateUrl: "<%= asset_path 'add_Restaurant.html' %>"}).
     when('/accept_invitation', {templateUrl: "<%= asset_path 'accept_invitation.html' %>"}).
     when('/acceptInvitationStep2', {templateUrl: "<%= asset_path 'accept_invitation_step2.html' %>"}).
     when('/create_outlet', {templateUrl: "<%= asset_path 'create_outlet.html' %>"}).
     when('/create_manager', {templateUrl: "<%= asset_path 'create_manager.html' %>"}).
     when('/list_payment_invoice',{templateUrl:"<%= asset_path 'list_payment_invoice.html'%>"}).
     when('/payment_invoice',{templateUrl:"<%= asset_path 'payment_invoice.html'%>"}).
      when('/take_tour',{templateUrl:"<%= asset_path 'takeTour.html'%>"}).
       when('/view_account',{templateUrl:"<%= asset_path 'viewAccount.html'%>"}).
     when('/logout', {templateUrl: "<%= asset_path 'logOut.html' %>"}).
      when('/change_password', {templateUrl: "<%= asset_path 'changePassword.html' %>"}).
      otherwise({redirectTo: '/login'});
      $locationProvider.hashPrefix = "";
}]);




module.directive('map', function($http) {
	return {
		restrict : 'E',
		replace : true,
		template : '<div></div>',
		link : function(scope, element, attrs) {
			 scope.heyJoe = function() {
			console.log(element);
			var queryStringId = getUrlVars()["outletId"];
			var geocoder = new google.maps.Geocoder();
			var myOptions = {
				zoom : 6,
				center : new google.maps.LatLng(46.87916, -3.32910),
				mapTypeId : google.maps.MapTypeId.ROADMAP
			};
			// alert(attrs.id);
			var map = new google.maps.Map(document.getElementById(attrs.id), myOptions);
			var markersArray = [];
			if (queryStringId) {
				addMarker({
					lat : getCookie('latitude'),
					lng : getCookie('logitude')
				});

				function addMarker(pos) {
					var myLatlng = new google.maps.LatLng(pos.lat, pos.lng);
					//alert(myLatlng);
					geocoder.geocode({
						"latLng" : myLatlng
					}, function(results, status) {
						if (status == google.maps.GeocoderStatus.OK) {
							var html = results[0].formatted_address;
						}
						var marker = new google.maps.Marker({
							position : myLatlng,
							map : map,
							title : html
						});
						markersArray.push(marker);
					});

				}

			}
			google.maps.event.addListener(map, 'click', function(event) {
				scope.$apply(function() {
					addMarker({
						lat : event.latLng.lat(),
						lng : event.latLng.lng()
					});

					console.log(event);
				});

				geocoder.geocode({
					"latLng" : event.latLng
				}, function(results, status) {
					if (status == google.maps.GeocoderStatus.OK) {
						console.log(results[0].formatted_address);
						var infoWindow = new google.maps.InfoWindow();
						var html = results[0].formatted_address;

						var marker = new google.maps.Marker({
							position : event.latLng,
							map : map,
							title : html
						});
						markersArray.push(marker);

					}
				});

			});
			// end click listener

			var addMarker = function(pos) {

				clearOverlays()
				var myLatlng = new google.maps.LatLng(pos.lat, pos.lng);
				setCookie('latitude', pos.lat, 0.29);
				setCookie('logitude', pos.lng, 0.29);
				if (queryStringId) {
					var params = {
						"outlet" : {
							"latitude" : pos.lat,
							"longitude" : pos.lng
						},
						"auth_token" : getCookie('authToken')
					}

					$http({
						method : 'PUT',
						url : '/api/outlets/' + queryStringId,
						data : params,
					}).success(function(data, status) {
						console.log("data in success " + data + " status " + status);

					}).error(function(data, status) {
						console.log("data in error" + data + " status " + status);
					});
				}
			}//end addMarker
			function clearOverlays() {
				if (markersArray) {
					for (i in markersArray) {
						markersArray[i].setMap(null);
					}
				}
			}

			function getUrlVars() {
				var vars = [], hash;
				var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
				for (var i = 0; i < hashes.length; i++) {
					hash = hashes[i].split('=');
					vars.push(hash[0]);
					vars[hash[0]] = hash[1];
				}
				return vars;
			}
}
		}
	};
});

function getCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for (var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) == ' ')
		c = c.substring(1, c.length);
		if (c.indexOf(nameEQ) == 0)
			return c.substring(nameEQ.length, c.length);
	}
	return null;
}

function MapCtrl($scope) {
	if ($routeParams.outletId) {
	$scope.heyJoe();
	}

}

module.directive('passwordValidate', function() {
	return {
		require : 'ngModel',
		link : function(scope, elm, attrs, ctrl) {
			ctrl.$parsers.unshift(function(viewValue) {

				scope.pwdValidLength = (viewValue && viewValue.length >= 8 ? 'valid' : undefined);
				scope.pwdHasLetter = (viewValue && /[A-z]/.test(viewValue)) ? 'valid' : undefined;
				scope.pwdHasNumber = (viewValue && /\d/.test(viewValue)) ? 'valid' : undefined;

				if (scope.pwdValidLength && scope.pwdHasLetter && scope.pwdHasNumber) {
					ctrl.$setValidity('pwd', true);
					return viewValue;
				} else {
					ctrl.$setValidity('pwd', false);
					return undefined;
				}

			});
		}
	};
});

