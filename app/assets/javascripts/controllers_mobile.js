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
var feedbackFlag = 0;
var signInCount = "";

module.controller('loginController', function($scope, $http, $location) {
	$scope.storageKey = 'JQueryMobileAngularTodoapp';
	$scope.remember = false;
	$scope.erromsg = false;
	$scope.email = ""
	$scope.chkLogin = function() {
		if ($scope.email == "" && $scope.password == "" && !$scope.email && !$scope.password) {
			console.log("email is blank");
			$scope.error = " Please enter Email and Password";
			$scope.erromsg = true;
			return false;
		}
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
				setCookie('signInCount', data.sign_in_count);
			} else {
				setCookie('userRole', data.user_role, 0.29);
				setCookie('authToken', data.auth_token, 0.29);
				setCookie('userName', data.first_name + ' ' + data.last_name, 0.29);
				setCookie('signInCount', data.sign_in_count, 0.29);
			}
			if (getCookie('userRole') == "user") {
				$location.url("/home");
			} else if (getCookie('userRole') == "kanari_admin" || getCookie('userRole') == "customer_admin" || getCookie('userRole') == "staff" || getCookie('userRole') == "manager") {
				$scope.error = "You are not authenticated to use this app";
				$scope.erromsg = true;
			}
		}).error(function(data, status) {
			console.log($scope.password)
			console.log("data " + $scope.email + " status " + status);
			if (getCookie('userRole') == "kanari_admin" || getCookie('userRole') == "customer_admin" || getCookie('userRole') == "staff") {
				$scope.error = "You are not authenticated to use this app";
				$scope.erromsg = true;
			} else {
				$scope.error = "Invalid Email or Password";
				$scope.erromsg = true;
			}
		});
	};
	$scope.forgotPassword = function() {
		$location.url('/forgotPassword');
	};

	$scope.home = function() {
		$location.url("/index");
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

	$scope.cancel = function() {
		$location.url("/login");
	};

	$scope.home = function() {
		$location.url("/index");
	};

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
	$scope.points = "";
	console.log("sign in Count" + getCookie("signInCount"));
	if (getCookie("authToken")) {
		//alert("token "+getCookie("authToken"));
		if (getCookie("signInCount") == 1 && getCookie('feedbackId')) {
			console.log("sign in Count if " + signInCount);
			var param = {
				"feedback_id" : getCookie('feedbackId')
			}
			$http({
				method : 'post',
				url : '/api/new_registration_points',
				data : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				//var date = new Date();
				$scope.points = data.points;
				$scope.feedbackSubmissions = 1;
				//alert("points"+$scope.points);
				//signInCount = 0;
			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));
				$scope.points = "0";
			});

		} else {
			console.log("sign in Count else " + getCookie("signInCount"));
			var param = {
				"auth_token" : getCookie('authToken'),
				"password" : "X"
			}

			$http({
				method : 'get',
				url : '/api/users',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				//var date = new Date();
				$scope.points = data.user.points_available;
				$scope.userName = data.user.first_name + " " + data.user.last_name;
				if (data.user.points_redeemed == null) {
					$scope.aedSaved = 0;
				} else {
					$scope.aedSaved = data.user.points_redeemed;
				}
				if (data.user.redeems_count == null) {
					$scope.redeems = 0;
				} else {
					$scope.redeems = data.user.redeems_count;
				}
				if (data.user.feedbacks_count == null) {
					$scope.feedbackSubmissions = 0;
				} else {
					$scope.feedbackSubmissions = data.user.feedbacks_count;
				}
				$scope.recentActivity = data.user.last_activity_at;
				//alert("points"+$scope.points);
			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));

			});
		}
		//alert("points"+$scope.points);
		//$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken') + ':X');
		// $scope.userName = getCookie('userName');
		$scope.role = getCookie('userRole');
		//document.body.style.background = #FFFFFF;

		$scope.homeClk = function() {
			$location.url("/home");
		};

		$scope.feedback = function() {
			$location.url("/feedback");
		};

		$scope.redeemPoints = function() {
			$location.url("/redeemPoints");
		};

		$scope.setting = function() {
			$location.url("/settings");
		};
	} else {
		$location.url("/login");
	}

});

