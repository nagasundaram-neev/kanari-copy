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

module.controller('commonCtrl', function($scope, $http, $location) {
	$scope.logout = function() {
		$http({
			method : 'delete',
			url : '/api/users/sign_out'
		}).success(function(data, status) {
			console.log("Data in success " + data + " status " + status);
			$location.url("/login");
		}).error(function(data, status) {
			console.log("data in error " + data + " status " + status);
		});

		$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(auth_token);
		deleteCookie('authToken');
		deleteCookie('userRole');
		$location.url("/login");
	}
	$scope.goTOOulet = function() {
		if (getCookie('userRole') == "kanari_admin") {
			$location.url("/home");
		} else if (getCookie('userRole') == "customer_admin") {
			$location.url("/outlets");
		}
	}
	$scope.getActive = function(section) {
		$location.url("/" + section);
	}
});

module.controller('Login', function($scope, $http, $location) {
	$('.welcome').hide();
	$('.navBarCls').hide();
	$scope.remember = false;
	$scope.storageKey = 'JQueryMobileAngularTodoapp';
	$scope.erromsg = false;
	$scope.login = function() {
		$location.url("/login");
	}
	$scope.getLogin = function() {
		console.log("under get login")
		if (getCookie('userRole') == "kanari_admin") {
			$location.url("/createInvitation");
		} else if (getCookie('userRole') == "customer_admin") {
			$location.url("/outlets");
		}

	};
	$scope.chkLogin = function() {

		$('.welcome').hide();
		$('.navBarCls').hide();

		var param = "{email:'" + $scope.email + "','" + $scope.password + "'}";
		$http({
			method : 'post',
			url : '/api/users/sign_in',
		}).success(function(data, status) {
			console.log("User Role " + data.user_role + " status " + status);
			if ($scope.remember) {
				setCookie('userRole', data.user_role, 7);
				setCookie('authToken', data.auth_token, 7);
			} else {
				setCookie('userRole', data.user_role, 0.29);
				setCookie('authToken', data.auth_token, 0.29);
			}

			$scope.erromsg = false;
			if (getCookie('userRole') == "kanari_admin") {
				$location.url("/createInvitation");
			} else if (getCookie('userRole') == "customer_admin" && data.registration_complete) {
				$location.url("/outlets");
			} else if (getCookie('userRole') == "customer_admin" && !data.registration_complete) {
				$location.url("/acceptInvitationStep2");
			}

		}).error(function(data, status) {
			console.log("data " + data + " status " + status);
			$scope.erromsg = true;
		});

	};

	$scope.$watch('email + password', function() {
		$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode($scope.email + ':' + $scope.password);
	});
	$scope.getLogin();
});

