module.controller('commonCtrl', function($scope, $http, $location) {
	//$location.url('/home');
	$('body').removeClass('yellowBg');
	$scope.emailCLick = function() {
		$location.url("/login");
	};
	$scope.signUpCLick = function() {
		$location.url("/signUp");
	};
	$scope.leaveFeedback = function() {
		$location.url("/feedback");
	};
});

module.controller('signInController', function($scope, $http, $location) {
	$('body').addClass('yellowBg');
	
});