module.controller('commonCtrl', function($scope, $http, $location) {
	//$location.url('/home');
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

module.controller('signUpController', function($scope, $http, $location) {
	$scope.confPassword = "";
	console.log("flag" + feedbackFlag);
	if (feedbackFlag == 1) {
		$scope.feedBackMsg = true;
		$scope.message = false;
	} else {
		$scope.message = true;
		$scope.feedBackMsg = false;
	}

	$scope.signUp = function() {
		if (!$scope.firstName || !$scope.lastName) {
			$scope.error = "First Name and Last Name is required. Please enter it to continue";
			$scope.errorMsg = true;
		} else {
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
				console.log("data in error " + $scope.email + " status " + status);
				if (data.errors[0] == "Email can't be blank") {
					console.log("data.errors[0] " + data.errors[0]);
					$scope.error = "Please enter a valid email";
					$scope.errorMsg = true;
				} else if (data.errors[0] == "Email has already been taken") {
					$scope.error = "This email belongs to an existing account";
					$scope.errorMsg = true;
				} else {
					$scope.error = data.errors[0];
					$scope.errorMsg = true;
				}
			});
		}
	};

	$scope.home = function() {
		$location.url("/index");
	};

});

module.controller('signedUpController', function($scope, $http, $location) {

	$scope.proceedAccount = function() {
		$location.url("/login");
	}
});
module.controller('changePasswordController', function($scope, $http, $location) {

	$scope.back = function() {
		$location.url("/settings");
	};

	$scope.changePassword = function() {
		if (!$scope.newPassword || !$scope.confirmPassword) {
			$scope.error = "Password fields can't be blank";
			$scope.errorMsg = true;
			$scope.succMsg = false;
		} else {
			var param = {
				"user" : {
					"password" : $scope.newPassword,
					"password_confirmation" : $scope.confirmPassword,
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
				deleteCookie('authToken');
				setCookie('authToken', data.auth_token, 0.29);
				$scope.errorMsg = false;
				$scope.succMsg = true;
				$scope.currentPassword = "";
				$scope.confirmPassword = "";
				$scope.newPassword = "";
			}).error(function(data, status) {
				console.log("data " + data + " status " + status);
				$scope.error = data.errors[0];
				$scope.errorMsg = true;
				$scope.succMsg = false;
			});

		}
	};

});

module.controller('settingsController', function($scope, $http, $location) {
	if (getCookie('authToken')) {
		$scope.succMsg = false;
		$scope.errorMsg = false;

		$scope.home = function() {
			$location.url("/home");
		};

		$scope.changePassword = function() {
			$location.url("/changePassword");
		};

		$scope.tansactionHistory = function() {
			$location.url("/transactionHistory");
		}

		$scope.getProfile = function() {

			var param = {
				"auth_token" : getCookie('authToken')
			}

			$http({
				method : 'get',
				url : '/api/users',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				//var date = new Date();
				if (data.user.date_of_birth) {
					date = data.user.date_of_birth.split("-");
					console.log("date " + date);
					console.log(date[0] + " " + date[1] + " " + date[2]);
					$scope.firstName = data.user.first_name;
					$scope.lastName = data.user.last_name;
					$scope.email = data.user.email;
					$scope.password = data.user.password;
					$scope.date = date[2];
					$scope.month = date[1];
					$scope.year = date[0];
					$scope.gender = data.user.gender;
					$scope.location = data.user.location;
				} else {
					$scope.firstName = data.user.first_name;
					$scope.lastName = data.user.last_name;
					$scope.email = data.user.email;
					$scope.password = data.user.password;
					$scope.date = "";
					$scope.month = "";
					$scope.year = "";
					$scope.gender = data.user.gender;
					$scope.location = data.user.location;
				}

			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));

			});

			//$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken') + ':X');
		};

		$scope.getProfile();

		$scope.saveProfile = function() {

			//console.log("length year"+$scope.year.length);
			var date = $scope.date + "/" + $scope.month + "/" + $scope.year;
			if (!$scope.date && !$scope.month && !$scope.year) {
				$scope.error = "Enter the date of birth";
				$scope.errorMsg = true;
				$scope.succMsg = false;
			} else if (!isDate(date)) {
				$scope.error = "Enter valid date of birth";
				$scope.errorMsg = true;
				$scope.succMsg = false;
			} else {
				var param = {
					"user" : {
						"first_name" : $scope.firstName,
						"last_name" : $scope.lastName,
						"date_of_birth" : $scope.date + "-" + $scope.month + "-" + $scope.year,
						"gender" : $scope.gender,
						"location" : $scope.location,
					},
					"auth_token" : getCookie('authToken')
				}

				$http({
					method : 'put',
					url : '/api/users',
					data : param
				}).success(function(data, status) {
					console.log("User Role " + data + " status " + status);
					deleteCookie('authToken');
					setCookie('authToken', data.auth_token, 0.29);
					$scope.errorMsg = false;
					$scope.succMsg = true;
				}).error(function(data, status) {
					console.log("data " + data + " status " + status);
					$scope.error = data.errors[0];
					$scope.errorMsg = true;
					$scope.succMsg = false;
				});

			}
			//$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('') + ':X');
		};

		$scope.logout = function() {
			console.log("in Logout" + getCookie('authToken'));

			var param = {
				"auth_token" : getCookie('authToken')
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
				deleteCookie('feedbackId');
				deleteCookie("signInCount");
				$location.url("/login");
			}).error(function(data, status) {
				console.log("data " + data + " status " + status + "authToken" + getCookie('authToken'));
			});
			$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken'));
			deleteCookie('authToken');
			deleteCookie('userRole');
			deleteCookie('userName');
			deleteCookie('feedbackId');
			deleteCookie("signInCount");
			$location.url("/login");
		};
	} else {
		$location.url("/login");
	}
});