module.controller('forgotPassCtrl', function($scope, $http, $location) {
	$scope.erromsg = false;
	$scope.success = false;
	$scope.SendLink = function() {
		var userEmail = $scope.email;
		var param = {
			"user" : {
				"email" : userEmail
			}
		};
		//alert(param);
		$http({
			method : 'post',
			url : '/api/users/password',
			data : param,
		}).success(function(data, status) {
			console.log("data in success " + userEmail + " status " + status);
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
	$scope.BackLink = function() {
		$location.url("/login");
	}
});

module.controller('resetPassCtrl', function($scope, $routeParams, $http, $location) {
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

module.controller('homeCtrl', function($scope, $http, $location) {
	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.navBarCls').show();
		$scope.auth_token = getCookie('authToken');
		console.log("auth token = " + $scope.auth_token)
		$scope.userRole = getCookie('userRole');
		$scope.outlets = []

		var param = {
			"auth_token" : $scope.auth_token
		};
		$http({
			method : 'get',
			url : '/api/outlets',
			params : param,
		}).success(function(data, status) {
			console.log("data in success " + data + " status " + status);
			$scope.outlets = data.outlets;
			console.log($scope.outlets)
			$scope.error = data.auth_token;
			$scope.statement = true;
			$scope.erromsg = false;
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);
			$scope.erromsg = true;
		});
	} else {
		$location.url("/login");
	}
	$scope.disableOutlet = function($event, id) {
		console.log(id)
		$scope.auth_token = getCookie('authToken');
		checkbox = $event.target;
		console.log(checkbox.checked)
		var params = {
			"outlet" : {
				"disabled" : checkbox.checked
			},
			"auth_token" : $scope.auth_token
		}
		$http({
			method : 'PUT',
			url : '/api/outlets/' + id,
			data : params,
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
module.controller('createInvitation', function($scope, $http, $location) {

	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.navBarCls').show();
		$scope.statement = false;
		$scope.erromsg = false;
		$scope.errortext = ""
		$scope.create_invitation = function() {
			console.log("In Create Invitation" + auth_token);
			var userEmail = $scope.userEmail;
			var param = {
				"user" : {
					"email" : userEmail
				},
				"auth_token" : getCookie('authToken')
			}

			$http({
				method : 'post',
				url : '/api/users/invitation',
				data : param,
			}).success(function(data, status) {
				console.log("data in success " + data + " status " + status);
				//$location.url("/accept_invitation"+data.invitation_token);
				baseurl = ""
				if (!window.location.origin) {
					baseurl = window.location.protocol + "//" + window.location.host;
				} else {
					console.log("under else");
					baseurl = window.location.origin
				}
				$scope.invitation_token = baseurl + "/#/accept_invitation?invi_token=" + data.invitation_token;
				//$scope.invitation_token = $location.host()+":"+$location.port()+"/#/accept_invitation?invi_token=" + data.invitation_token;
				$scope.statement = true;
				$scope.erromsg = false;
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				$scope.errortext = data.errors[0]
				$scope.erromsg = true;
			});

		};
	} else {
		$location.url("/login");
	}
});

module.controller('paymentInvoiceCtrl', function($scope, $http, $location) {
	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.navBarCls').show();

		$scope.payment_invoice = function() {
			console.log("in Payment Invoice" + this.url);
			var invoiceId = $scope.kanari_invoice_id;
			var receiptDate = $scope.receipt_date;
			var amount = $scope.amount_paid;
			var param = {
				"payment_invoice" : {
					"kanari_invoice_id" : invoiceId,
					"receipt_date" : receiptDate,
					"amount_paid" : amount
				}
			}

			$http({
				method : 'post',
				url : '/api/customers/100/payment_invoices',
				data : param,
			}).success(function(data, status) {
				console.log("data in success " + data + " status " + status);
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
			});

			console.log("auth_token" + getCookie('authToken'));
			$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken') + ':X');

		};
	} else {
		$location.url("/login");
	}

});

module.controller('listPaymentInvoiceCtrl', function($scope, $http, $location) {
	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.navBarCls').show();

		var param = {
			"start_date" : "22-01-2013",
			"end_date" : "24-01-2013"
		}
		$http({
			method : 'get',
			url : '/api/customers/100/payment_invoices',
			data : param,
		}).success(function(data, status) {
			console.log("data in success " + data + " status " + status);
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);
		});
	} else {
		$location.url("/login");
	}
});

module.controller('createOutletCtrl', function($scope, $routeParams, $http, $location) {
	if (getCookie('authToken')) {
		$scope.profileShow = true;
		$scope.locationShow = false;
		$scope.permissionShow = false;
		$scope.ReportShow = false;
		$scope.updateMode = false;
		$('.welcome').show();
		$scope.auth_token = getCookie('authToken');
		//console.log(getCookie("authToken"));
		$('.navBarCls').show();
		$scope.error = false;
		$scope.success = false;
		$scope.outletTypes = [];
		$scope.cuisineTypes = [];
		/* Adding for updating the outlet*/
		if ($routeParams.outletId) {
			console.log($scope.auth_token);
			console.log($routeParams.outletId);
			var param = {
				"auth_token" : $scope.auth_token
			}
			$http({
				method : 'get',
				url : '/api/outlets/' + $routeParams.outletId,
				params : param,
			}).success(function(data, status) {
				console.log(data);
				console.log("data in success " + data + " status " + status);
				$scope.error = false;
				$scope.outletID = data.outlet.id;
				$scope.success = true;
				/* Populating preconfigured data useful for update query*/
				$scope.restaurant_name = data.outlet.name;
				$scope.restaurant_location = data.outlet.address;
				$scope.email_address = data.outlet.email;
				$scope.contact_number = data.outlet.phone_number;
				$scope.fromTime = data.outlet.open_hours.split("-")[0]
				$scope.toTime = data.outlet.open_hours.split("-")[1]
				$scope.Delivery = data.outlet.has_delivery.toString();
				$scope.serves_alcohol = data.outlet.serves_alcohol.toString();
				;
				$scope.outdoor_Seating = data.outlet.has_outdoor_seating.toString();
				$scope.updateMode = true

			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				$scope.error = true;
				$scope.success = false;
			});
		}
		$scope.getOutletTypes = function() {
			var param = {
				"auth_token" : $scope.auth_token
			}
			$http({
				method : 'get',
				url : '/api/outlet_types',
				params : param,
			}).success(function(data, status) {
				console.log(data);
				//console.log("data in success " + data + " status " + status);
				$scope.error = false;
				$scope.outletTypes = data.outlet_types;
				console.log($scope.outletTypes)
				$scope.success = true;

			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				$scope.error = true;
				$scope.success = false;
			});
		};
		$scope.getOutletTypes();
		$scope.getCuisineTypes = function() {
			var param = {
				"auth_token" : $scope.auth_token
			}
			$http({
				method : 'get',
				url : '/api/cuisine_types',
				params : param,
			}).success(function(data, status) {
				console.log(data);
				//console.log("data in success " + data + " status " + status);
				$scope.error = false;
				$scope.cuisineTypes = data.cuisine_types;
				console.log($scope.OutletTypes)
				$scope.success = true;

			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				$scope.error = true;
				$scope.success = false;
			});
		};
		$scope.getCuisineTypes();
		/* Adding for creating the outlet*/
		$scope.create_outlet = function() {
			var url = "/api/outlets"
			var method = "post"
			if ($scope.updateMode) {
				url = "/api/outlets/" + $scope.outletID;
				method = "PUT";
			}

			console.log($scope.fromTime);
			var param = {
				"outlet" : {
					"name" : $scope.restaurant_name,
					"address" : $scope.restaurant_location,
					"latitude" : "50.50",
					"longitude" : "60.60",
					"website_url" : "http://batmansdonuts.com",
					"email" : $scope.email_address,
					"phone_number" : $scope.contact_number,
					"open_hours" : $scope.fromTime + "-" + $scope.toTime,
					"has_delivery" : $scope.Delivery,
					"serves_alcohol" : $scope.serves_alcohol,
					"has_outdoor_seating" : $scope.outdoor_Seating
				},
				"auth_token" : $scope.auth_token
			}

			$http({
				method : method,
				url : url,
				data : param,
			}).success(function(data, status) {
				console.log("data in success " + data + " status " + status);
				$scope.error = false;
				if (data.outlet) {
					console.log(data.outlet.id);
					$scope.outletID = data.outlet.id;
				}

				$scope.success = true;
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				$scope.error = true;
				$scope.success = false;
			});
		};
		$scope.changeTab = function(currentTab) {
			if (currentTab == "profileShow") {
				$scope.profileShow = true;
				$scope.locationShow = false;
				$scope.permissionShow = false;
				$scope.ReportShow = false;
			} else if (currentTab == "locationShow") {
				$scope.profileShow = false;
				$scope.locationShow = true;
				$scope.permissionShow = false;
				$scope.ReportShow = false;
			} else if (currentTab == "permissionShow") {
				$scope.profileShow = false;
				$scope.locationShow = false;
				$scope.permissionShow = true;
				$scope.ReportShow = false;
			} else if (currentTab == "ReportShow") {
				$scope.profileShow = false;
				$scope.locationShow = false;
				$scope.permissionShow = false;
				$scope.ReportShow = true;
			}
		}
	} else {
		$location.url("/login");
	}
});

module.controller('acceptInvitationCtrl', function($scope, $routeParams, $http, $location) {
	$scope.acceptInvitation = function() {
		console.log($routeParams.invi_token);
		var param = {
			"user" : {
				"password" : $scope.password,
				"password_confirmation" : $scope.password_confirmation,
				"first_name" : $scope.first_name,
				"last_name" : $scope.last_name,
				"invitation_token" : $routeParams.invi_token
			}
		}

		$http({
			method : 'put',
			url : '/api/users/invitation',
			data : param,
		}).success(function(data, status) {
			console.log("data in success " + data + " status " + status);
			$scope.error = false;
			$scope.auth_token = data.auth_token;
			$scope.success = true;
			setCookie('authToken', data.auth_token, 1);
			$location.url("/acceptInvitationStep2");
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);
			$scope.errorMsg = data.errors;
			$scope.error = true;
			$scope.success = false;
		});

	}
});
module.controller('acceptInvitation2Ctrl', function($scope, $routeParams, $http, $location) {
	if (getCookie('authToken')) {
		$scope.auth_token = getCookie('authToken');
		console.log($scope.auth_token);
		$scope.acceptInvitation2 = function() {
			console.log($routeParams.invi_token);
			var param = {
				"customer" : {
					"name" : $scope.name,
					"phone_number" : $scope.phone_number,
					"registered_address_line_1" : $scope.registered_address_line_1,
					"registered_address_line_2" : $scope.registered_address_line_2,
					"registered_address_city" : $scope.registered_address_city,
					"registered_address_country" : $scope.registered_address_country,
					"mailing_address_line_1" : $scope.mailing_address_line_1,
					"mailing_address_line_2" : $scope.mailing_address_line_2,
					"mailing_address_city" : $scope.mailing_address_city,
					"mailing_address_country" : $scope.mailing_address_country,
					"email" : $scope.email
				},
				"auth_token" : $scope.auth_token

			}

			$http({
				method : 'post',
				url : '/api/customers',
				data : param,
			}).success(function(data, status) {
				console.log(data)
				console.log("data in success " + data + " status " + status);
				$scope.error = false;
				$scope.success = true;
				$location.url("/outlets");
				//$location.url("/login");
			}).error(function(data, status) {
				console.log(data)
				console.log("data in error" + data + " status " + status);
				$scope.errorMsg = data.errors;
				$scope.error = true;
				$scope.success = false;
			});

		}
	} else {
		$location.url("/login");
	}
});
module.controller('createManagerCtrl', function($scope, $routeParams, $route, $http, $location) {
	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.navBarCls').show();

		// $scope.items = [
		// {name: 'item1', content: 'content1'},
		// {name: 'item2', content: 'content2'},
		// {name: 'item3', content: 'content3'}
		// ];

		$http({
			method : 'get',
			url : '/api/managers',
		}).success(function(data, status) {
			console.log("data in success " + data + " status " + status);
			//console.log(data);
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);

		});

		$scope.add_new_manager = function() {
			$('.add_manager').show();
		}
		$scope.create_manager = function() {
			var param = {
				"user" : {
					"email" : $scope.email_address,
					"first_name" : $scope.first_name,
					"last_name" : $scope.last_name,
					"phone_number" : $scope.contact_number,
					"password" : $scope.password,
					"password_confirmation" : $scope.confirmpassword
				}
			}

			$http({
				method : 'post',
				url : '/api/managers',
				data : param,
			}).success(function(data, status) {
				console.log("data in success " + data + " status " + status);
				$scope.error = false;
				$scope.manager_id = data.manager.id;
				$scope.success = true;
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				$scope.errorMsg = data.errors;
				$scope.error = true;
				$scope.success = false;
			});
		}
	} else {
		$location.url("/login");
	}
});
module.controller('sidePanelCtrl', function($scope, $routeParams, $route, $http, $location) {
	var classNm = $location.path();
	var newValue = classNm.replace('/', '');
	$('.ng-scope li').removeClass('active');
	$('.' + newValue).addClass('active');
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
