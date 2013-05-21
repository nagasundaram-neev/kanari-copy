var userId, flag;

module.controller('Login', function($scope, $location) {
	$scope.storageKey = 'JQueryMobileAngularTodoapp';
	$('.signIn').show();
	$scope.data = {
		todos : [],
		name : '',
		inputText : ''
	};
	$scope.invalidUsernamePassword = false;
	$scope.save = function() {
		if ($scope.inputText != "" || $scope.pass != "") {
			$.getJSON('http://gateforumlive.com/webserv/login_validation.php?cdnuser=' + $scope.inputText + '&cdnpassword=' + $scope.pass + '&callback=?', function(data) {
				$scope.$apply(function() {
					//$scope.modelData = data;
					if (data != null) {
						switch (data.flag) {
							case 0:
								$scope.invalidUsernamePassword = true;
								break;
							case 1:
								userId = data.userid;
								$scope.reset();
								$scope.invalidUsernamePassword = false;
								$location.url("/settings");
								break;
							case 2:
								$scope.invalidUsernamePassword = true;
								break;
						}
					} else {
						$('#usrNm').removeClass('usrNmNormalImg').addClass('usrNmInvalidImg');
						$('#pass').removeClass('passNormalImg').addClass('passInvalidImg');
						$('#usrNm').parent().addClass('redBrdr');
						$('#pass').parent().addClass('redBrdr');
						$scope.invalidUsernamePassword = true;
					}
				});
			});
		}
	};
	$scope.reset = function() {
		this.$parent.inputText = "";
		this.$parent.pass = "";
		$scope.errorMessage = "";
	};
	$scope.back = function() {
		$location.goBack();
	};
	$scope.login = function() {
		$location.url("/login");
	}
});

module.controller('SettingsController', function($scope, $location) {
	$scope.name = userId;
	$scope.back = function() {
		$location.goBack();
	};
});

module.controller('SignUpController', function($scope, $location) {
	$scope.name = userId;
	$scope.passwordNotMatch = false;
	
	$scope.sign = function() {
		
		console.log($scope.name+' '+$scope.email);
		
	};
	
	$scope.passMatch = function(){
		console.log($scope.confpass);
	}
	
	$scope.back = function() {
		$location.goBack();
	};
});