var pointsEarned = 0;

module.controller('feedbackController', function($scope, $http, $location) {
	$scope.digit1 = "";
	$scope.digit2 = "";
	$scope.digit3 = "";
	$scope.digit4 = "";
	$scope.digit5 = "";
	$scope.error = false;

	$scope.home = function() {
		$location.url("/home");
	};

	$scope.clear = function() {
		$scope.digit1 = "";
		$scope.digit2 = "";
		$scope.digit3 = "";
		$scope.digit4 = "";
		$scope.digit5 = "";
		$scope.error = false;
	};

	$scope.enterValues = function(val) {
		//console.log("digit1 " + $scope.digit1);
		if (!$scope.digit1 || $scope.digit1 == "") {
			$scope.digit1 = val;
		} else if (!$scope.digit2 || $scope.digit2 == "") {
			$scope.digit2 = val;
		} else if (!$scope.digit3 || $scope.digit3 == "") {
			$scope.digit3 = val;
		} else if (!$scope.digit4 || $scope.digit4 == "") {
			$scope.digit4 = val;
		} else if (!$scope.digit5 || $scope.digit5 == "") {
			$scope.digit5 = val;
		}
	};

	$scope.next = function() {
		var kanariCode;
		if ($scope.digit1 && $scope.digit2 && $scope.digit3 && $scope.digit4 && $scope.digit5) {
			kanariCode = $scope.digit1 + "" + $scope.digit2 + "" + $scope.digit3 + "" + $scope.digit4 + "" + $scope.digit5;
		} else {
			kanaricode = "";
		}

		$http({
			method : 'get',
			url : '/api/kanari_codes/' + kanariCode,
			//params : param
		}).success(function(data, status) {
			console.log("User Role " + data + " status " + status);
			setCookie("feedbackId", data.feedback_id, 0.29);
			$location.url("/feedback_step2");
		}).error(function(data, status) {
			console.log("data " + data + " status " + status);
			$scope.errorMsg = data.errors[0];
			$scope.error = true;
		});

	};
});

