var Base64 = {

	// private property
	_keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

	// public method for encoding
	encode : function(input) {
		var output = "";
		var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
		var i = 0;

		input = Base64._utf8_encode(input);

		while (i < input.length) {

			chr1 = input.charCodeAt(i++);
			chr2 = input.charCodeAt(i++);
			chr3 = input.charCodeAt(i++);

			enc1 = chr1 >> 2;
			enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
			enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
			enc4 = chr3 & 63;

			if (isNaN(chr2)) {
				enc3 = enc4 = 64;
			} else if (isNaN(chr3)) {
				enc4 = 64;
			}

			output = output + this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) + this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);

		}

		return output;
	},

	// public method for decoding
	decode : function(input) {
		var output = "";
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
		var i = 0;

		input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

		while (i < input.length) {

			enc1 = this._keyStr.indexOf(input.charAt(i++));
			enc2 = this._keyStr.indexOf(input.charAt(i++));
			enc3 = this._keyStr.indexOf(input.charAt(i++));
			enc4 = this._keyStr.indexOf(input.charAt(i++));

			chr1 = (enc1 << 2) | (enc2 >> 4);
			chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
			chr3 = ((enc3 & 3) << 6) | enc4;

			output = output + String.fromCharCode(chr1);

			if (enc3 != 64) {
				output = output + String.fromCharCode(chr2);
			}
			if (enc4 != 64) {
				output = output + String.fromCharCode(chr3);
			}

		}

		output = Base64._utf8_decode(output);

		return output;

	},

	// private method for UTF-8 encoding
	_utf8_encode : function(string) {
		string = string.replace(/\r\n/g, "\n");
		var utftext = "";

		for (var n = 0; n < string.length; n++) {

			var c = string.charCodeAt(n);

			if (c < 128) {
				utftext += String.fromCharCode(c);
			} else if ((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
			} else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
			}

		}

		return utftext;
	},

	// private method for UTF-8 decoding
	_utf8_decode : function(utftext) {
		var string = "";
		var i = 0;
		var c = c1 = c2 = 0;

		while (i < utftext.length) {

			c = utftext.charCodeAt(i);

			if (c < 128) {
				string += String.fromCharCode(c);
				i++;
			} else if ((c > 191) && (c < 224)) {
				c2 = utftext.charCodeAt(i + 1);
				string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
				i += 2;
			} else {
				c2 = utftext.charCodeAt(i + 1);
				c3 = utftext.charCodeAt(i + 2);
				string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
			}
		}
		return string;
	}
}

var baseUrl = "localhost:8080";
var auth_token = "";

module.controller('loginController', function($scope, $http, $location) {
	$scope.storageKey = 'JQueryMobileAngularTodoapp';
	$scope.remember = false;
	$scope.erromsg = false;

	$scope.chkLogin = function() {
		var param = "{email:'" + $scope.email + "','password:'" + $scope.password + "'}";

		$http({
			method : 'post',
			url : '/api/users/sign_in',
		}).success(function(data, status) {
			auth_token = data.user_role;
			console.log("User Role " + data.user_role + " status " + status);
			if ($scope.remember) {
				setCookie('userRole', data.user_role, 7);
				setCookie('authToken', data.auth_token, 7);
				setCookie('userName', data.first_name + ' ' + data.last_name, 7);
			} else {
				setCookie('userRole', data.user_role, 0.29);
				setCookie('authToken', data.auth_token, 0.29);
				setCookie('userName', data.first_name + ' ' + data.last_name, 0.29);
			}
			$location.url("/home");
		}).error(function(data, status) {
			console.log("data " + data + " status " + status);
			$scope.erromsg = true;
		});

	};
	$scope.forgotPassword = function() {
		$location.url('/forgotPassword');
	};

	$scope.$watch('email + password', function() {
		$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode($scope.email + ':' + $scope.password);
	});

	// $scope.$watch('email + password', function() {
	// $http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode($scope.email + ':' + $scope.password);
	// });

});

module.controller('forgotPasswordController', function($scope, $http, $location) {

	$scope.success = false;

	$scope.sendLink = function() {
		var userEmail = $scope.email;
		var param = {
			"user" : {
				"email" : userEmail
			}
		};

		$http({
			method : 'post',
			url : '/api/users/password',
			data : param
		}).success(function(data, status) {
			console.log("data in success " + data + " status " + status);
			$scope.error = data.error;
			if (!userEmail) {
				$scope.erromsg = true;
				$scope.success = false;
			} else {
				$scope.success = true;
				$scope.erromsg = false;
			}
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);
			$scope.erromsg = true;
			$scope.success = false;
		});

	};
});