module.controller('feedback_step2Controller', function($scope, $http, $location) {
	if (getCookie("feedbackId")) {
		$scope.nextFlag = 0;
		$scope.prevFlag = 0;
		$scope.like = true;
		$scope.prev = false;
		$scope.dislike = false;
		$scope.optionKeypad = true;
		$scope.recomendation = false;
		$scope.recomendationBar = false;
		$scope.counts = [];
		$scope.erromsg = false;
		$scope.willRecommend = "";
		$scope.feedBackArray = [0, 0, 0, 0, 0, 0];
		$scope.feedBackSize = 6;
		$scope.feedBackCategoryName = ["food", "friendlines", "speed", "ambiance", "cleanliness", "value"];
		$(".nxt").css("width", "100%");

		var yBarCount = 0;

		for (var i = 0; i <= 10; i++) {
			$scope.counts[i] = i;
		}

		$scope.food_quality = 0;
		$scope.friendlines_quality = 0;
		$scope.speed_quality = 0;
		$scope.ambiance_quality = 0;
		$scope.cleanliness_quality = 0;
		$scope.value_quality = 0;

		$scope.home = function() {
			$location.url("/home");
		};

		$scope.recommendation = function(count) {

			if ($('#feedback_' + count).hasClass('Ybar')) {
				for (var i = 0; i <= count; i++) {
					yBarCount = i;
					$("#feedback_" + i).removeClass("Ybar").addClass("Pbar");
				}
			} else {
				for (var i = count + 1; i <= yBarCount; i++) {
					$("#feedback_" + i).removeClass("Pbar").addClass("Ybar");
				}
			}

			$scope.willRecommend = parseInt(yBarCount);

		};

		var response = 0;
		$scope.categoryname = "";
		$scope.select_feedback_category = function(category) {
			category_switch = 0;
			if ($scope.like) {
				if ($scope.feedBackArray[category] == 0) {
					$scope.feedBackArray[category] = 1;
					$("#feed_" + category + " img").attr('src', '/assets/b_' + $scope.feedBackCategoryName[category] + '_4.png');
					$("#feed_" + category).css("background-color", "#664765");
					$("#feed_" + category + " span").css("color", "#E5E6E8");
				} else if ($scope.feedBackArray[category] == 1) {
					$scope.feedBackArray[category] = 0;
					$("#feed_" + category + " img").attr('src', '/assets/b_' + $scope.feedBackCategoryName[category] + '_3.png');
					$("#feed_" + category).css("background-color", "#E5E6E8");
					$("#feed_" + category + " span").css("color", "#664765");
				}

			} else {
				if ($scope.feedBackArray[category] == 0) {
					$scope.feedBackArray[category] = -1;
					$("#feed_" + category + " img").attr('src', '/assets/b_' + $scope.feedBackCategoryName[category] + '_2.png');
					$("#feed_" + category).css("background-color", "#664765");
					$("#feed_" + category + " span").css("color", "#E5E6E8");
				} else if ($scope.feedBackArray[category] == -1) {
					$scope.feedBackArray[category] = 0;
					$("#feed_" + category + " img").attr('src', '/assets/b_' + $scope.feedBackCategoryName[category] + '_1.png');
					$("#feed_" + category).css("background-color", "#E5E6E8");
					$("#feed_" + category + " span").css("color", "#664765");
				}
			}

		};

		$scope.next = function() {
			if ($scope.nextFlag == 0) {
				console.log("hi ")
				for (var i = 0; i < $scope.feedBackSize; i++) {
					if ($scope.feedBackArray[i] == 0) {
						$scope.feedBackArray[i] = 0;
						$("#feed_" + i + " img").attr('src', '/assets/b_' + $scope.feedBackCategoryName[i] + '_1.png');
						$("#feed_" + i).css("background-color", "#E5E6E8");
						$("#feed_" + i + " span").css("color", "#664765");
					} else if ($scope.feedBackArray[i] == 1) {
						$scope.feedBackArray[i] = 1;
						$("#feed_" + i + " img").attr('src', '/assets/b_' + $scope.feedBackCategoryName[i] + '_2.png');
						$("#feed_" + i).css("background-color", "#CCCCCC");
						$("#feed_" + i + " span").css("color", "#664765");
					} else if ($scope.feedBackArray[i] == -1) {
						$scope.feedBackArray[i] = -1;
						$("#feed_" + i + " img").attr('src', '/assets/b_' + $scope.feedBackCategoryName[i] + '_2.png');
						$("#feed_" + i).css("background-color", "#664765");
						$("#feed_" + i + " span").css("color", "#E5E6E8 ");
					}
				}
				$scope.like = false;
				$scope.optionKeypad = true;
				$scope.dislike = true;
				$scope.prev = true;
				$scope.recomendation = false;
				$scope.nextFlag = 1;
				$scope.prevFlag = 0;
				$scope.recomendationBar = false;
				$(".nxt").css("width", "49.5%");
			} else if ($scope.nextFlag == 1) {
				$scope.like = false;
				$scope.dislike = false;
				$scope.recomendation = true;
				$scope.recomendationBar = true;
				$scope.optionKeypad = false;
				$scope.prev = true;
				//$scope.nextFlag = 0;
				$scope.prevFlag = 1;
				$scope.nextFlag = -1;
				$(".nxt").css("width", "49.5%");
				$(".nxtTxt").html("SUBMIT");
				$scope.erromsg = false;
				$(".nxt img").hide();
				console.log("feedback " + $scope.feedBackArray);
			} else if ($scope.nextFlag == -1) {
				console.log("submitting feedback");
				if (!$scope.comment) {
					$scope.error = "Please provide advice for manager";
					$scope.erromsg = true;
				} else if (!$scope.willRecommend) {
					if ($scope.willRecommend == '0') {
						console.log("in hio ");
						var param = {
							"feedback" : {
								"food_quality" : parseInt($scope.feedBackArray[0]),
								"speed_of_service" : parseInt($scope.feedBackArray[2]),
								"friendliness_of_service" : parseInt($scope.feedBackArray[1]),
								"ambience" : parseInt($scope.feedBackArray[3]),
								"cleanliness" : parseInt($scope.feedBackArray[4]),
								"value_for_money" : parseInt($scope.feedBackArray[5]),
								"comment" : $scope.comment,
								"recommendation_rating" : $scope.willRecommend
							},
							"auth_token" : getCookie('authToken')
						}

						$http({
							method : 'put',
							url : '/api/feedbacks/' + getCookie('feedbackId'),
							data : param
						}).success(function(data, status) {
							console.log("User Role " + data + " status " + status);
							pointsEarned = data.points;
							$scope.erromsg = false;
							if (getCookie('authToken')) {
								$location.url("/feedbackSubmitSuccess");
								deleteCookie('feedbackId');
							} else {
								feedbackFlag = 1;
								$location.url("/signUp");
								deleteCookie('feedbackId');
							}
						}).error(function(data, status) {
							console.log("data in error" + data + " status " + status);
							if (status == 404) {
								$scope.error = "Code expired"
								$scope.erromsg1 = true;
							} else {
								$scope.error = data.errors[0];
								$scope.erromsg1 = true;
							}
							deleteCookie('feedbackId');
						});

					} else {
						console.log("recommend" + $scope.willRecommend);
						$scope.error = "Please recommend this place to your friend or colleague";
						$scope.erromsg = true;
					}
				} else {
					var param = {
						"feedback" : {
							"food_quality" : parseInt($scope.feedBackArray[0]),
							"speed_of_service" : parseInt($scope.feedBackArray[2]),
							"friendliness_of_service" : parseInt($scope.feedBackArray[1]),
							"ambience" : parseInt($scope.feedBackArray[3]),
							"cleanliness" : parseInt($scope.feedBackArray[4]),
							"value_for_money" : parseInt($scope.feedBackArray[5]),
							"comment" : $scope.comment,
							"recommendation_rating" : $scope.willRecommend
						},
						"auth_token" : getCookie('authToken')
					}

					$http({
						method : 'put',
						url : '/api/feedbacks/' + getCookie('feedbackId'),
						data : param
					}).success(function(data, status) {
						console.log("User Role " + data + " status " + status);
						pointsEarned = data.points;
						$scope.erromsg = false;
						if (getCookie('authToken')) {
							$location.url("/feedbackSubmitSuccess");
							deleteCookie('feedbackId');
						} else {
							feedbackFlag = 1;
							$location.url("/signUp");
							deleteCookie('feedbackId');
						}
					}).error(function(data, status) {
						console.log("data in error" + data + " status " + status);
						if (status == 404) {
							$scope.error = "Code expired"
							$scope.erromsg1 = true;
						} else {
							$scope.error = data.errors[0];
							$scope.erromsg1 = true;
						}
						deleteCookie('feedbackId');
					});
				}
			}
		};

		$scope.goBack = function() {
			deleteCookie('feedbackId');
			$location.url("/feedback");
		};

		$scope.previous = function() {
			console.log("in previous ");
			if ($scope.prevFlag == 0) {
				for (var i = 0; i < $scope.feedBackSize; i++) {
					if ($scope.feedBackArray[i] == 0) {
						$scope.feedBackArray[i] = 0;
						$("#feed_" + i + " img").attr('src', '/assets/b_' + $scope.feedBackCategoryName[i] + '_3.png');
						$("#feed_" + i).css("background-color", "#E5E6E8");
						$("#feed_" + i + " span").css("color", "#664765");
					} else if ($scope.feedBackArray[i] == -1) {
						$scope.feedBackArray[i] = -1;
						$("#feed_" + i + " img").attr('src', '/assets/b_' + $scope.feedBackCategoryName[i] + '_4.png');
						$("#feed_" + i).css("background-color", "#CCCCCC");
						$("#feed_" + i + " span").css("color", "#664765");
					} else if ($scope.feedBackArray[i] == 1) {
						$scope.feedBackArray[i] = 1;
						$("#feed_" + i + " img").attr('src', '/assets/b_' + $scope.feedBackCategoryName[i] + '_4.png');
						$("#feed_" + i).css("background-color", "#664765");
						$("#feed_" + i + " span").css("color", "#E5E6E8");
					}
				}
				$scope.like = true;
				$scope.dislike = false;
				$scope.optionKeypad = true;
				$scope.recomendationBar = false;
				$scope.recomendation = false;
				$scope.prevFlag = 1;
				$scope.prev = false;
				$(".nxt").css("width", "100%");
				$scope.nextFlag = 0;
				//$scope.prevFlag = -1;
			} else if ($scope.prevFlag == 1) {
				$scope.like = false;
				$scope.dislike = true;
				$scope.prev = true;
				$scope.recomendationBar = false;
				$scope.recomendation = false;
				$scope.optionKeypad = true;
				$scope.prevFlag = 0;
				$scope.nextFlag = 1;
				$(".nxt").css("width", "49.5%");
				$(".nxtTxt").html("NEXT");
				$(".nxt img").show();
			}
		};
	} else {
		$location.url("/home");
	}

});

module.controller('feedbackSubmitController', function($scope, $http, $routeParams, $location) {
	if (getCookie('authToken')) {
		//console.log("points " + pointsEarned);
		$scope.points = pointsEarned;
		//console.log("scope variable " + $scope.points);
		$scope.home = function() {
			$location.url("/home");
		};
	} else {
		$location.url("/login");
	}
});

module.controller('restaurantListController', function($scope, $http, $location) {
	if (getCookie('authToken')) {
		// $("#listRestaurant").niceScroll({cursorcolor:"#00F"});
		$scope.outlets = [];

		$scope.home = function() {
			$location.url("/home");
		};

		$scope.authToken = getCookie('authToken');
		console.log($scope.authToken);

		$scope.getRestaurantList = function() {

			var param = {
				"auth_token" : $scope.authToken,
				"password" : 'X'
			};

			$http({
				method : 'get',
				url : '/api/outlets',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				$scope.outlets = data.outlets;
			}).error(function(data, status) {
				console.log("data " + data + " status " + status);
			});

			//$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken') + ':X');
		};
		$scope.getRestaurantList();

		$scope.showRestaurant = function(outletId) {
			console.log(outletId);
			$location.url("/confirmRedeem?outletId=" + outletId);
			// $location.url("/showRestaurant?outletId=" + outletId);
		};

	} else {
		$location.url("/login");
	}
});