module.controller('resetPassController', function($scope, $http, $location, $routeParams) {

	$scope.erromsg = false;
	$scope.resetPass = function() {
		//alert($routeParams.reset_password_token);
		var userPass = $scope.password;
		var userConfirmPass = $scope.confirmpassword;
		var resetPassToken = $routeParams.reset_password_token;
		var param = {
			"user" : {
				"password" : userPass,
				"password_confirmation" : userConfirmPass,
				"reset_password_token" : resetPassToken
			}
		};
		//alert(param);
		$http({
			method : 'put',
			url : '/api/users/password',
			data : param,
		}).success(function(data, status) {
			console.log("data in success " + data + " status " + status);
			$scope.error = data.auth_token;
			$scope.statement = true;
			$scope.erromsg = false;
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);
			$scope.erromsg = true;
		});
	};

});

module.controller('homeController', function($scope, $http, $location) {
	if (getCookie('authToken')) {
		$scope.userName = getCookie('userName');
		$scope.role = getCookie('userRole');
		//document.body.style.background = #FFFFFF;
		$('body').css('background', '#FFF');

		$scope.homeClk = function() {
			$location.url("/home");
		};

		$scope.setting = function() {
			$location.url("/settings");

		};
	} else {
		$location.url('/login');
	}

});

module.controller('commonCtrl', function($scope, $http, $location) {
	if (getCookie('authToken')) {
		$location.url('/home');
	} else {
		// $location.url('/index');
	}

	$scope.emailCLick = function() {
		$location.url("/login");
	};
	$scope.signUpCLick = function() {
		$location.url("/signUp");
	};
});

module.controller('signUpController', function($scope, $http, $location) {

	$scope.signUp = function() {
		var param = {
			"user" : {
				"first_name" : $scope.firstName,
				"last_name" : $scope.lastName,
				"email" : $scope.email,
				"password" : $scope.password,
				"password_confirmation" : $scope.confPassword
			}
		}

		$http({
			method : 'post',
			url : '/api/users',
			data : param
		}).success(function(data, status) {
			console.log("User Role " + data + " status " + status);
			$location.url("/signedUp");
		}).error(function(data, status) {
			console.log("data in error " + data.errors + " status " + status);
			$scope.error = data.errors;
			$scope.errorMsg = true;
		});

	};

	$scope.cancel = function() {
		$location.url("/index");
	};

});

module.controller('signedUpController', function($scope, $http, $location) {

	$scope.proceedAccount = function() {
		$location.url("/login");
	}
});

module.controller('settingsController', function($scope, $http, $location) {
	$scope.succMsg = false;
	$scope.errorMsg = false;

	$scope.home = function() {
		$location.url("/home");
	};

	$scope.getProfile = function() {

		var param = {
			"user_auth_token" : getCookie('authToken')
		}

		$http({
			method : 'get',
			url : '/api/users',
			params : param
		}).success(function(data, status) {
			console.log("User Role " + data + " status " + status);
			$scope.firstName = data.user.first_name;
			$scope.lastName = data.user.last_name;
			$scope.email = data.user.email;
			$scope.password = data.user.password;
			$scope.dateOfBirth = data.user.date_of_birth;
			$scope.gender = data.user.gender;
			$scope.location = data.user.location;
		}).error(function(data, status) {
			console.log("data " + data + " status " + status);
		});

		//$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken') + ':X');
	};

	$scope.getProfile();

	$scope.saveProfile = function() {

		var param = {
			"user" : {
				"first_name" : $scope.firstName,
				"last_name" : $scope.lastName,
				"email" : $scope.email,
				"password" : $scope.newPassword,
				"password_confirmation" : $scope.confirmPassword,
				"date_of_birth" : $scope.dateOfBirth,
				"gender" : $scope.gender,
				"location" : $scope.location,
				"current_password" : $scope.currentPassword
			},
			"auth_token" : getCookie('authToken')
		}

		$http({
			method : 'put',
			url : '/api/users',
			data : param
		}).success(function(data, status) {
			console.log("User Role " + data + " status " + status);
			setCookie('authToken', data.auth_token, 0.29);
			$scope.errorMsg = false;
			$scope.succMsg = true;
		}).error(function(data, status) {
			console.log("data " + data + " status " + status);
			$scope.error = data.errors[0];
			$scope.errorMsg = true;
			$scope.succMsg = false;
		});

		//$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('') + ':X');
	};

	$scope.logout = function() {
		console.log("in Logout");

		var param = {
			"user_auth_token" : getCookie('authToken')
		}

		$http({
			method : 'delete',
			url : '/api/users/sign_out',
			data : param
		}).success(function(data, status) {
			console.log("User Role " + data + " status " + status);
			deleteCookie('authToken');
			deleteCookie('userRole');
			deleteCookie('userName');
			$location.url("/index");
		}).error(function(data, status) {
			console.log("data " + data + " status " + status);
		});

		//$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken') + ':X');

	};

});

function setCookie(name, value, days) {
	//alert(value);
	if (days) {
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		var expires = "; expires=" + date.toGMTString();
	} else
		var expires = "";
	document.cookie = name + "=" + value + expires + "; path=/";
}

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

function deleteCookie(name) {
	setCookie(name, "", -1);
}