module.controller('showRestaurantController', function($scope, $http, $routeParams, $location) {
	if (getCookie('authToken')) {
		$.mobile.loading('show');
		$scope.lattitude = "";
		$scope.longitude = "";
		$scope.outlets = [];
		$scope.cuisineTypes = [];

		var param = {
			"auth_token" : getCookie('authToken')
		}
		$http({
			method : 'get',
			url : '/api/outlets/' + $routeParams.outletId,
			params : param,
		}).success(function(data, status) {
			console.log("data in success " + data + " status " + status);
			$scope.outletID = data.outlet.id;
			$scope.restaurant_name = data.outlet.name;
			$scope.restaurant_address = data.outlet.address;
			$scope.email_address = data.outlet.email;
			$scope.contact_number = data.outlet.phone_number;
			$scope.outlets = data.outlet.outlet_types;
			$scope.cuisineTypes = data.outlet.cuisine_types;
			$scope.fromTime = data.outlet.open_hours.split("-")[0];
			$scope.toTime = data.outlet.open_hours.split("-")[1];
			$scope.delivery = data.outlet.has_delivery.toString();
			$scope.alcohol = data.outlet.serves_alcohol.toString();
			$scope.outDoor_seating = data.outlet.has_outdoor_seating.toString();
			$scope.lattitude = data.outlet.latitude;
			$scope.longitude = data.outlet.longitude;
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);
		});

		$scope.home = function() {
			$location.url("/home");
		};

		$scope.previous = function() {
			$location.url("/redeemPoints");
		};

		$scope.redeemUpto = function() {
			$location.url("/confirmRedeem?outletId=" + $routeParams.outletId);
		};

		$scope.locationMap = function() {
			$location.url("/locationMap?outletId=" + $routeParams.outletId + "&lat=" + $scope.lattitude + "&long=" + $scope.longitude);
		};
		$.mobile.loading('hide');
	} else {
		$location.url("/login");
	}

});

module.controller('redeemPointsController', function($scope, $http, $location, $routeParams) {
	if (getCookie('authToken')) {

		$scope.successMsg = false;
		$scope.erromsg = false;

		$scope.previous = function() {
			// $location.url("/showRestaurant?outletId=" + $routeParams.outletId);
			$location.url("/redeemPoints");
		};

		$scope.home = function() {
			$location.url("/home");
		};

		$scope.listPoints = function() {
			var param = {
				"auth_token" : getCookie('authToken')
			}

			$http({
				method : 'get',
				url : '/api/users',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				//var date = new Date();
				$scope.points = data.user.points_available;
			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));
			});
		};

		$scope.listPoints();

		$scope.confirmRedeem = function() {
			if (!$scope.amount) {
				console.log("in if");
				$scope.error = "Please enter valid amount for redemption";
				$scope.successMsg = false;
				$scope.erromsg = true;
			} else if ($scope.amount < 0) {
				console.log("in else if");
				$scope.error = "Please enter valid amount for redemption";
				$scope.successMsg = false;
				$scope.erromsg = true;
			} else {
				var param = {
					"redemption" : {
						"outlet_id" : $routeParams.outletId,
						"points" : $scope.amount
					},
					"auth_token" : getCookie('authToken')
				}

				$http({
					method : 'post',
					url : '/api/redemptions',
					data : param
				}).success(function(data, status) {
					console.log("User Role " + data + " status " + status);
					$scope.success = "You have successfully redeemed for " + $scope.amount + " points";
					$scope.listPoints();
					$scope.successMsg = true;
					$scope.erromsg = false;
				}).error(function(data, status) {
					console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));
					$scope.error = data.errors[0];
					$scope.successMsg = false;
					$scope.erromsg = true;
				});
			}

		};

	} else {
		$location.url("/login");
	}
});

module.controller('transactionHistoryController', function($scope, $http, $location) {
	if (getCookie('authToken')) {

		$scope.home = function() {
			$location.url("/home");
		};

		$scope.previous = function() {
			$location.url("/settings");
		};
	} else {
		$location.url("/login");
	}
});

module.controller('locationMapController', function($scope, $http, $location, $routeParams) {
	$.mobile.loading('show');
	// $scope.MapCtrl = function() {
	// console.log("lattitude " + $routeParams.lat + " longitude " + $routeParams.long);
	// }
	console.log("lattitude " + $routeParams.lat + " longitude " + $routeParams.long);
	// $scope.$broadcast('clickMessageFromParent', {
	// data : "SOME msg to the child"
	// })
	google.maps.visualRefresh = true;

	angular.extend($scope, {

		position : {
			coords : {
				latitude : $routeParams.lat,
				longitude : $routeParams.long
			}
		},

		/** the initial center of the map */
		centerProperty : {
			latitude : $routeParams.lat,
			longitude : $routeParams.long
		},

		/** the initial zoom level of the map */
		zoomProperty : 9,

		/** list of markers to put in the map */
		markersProperty : [{
			latitude : $routeParams.lat,
			longitude : $routeParams.long
		}],

		// These 2 properties will be set when clicking on the map
		//clickedLatitudeProperty: null,
		//clickedLongitudeProperty: null,

		eventsProperty : {
			click : function(mapModel, eventName, originalEventArgs) {
				// 'this' is the directive's scope
				$log.log("user defined event on map directive with scope", this);
				$log.log("user defined event: " + eventName, mapModel, originalEventArgs);
			}
		}
	});

	$scope.back = function() {
		$location.url("/showRestaurant?outletId=" + $routeParams.outletId);
	};
	$.mobile.loading('hide');

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

function isDate(txtDate, separator) {
	var aoDate, // needed for creating array and object
	ms, // date in milliseconds
	month, day, year;
	// (integer) month, day and year
	// if separator is not defined then set '/'
	if (separator == undefined) {
		separator = '/';
	}
	// split input date to month, day and year
	aoDate = txtDate.split(separator);
	// array length should be exactly 3 (no more no less)
	if (aoDate.length !== 3) {
		return false;
	}
	// define month, day and year from array (expected format is m/d/yyyy)
	// subtraction will cast variables to integer implicitly
	month = aoDate[1] - 1;
	// because months in JS start from 0
	day = aoDate[0] - 0;
	year = aoDate[2] - 0;
	// test year range
	if (year < 1000 || year > 3000) {
		return false;
	}
	// convert input date to milliseconds
	ms = (new Date(year, month, day)).getTime();
	// initialize Date() object from milliseconds (reuse aoDate variable)
	aoDate = new Date();
	aoDate.setTime(ms);
	// compare input date and parts from Date() object
	// if difference exists then input date is not valid
	if (aoDate.getFullYear() !== year || aoDate.getMonth() !== month || aoDate.getDate() !== day) {
		return false;
	}
	// date is OK, return true
	return true;
}

/*** Facebook Connect ***/
module.run(function($rootScope, Facebook) {

	$rootScope.Facebook = Facebook;

})
module.factory('Facebook', function($http, $location) {

	var self = this;
	this.auth = null;

	return {

		getAuth : function() {
			return self.auth;
		},

		login : function() {
			FB.login(function(response) {
				if (response.authResponse) {
					console.log('Welcome!  Fetching your information.... ');
					self.auth = response.authResponse;
					FB.api('/me', function(response) {
						var param = {
							"user" : {
								"first_name" : response.first_name,
								"last_name" : response.last_name,
								"email" : response.email,
								"password" : 12345678,
								"password_confirmation" : 12345678,
							}
						};
						$http({
							method : 'post',
							url : '/api/users',
							data : param,
						}).success(function(data) {
							if (data.registration_complete == true) {
								setCookie('userRole', data.user_role, 7);
								setCookie('authToken', data.auth_token, 7);
								setCookie('userName', data.first_name + ' ' + data.last_name, 7);
								$location.url('/home');
							} else {

							}
						});

					});
				} else {
					console.log('Facebook login failed', response);
				}
			}, {
				scope : 'email'
			});
		},

		signUp : function() {
			$('#loginForm').addClass('loginClosed');
			$('#loginForm').replaceWith($('#registerFormContainer').html());
		},
	}

});

function moveToNext(field, nextFieldID) {
	if (field.value.length >= field.maxLength) {
		console.log("id " + nextFieldID);
		document.getElementById(nextFieldID).focus();
	}
}

window.fbAsyncInit = function() {
	FB.init({
		appId : '507524349327671'
	});
};

// Load the SDK Asynchronously
( function(d) {
		var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
		if (d.getElementById(id)) {
			return;
		}
		js = d.createElement('script');
		js.id = id;
		js.async = true;
		js.src = "//connect.facebook.net/en_US/all.js";
		ref.parentNode.insertBefore(js, ref);
	}(document));

