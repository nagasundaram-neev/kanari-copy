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
	$(".content").css("min-height", function() {
		return ($('.content')[0].scrollHeight) - 38;
	});

	if (getCookie('userRole') == "kanari_admin") {
		$scope.userName = getCookie('userRole');
	} else if (getCookie('userRole') == "customer_admin") {
		$scope.userName = getCookie('userName');
	} else if (getCookie('userRole') == "manager") {
		$scope.userName = getCookie('userName');
	}

	$scope.logout = function() {
		$http({
			method : 'delete',
			url : '/api/users/sign_out'
		}).success(function(data, status) {
			console.log("Data in success " + data + " status " + status);
			$location.url("/login");
		}).error(function(data, status) {
			console.log("data in error " + data + " status " + status);
			if (status == 401) {
				$location.url("/login");
			}
		});

		$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(auth_token);
		deleteCookie('authToken');
		deleteCookie('userRole');
		$location.url("/login");

	}
	$scope.goTOOulet = function() {
		if (getCookie('userRole') == "kanari_admin") {
			$location.url("/createInvitation");
		} else if (getCookie('userRole') == "customer_admin") {
			$location.url("/outlets");
		} else if (getCookie('userRole') == "manager") {
			$location.url("/outlets");
		}
	}
	$scope.getActive = function(section) {
		$location.url("/" + section);
	}
	if (getCookie('userRole') == "manager") {

		$('#account').hide();
		$scope.accountm = true;
		$('#accountm').show();
	} else {
		$scope.accountm = false;
		$('#accountm').hide();
	}

	// $scope.gotoDahboard = function(section) {
	// alert(getCookie('authToken'));
	// if (getCookie('authToken')) {
	// $location.url("/snapshot");
	// }
	// else{
	// $location.url("/login");
	// }
	// }

});

module.controller('Login', function($rootScope, $scope, $http, $location) {
	$rootScope.header = "Login | Kanari";
	$('.welcome').hide();
	$('.navBarCls').hide();
	$scope.remember = false;
	$scope.storageKey = 'JQueryMobileAngularTodoapp';
	$scope.erromsg = false;
	var acceptInvitationStep2;

	$scope.login = function() {
		$location.url("/login");
	}

	$scope.getLogin = function() {
		if (getCookie('userRole') == "kanari_admin") {
			$location.url("/createInvitation");
		} else if (getCookie('userRole') == "customer_admin") {
			$location.url("/outlets");
		}
	};
	$scope.rememberMe = function(val, stat) {
		if (val) {
			setCookie('rememberme', 'yes', 0.29);
		} else {
			setCookie('rememberme', 'no', 0.29);
		}
	};
	$scope.chkLogin = function(login) {
		if ($scope.login.$valid) {
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
					setCookie('userName', data.first_name + ' ' + data.last_name, 7);
					setCookie('userId', data.customer_id, 7);
				} else {
					setCookie('userRole', data.user_role, 0.29);
					setCookie('authToken', data.auth_token, 0.29);
					setCookie('userId', data.customer_id, 7);
					setCookie('userName', data.first_name + ' ' + data.last_name, 0.29);
				}

				$scope.erromsg = false;

				if (getCookie('userRole') == "kanari_admin") {
					$("#userName").text(getCookie('userRole'));
				} else if (getCookie('userRole') == "customer_admin") {
					$("#userName").text(getCookie('userName'));
					setCookie('auth_outlet', data.can_create_new_outlet, 7);
				} else if (getCookie('userRole') == "manager") {
					$("#userName").text(getCookie('userName'));
				}

				if (getCookie('userRole') == "kanari_admin") {
					$location.url("/createInvitation");
				} else if (getCookie('userRole') == "customer_admin" && data.registration_complete) {
					$location.url("/outlets");
				} else if (getCookie('userRole') == "customer_admin" && !data.registration_complete) {
					acceptInvitationStep2 = true;
					$location.url("/acceptInvitationStep2");
				} else if (getCookie('userRole') == "manager" && data.registration_complete) {
					$location.url("/outlets");
				} else if (getCookie("userRole") == "user") {
					$scope.error = "You are not authenticated to use this app";
					$scope.erromsg = true;
				}

			}).error(function(data, status) {
				console.log("data error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
				if (getCookie("userRole") == "user") {
					$scope.error = "You are not authenticated to use this app";
					$scope.erromsg = true;
				} else {
					$scope.error = "Invalid Email or Password";
					$scope.erromsg = true;
				}
			});
		};
		$scope.getLogin();
	};

	$scope.$watch('email + password', function() {
		$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode($scope.email + ':' + $scope.password);
	});
});

function getRefresh($scope) {

	if (getCookie('userRole') == "kanari_admin") {
		$scope.userName = getCookie('userRole');
	} else if (getCookie('userRole') == "customer_admin") {
		$scope.userName = getCookie('userName');
	}
}

module.controller('forgotPassCtrl', function($rootScope, $scope, $http, $location) {
	$rootScope.header = "Forgot Password | Kanari";
	$scope.erromsg = false;
	$scope.success = false;
	$scope.SendLink = function(forgotPass) {
		if ($scope.forgotPass.$valid) {
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
				if (status == 401) {
					$location.url("/login");
				}
				$scope.erromsg = true;
				$scope.success = false;
			});
		}
	};
	$scope.BackLink = function() {
		$location.url("/login");
	}
});

module.controller('resetPassCtrl', function($rootScope, $scope, $routeParams, $http, $location) {
	$rootScope.header = "Reset Password | Kanari";
	$scope.erromsg = false;
	$scope.reset_Pass = function(resetPass) {
		if ($scope.resetPass.$valid) {
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
				$scope.success = true;
				$scope.erromsg = false;
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
				$scope.errormessage = data.errors[0];
				$scope.erromsg = true;
				$scope.success = false;
			});
		}
	};
});

module.controller('homeCtrl', function($rootScope, $scope, $http, $location) {
	if (getCookie('authToken')) {
		$rootScope.header = "Outlets | Kanari";
		$('.welcome').show();
		$('.navBarCls').show();
		$('#dasboard').hide();
		$('#adminConsole').hide();
		$('#account').show();
		$('#outlet').show();
		$('#dasboardCustomer').show();
		$('.navBarCls ul li').removeClass('active');
		$('#outlet').addClass('active');
		$scope.auth_token = getCookie('authToken');
		$scope.userRole = getCookie('userRole');
		$scope.outlets = [];
		var outletCount;
		var authOutlet;

		var param = {
			"auth_token" : getCookie('authToken')
		};
		$http({
			method : 'get',
			url : '/api/outlets',
			params : param,
		}).success(function(data, status) {
			console.log("data in success " + data.lenght + " status " + status);
			$scope.outlets = data.outlets;
			$scope.error = data.auth_token;
			$scope.statement = true;
			$scope.erromsg = false;
			outletCount = data.outlets.length;
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);
			if (status == 401) {
				$location.url("/login");
			}
			$scope.erromsg = true;
		});

		var customer_id = getCookie('userId');

		var param = {
			"auth_token" : getCookie('authToken')
		}

		$http({
			method : 'get',
			url : '/api/customers/' + customer_id,
			params : param,
		}).success(function(data, status) {
			console.log("data in success " + data + " status " + status);
			authOutlet = data.customer.authorized_outlets;
			if (outletCount <= authOutlet) {
				setCookie('auth_outlet', "true", 7);
				showAddOutletBtn();
			} else {
				setCookie('auth_outlet', "false", 7);
				showAddOutletBtn();
			}
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);
			if (status == 401) {
				$location.url("/login");
			}

		});

		function showAddOutletBtn() {
			if (getCookie('userRole') == "customer_admin" && getCookie('auth_outlet') == "true") {
				$scope.userAction = true;
				$scope.accountm = false;
				$('#accountm').hide();
			} else {
				$('#account').hide();
				$scope.accountm = true;
				$('#accountm').show();
			}
		}

	} else {
		$location.url("/login");
	}

	$scope.changeTab = function(currentTab) {
		//setCookie('selectedTab', currentTab, 7);
		$location.url("/take_tour");
	};
});
module.controller('createInvitation', function($rootScope, $scope, $http, $location) {

	if (getCookie('authToken')) {
		$rootScope.header = "Create Invitation | Kanari";
		$('.welcome').show();
		$('.navBarCls').show();
		$('#outlet').hide();
		$('#dasboard').show();
		$('#adminConsole').show();
		$('.navBarCls ul li').removeClass('active');
		$('#outlet').hide();
		$('#account').hide();
		$('#dasboardCustomer').hide();
		$('#dasboard').addClass('active');

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
					baseurl = window.location.origin
				}
				$scope.invitation_token = baseurl + "/#/accept_invitation?invi_token=" + data.invitation_token;
				$scope.statement = true;
				$scope.erromsg = false;
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
				if (userEmail) {
					$scope.errortext = "An invitation url for this email is already created.";
					$scope.statement = false;
					$scope.erromsg = true;
				}
				$scope.statement = false;
			});

		};
	} else {
		$location.url("/login");
	}
});

module.controller('paymentInvoiceCtrl', function($rootScope, $scope, $http, $location) {
	if (getCookie('authToken')) {
		$rootScope.header = "Create Payment Invoice | Kanari";
		$('.welcome').show();
		$('.navBarCls').show();
		$('.navBarCls ul li').removeClass('active');
		$('#outlet').hide();
		$('#account').hide();
		$('#dasboardCustomer').hide();
		$('#dasboard').show();
		$('#adminConsole').show();
		$('#dasboard').addClass('active');

		$scope.paymentInvoiceSuccess = false;
		$scope.paymentInvoiceFail = false;
		$scope.titles = [];
		var currencies = [];
		var custId;

		$('#receipt_date').datepicker().on('changeDate', function(ev) {
			var dt = new Date(ev.date.valueOf());
			var month = dt.getMonth() + 1;
			recipt_date = dt.getFullYear() + "-" + month + "-" + dt.getDate();
			if ( typeof startDt != 'undefined' && endDt != 'undefined') {
				console.log("hi in end date");
				$(".outletDropDown").change(function() {
				});
			}
		});

		//Get Customer List
		var param = {
			"auth_token" : getCookie('authToken')
		};
		$http({
			method : 'get',
			url : 'api/customers',
			params : param,
		}).success(function(data, status) {
			console.log("data in success " + data.lenght + " status " + status);
			var arrayLengthOutlet = data.customers.length;
			for (var i = 0, len = arrayLengthOutlet; i < len; i++) {
				currencies.push({
					"value" : data.customers[i].name,
					"id" : data.customers[i].id
				})
			}
			$('#autocomplete').autocomplete({
				lookup : currencies,
				onSelect : function(suggestion) {
					custId = suggestion.id;
					$scope.getOutletList(custId);
				}
			});
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);
			if (status == 401) {
				$location.url("/login");
			}
		});
		$scope.isOutlet = true;
		//Get Outlet List according to the customer
		$scope.getOutletList = function(custId) {
			console.log(custId);
			var param = {
				"customer_id" : custId,
				"auth_token" : getCookie('authToken')
			};
			$http({
				method : 'get',
				url : 'api/outlets',
				params : param,
			}).success(function(data, status) {
				console.log("data in success " + data.lenght + " status " + status);
				$scope.outletsList = data.outlets;
				console.log(data.outlets.length);
				if (data.outlets.length > 0) {
					$scope.isOutlet = true;
					$scope.formoutlet1 = data.outlets[0].id;
				} else {
					$scope.isOutlet = false;
				}
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		}

		$scope.payment_invoice = function(paymentInvoice) {
			if ($scope.paymentInvoice.$valid && $("#sDate").val()) {
				$scope.dateEntered = false;
				var param = {
					"payment_invoice" : {
						"kanari_invoice_id" : $scope.kanari_invoice_id,
						"outlet_id" : $scope.formoutlet1,
						"kanari_plan" : $scope.kanari_plan,
						"receipt_date" : recipt_date,
						"amount_paid" : $scope.amount_paid,
						"invoice_url" : $scope.invoice_pdf
					},
					"auth_token" : getCookie('authToken')
				}

				$http({
					method : 'POST',
					url : '/api/customers/' + custId + '/payment_invoices',
					data : param,
				}).success(function(data, status) {
					console.log("data in success " + data + " status " + status);
					$scope.paymentInvoiceSuccess = true;
				}).error(function(data, status) {
					console.log("data in error" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					$scope.paymentInvoiceFail = true;
				});

				$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken') + ':X');
			} else {
				$scope.paymentInvoiceSuccess = false;
				$scope.dateEntered = true;
			}
		};

		$scope.clearForm = function() {
			$scope.paymentInvoiceSuccess = false;
			document.getElementById('paymentInvoiceForm').reset();
			$scope.outletsList = "";
		};
	} else {
		$location.url("/login");
	}

});

module.controller('listPaymentInvoiceCtrl', function($rootScope, $scope, $http, $location) {
	if (getCookie('authToken')) {
		$rootScope.header = "Payment Invoice List | Kanari";
		$scope.paymentInvoiceSuccess = false;
		$('.welcome').show();
		$('.navBarCls').show();
		$('.navBarCls ul li').removeClass('active');
		$('#outlet').show();
		$('#account').show();
		$('#dasboard').hide();
		$('#adminConsole').hide();
		$('#dasboardCustomer').hide();
		$('#outlet').addClass('active');
		$scope.InvoiceList = [];
		$scope.list_payment_invoice = function() {
			var startDate = $scope.start_date;
			var endDate = $scope.end_date;
			//var param = "start_date=" + startDate + "&end_date=" + endDate + "&auth_token=" + getCookie('authToken');
			var param = {
				"start_date" : startDate,
				"end_date" : endDate,
				"auth_token" : getCookie('authToken')
			}

			$http({
				method : 'get',
				url : '/api/payment_invoices',
				params : param,
			}).success(function(data, status) {
				console.log("data in success " + data + " status " + status);
				$scope.InvoiceList = data.payment_invoices;
				var value = $scope.InvoiceList.val;
				if (!value) {
					$scope.paymentInvoiceSuccess = true;
				} else {
					$scope.paymentInvoiceSuccess = false;
				}
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});

			$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken') + ':X');
		};

	} else {
		$location.url("/login");
	}
});

module.controller('createOutletCtrl', function($rootScope, $scope, $routeParams, $http, $location) {
	if (getCookie('authToken')) {
		$scope.action = true;
		$rootScope.header = "Create Outlet | Kanari";
		$scope.profileShow = true;
		$scope.managerField = false;
		$scope.locationShow = false;
		$scope.permissionShow = false;
		$scope.ReportShow = false;
		$scope.TabletIdShow = false;
		$scope.updateMode = false;
		$scope.success1 = false;
		$scope.form_outlet2 = false;
		$scope.form_outlet3 = false;
		$scope.form_cuisine2 = false;
		$scope.form_cuisine3 = false;
		$('.welcome').show();
		$('#dasboard').hide();
		$('#adminConsole').hide();
		var managerId;
		$scope.auth_token = getCookie('authToken');
		$('.navBarCls').show();
		$('#dasboardCustomer').show();
		$scope.error = false;
		$scope.successMsg = false;
		$scope.outletTypes = [];
		$scope.cuisineTypes = [];
		$scope.managerList = [];
		$scope.checkedCuisineTypes = [];
		$scope.checkedOutletTypes = [];
		$scope.checked_CuisineTypes = [];
		$scope.checked_OutletTypes = [];
		$scope.listTabIds = [];

		if (getCookie('userRole') == "customer_admin") {
			$scope.userAction = true;
		} else {
			$('#account').hide();
		}

		if (getCookie('auth_outlet') == "false" && !$routeParams.outletId) {
			$location.url("/outlets");
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
				$scope.error = false;
				$scope.outletTypes = data.outlet_types;
				$scope.success = true;

			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
				$scope.error = true;
				$scope.success = false;
			});
		};
		$scope.getOutletTypes();
		$scope.getCuisineTypes = function() {
			var param = {
				"auth_token" : getCookie('authToken')
			}
			$http({
				method : 'get',
				url : '/api/cuisine_types',
				params : param,
			}).success(function(data, status) {
				$scope.error = false;
				$scope.cuisineTypes = data.cuisine_types;

				$scope.success = true;

			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
				$scope.error = true;
				$scope.success = false;
			});
		};
		$scope.getCuisineTypes();

		$scope.getManagerList = function() {
			var param = {
				"auth_token" : getCookie('authToken')
			}
			$http({
				method : 'get',
				url : '/api/managers',
				params : param,
			}).success(function(data, status) {
				$scope.error = false;
				$scope.managerList = data.managers;
				var managerlist = data.managers;
				if (managerlist != "") {
					$scope.managerField = true;
				} else {
					$scope.managerField = false;
				}
				$scope.success = true;

			}).error(function(data, status) {
				console.log("data  in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
				$scope.error = true;
				$scope.success = false;
			});
		};
		$scope.getManagerList();

		$scope.selectAction = function(select_Action) {
			if ($scope.select_Action.$valid) {
				var pos_lat;
				var pos_lng;
				var param = {
					"auth_token" : getCookie('authToken')
				}
				$http({
					method : 'get',
					url : '/api/outlets/' + $scope.outletID,
					params : param,
				}).success(function(data, status) {
					if (data.outlet.latitude) {
						pos_lat = data.outlet.latitude;
					}

					if (data.outlet.longitude) {
						pos_lng = data.outlet.longitude;
					}
				}).error(function(data, status) {
					if (status == 401) {
						$location.url("/login");
					}

				});

				managerId = $scope.myOption;
				//$scope.manager = managerId;
				console.log("Test" + getCookie('currentCuisineList'));
				var param = {
					"outlet" : {
						"manager_id" : managerId,
						"cuisine_type_ids" : JSON.parse(getCookie('currentCuisineList')),
						"outlet_type_ids" : JSON.parse(getCookie('currentOutletList')),
					},
					"auth_token" : getCookie('authToken')
				}

				$http({
					method : "put",
					url : "/api/outlets/" + $scope.outletID,
					data : param,
				}).success(function(data, status) {
					console.log("data in success hi " + data + " status " + status);
					$scope.successmgr = true;
					//$scope.manager_show = true;
					$scope.getOutlet();
				}).error(function(data, status) {
					console.log("data in error" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					$scope.successmgr = false;
				});
			}
		}
		/* Adding for updating the outlet*/

		$scope.getOutlet = function() {
			if ($routeParams.outletId) {
				$rootScope.header = "Update Outlet | Kanari";
				$scope.action = false;
				var param = {
					"auth_token" : $scope.auth_token
				}
				$http({
					method : 'get',
					url : '/api/outlets/' + $routeParams.outletId,
					params : param,
				}).success(function(data, status) {

					console.log("data in success " + data + " status " + status);
					$scope.error = false;
					$scope.outletID = data.outlet.id;
					$scope.success = true;
					/* Populating preconfigured data useful for update query*/
					$scope.restaurant_name = data.outlet.name;
					$scope.restaurant_location = data.outlet.address;
					$scope.email_address = data.outlet.email;
					$(".phoneno_1").val(data.outlet.phone_number);
					$scope.fromTime = data.outlet.open_hours.split("-")[0];
					$scope.toTime = data.outlet.open_hours.split("-")[1];
					$scope.outlet_disabled = data.outlet.disabled;
					if (data.outlet.has_delivery) {
						var radio_btn1 = data.outlet.has_delivery.toString();
						$scope.Delivery = radio_btn1;
					} else if (data.outlet.has_delivery = "false") {
						var radio_btn1 = data.outlet.has_delivery.toString();
						$scope.Delivery = radio_btn1;
					}
					if (data.outlet.serves_alcohol) {
						var radio_btn2 = data.outlet.serves_alcohol.toString();
						$scope.serves_alcohol = radio_btn2;
					} else if (data.outlet.serves_alcohol = "false") {
						var radio_btn2 = data.outlet.serves_alcohol.toString();
						$scope.serves_alcohol = radio_btn2;
					}
					if (data.outlet.has_outdoor_seating) {
						var radio_btn3 = data.outlet.has_outdoor_seating.toString();
						$scope.outdoor_Seating = radio_btn3;
					} else if (data.outlet.has_outdoor_seating = "false") {
						var radio_btn3 = data.outlet.has_outdoor_seating.toString();
						$scope.outdoor_Seating = radio_btn3;
					}
					setCookie('latitude', data.outlet.latitude, 0.29);
					setCookie('logitude', data.outlet.longitude, 0.29);
					if (data.outlet.manager) {
						$scope.manager = data.outlet.manager.first_name + ' ' + data.outlet.manager.last_name;
						$scope.manager_show = true;
					} else {
						$scope.manager_show = false;
					}
					$scope.updateMode = true;
					$scope.checked_CuisineTypes = data.outlet.cuisine_types;
					for ( i = 0; i < $scope.checked_CuisineTypes.length; i++) {
						$scope.checkedCuisineTypes.push($scope.checked_CuisineTypes[i]["id"]);
						if (i == 0) {
							$scope.formcuisine1 = $scope.checked_CuisineTypes[i]["id"];
							$scope.form_cuisine2 = true;
						} else if (i == 1) {
							$scope.formcuisine2 = $scope.checked_CuisineTypes[i]["id"];
							$scope.form_cuisine3 = true;
						} else if (i == 2) {
							$scope.formcuisine3 = $scope.checked_CuisineTypes[i]["id"];
						}

					}
					$scope.checked_OutletTypes = data.outlet.outlet_types;
					for ( i = 0; i < $scope.checked_OutletTypes.length; i++) {
						$scope.checkedOutletTypes.push($scope.checked_OutletTypes[i]["id"]);
						if (i == 0) {
							$scope.formoutlet1 = $scope.checked_OutletTypes[i]["id"];
							$scope.form_outlet2 = true;
						} else if (i == 1) {
							$scope.formoutlet2 = $scope.checked_OutletTypes[i]["id"];
							$scope.form_outlet3 = true;
						} else if (i == 2) {
							$scope.formoutlet3 = $scope.checked_OutletTypes[i]["id"];
						}
					}
					$scope.$broadcast('clickMessageFromParent', {
						data : "SOME msg to the child"
					})

				}).error(function(data, status) {
					console.log("data in error" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					$scope.error = true;
					$scope.success = false;
				});
			}
		}
		$scope.getOutlet();
		/* Validating the form */
		$scope.validateForm = function() {
			if ($scope.restaurant_name && $scope.restaurant_location && $scope.email_address && $scope.contact_number && $scope.Delivery && $scope.serves_alcohol && $scope.outdoor_Seating) {
				return true;
			} else {
				return false;
			}
		};

		$scope.selectOutlet1 = function() {
			$scope.form_outlet2 = true;
			console.log($scope.formoutlet3);
			if ($scope.formoutlet1) {
				if ($scope.formoutlet1 == $scope.formoutlet2 || $scope.formoutlet1 == $scope.formoutlet3) {
					$scope.outletError1 = false;
					$scope.outletError = true;
					$scope.checkedOutletTypes.splice(0, 1);
					$scope.formoutlet1 = 0;

				} else {
					$scope.outletError = false;
					$scope.checkedOutletTypes[0] = $scope.formoutlet1;
					setCookie('currentOutletList', $scope.checkedOutletTypes, 1);
					$scope.outletError1 = false;
					$scope.outletError2 = false;
				}
			} else {
				if ($('#select3').is(':visible')) {
					$scope.outletError1 = true;
					$('.customErrCls').css('left', '555px');
				} else {
					$scope.outletError1 = true;
					$('.customErrCls').css('left', '430px');
				}
			}

		}
		$scope.selectOutlet2 = function() {
			$scope.form_outlet3 = true;
			if ($scope.formoutlet2 && $scope.formoutlet1) {
				if ($scope.formoutlet2 == $scope.formoutlet1 || $scope.formoutlet2 == $scope.formoutlet3) {
					$scope.outletError = true;
					$scope.checkedOutletTypes.splice(1, 1);
					$scope.formoutlet2 = 0;
					$('.customErrCls').css('left', '555px');

				} else {
					$scope.outletError = false;
					$scope.checkedOutletTypes[1] = $scope.formoutlet2;
					$scope.outletError2 = false;
					$('.customErrCls').css('left', '555px');
				}
			} else {
				$('.customErrCls').css('left', '555px');
				$scope.outletError2 = true;
				$scope.checkedOutletTypes.splice(1, 1);
				if ($scope.formoutlet1) {
				} else {
					$scope.outletError1 = true;
					$scope.formoutlet2 = 0;
					$scope.formoutlet3 = 0;
				}

			}
		}
		$scope.selectOutlet3 = function() {
			if ($scope.formoutlet3 && $scope.formoutlet1 && $scope.formoutlet2) {
				if ($scope.formoutlet3 == $scope.formoutlet1 || $scope.formoutlet3 == $scope.formoutlet2) {
					$scope.outletError = true;
					$scope.checkedOutletTypes.splice(2, 1);
					$scope.formoutlet3 = 0;
				} else {
					$scope.outletError = false;
					$scope.checkedOutletTypes[2] = $scope.formoutlet3;
				}
			} else {

				if ($scope.formoutlet1 && $scope.formoutlet2) {
					$scope.outletError2 = false;
					$scope.checkedOutletTypes.splice(2, 1);
				} else {
					$scope.outletError2 = true;
					$scope.formoutlet3 = 0;
				}
			}
		}
		$scope.selectCuisine1 = function() {
			$scope.form_cuisine2 = true;
			if ($scope.formcuisine1) {
				if ($scope.formcuisine1 == $scope.formcuisine2 || $scope.formcuisine1 == $scope.formcuisine3) {
					$scope.cuisineError = true;
					$scope.cuisineError1 = false;
					$scope.checkedCuisineTypes.splice(0, 1);
					$scope.formcuisine1 = 0;
				} else {
					$scope.cuisineError = false;
					$scope.cuisineError1 = false;
					$scope.checkedCuisineTypes[0] = $scope.formcuisine1;
				}
			} else {
				if ($('#selectC3').is(':visible')) {
					$scope.cuisineError1 = true;
					$('.customErrCls1').css('left', '555px');
				} else {
					$scope.cuisineError1 = true;
					$('.customErrCls1').css('left', '430px');
				}
			}
		}
		$scope.selectCuisine2 = function() {
			$scope.form_cuisine3 = true;
			if ($scope.formcuisine2 && $scope.formcuisine1) {
				if ($scope.formcuisine2 == $scope.formcuisine1 || $scope.formcuisine2 == $scope.formcuisine3) {
					$scope.cuisineError = true;
					$scope.checkedCuisineTypes.splice(1, 1);
					$scope.formcuisine2 = 0;
					$scope.cuisineError2 = false;
				} else {
					$scope.cuisineError = false;
					$scope.checkedCuisineTypes[1] = $scope.formcuisine2;
					$scope.cuisineError2 = false;
				}
			} else {
				$('.customErrCls1').css('left', '555px');
				$scope.cuisineError2 = true;
				if ($scope.formcuisine1) {
					$scope.checkedCuisineTypes.splice(1, 1);
				} else {
					$scope.cuisineError1 = true;
					$scope.formcuisine2 = 0;
					$scope.formcuisine3 = 0;
				}

			}
		}
		$scope.selectCuisine3 = function() {
			if ($scope.formcuisine3 && $scope.formcuisine1 && $scope.formcuisine2) {
				if ($scope.formcuisine3 == $scope.formcuisine1 || $scope.formcuisine3 == $scope.formcuisine2) {
					$scope.cuisineError = true;
					$scope.checkedCuisineTypes.splice(2, 1);
					$scope.formcuisine3 = 0;
					$scope.cuisineError2 = false;
				} else {
					$scope.cuisineError = false;
					$scope.checkedCuisineTypes[2] = $scope.formcuisine3;
				}
			} else {
				if ($scope.formcuisine1) {
					$scope.cuisineError2 = false;
					$scope.checkedCuisineTypes.splice(2, 1);
				} else {
					$scope.cuisineError2 = true;
					$scope.formcuisine3 = 0;
				}
			}
		}
		$scope.disableOutlet = function($event) {
			$scope.auth_token = getCookie('authToken');
			checkbox = $event.target;
			var params = {
				"outlet" : {
					"disabled" : checkbox.checked
				},
				"auth_token" : $scope.auth_token
			}
			$http({
				method : 'PUT',
				url : '/api/outlets/' + $scope.outletID,
				data : params,
			}).success(function(data, status) {
				console.log("data in success " + data + " status " + status);

				$scope.error = data.auth_token;
				$scope.statement = true;
				$scope.erromsg = false;
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
				$scope.erromsg = true;
			});
		};
		/* Adding for creating the outlet*/
		$scope.create_outlet = function(createOutlet) {
			if ($scope.createOutlet.$valid && $(".phoneno_1").val()) {
				$scope.valide_phone = false;
				$scope.cuisineError = false;
				$scope.cuisineError1 = false;
				$scope.cuisineError2 = false;
				$scope.outletError = false;
				$scope.outletError1 = false;
				$scope.outletError2 = false;
				var url = "/api/outlets"
				var method = "post"
				if ($scope.updateMode) {
					url = "/api/outlets/" + $scope.outletID;

					method = "PUT";
				}

				var param = {
					"outlet" : {
						"name" : $scope.restaurant_name,
						"address" : $scope.restaurant_location,
						"website_url" : "http://batmansdonuts.com",
						"email" : $scope.email_address,
						"phone_number" : $(".phoneno_1").val(),
						"manager_id" : managerId,
						"open_hours" : $scope.fromTime + "-" + $scope.toTime,
						"has_delivery" : $scope.Delivery,
						"serves_alcohol" : $scope.serves_alcohol,
						"has_outdoor_seating" : $scope.outdoor_Seating,
						"cuisine_type_ids" : $scope.checkedCuisineTypes,
						"outlet_type_ids" : $scope.checkedOutletTypes
					},
					"auth_token" : $scope.auth_token
				}

				$http({
					method : method,
					url : url,
					data : param,
				}).success(function(data, status) {
					console.log("data in success hi " + data + " status " + status);
					$scope.error = false;
					console.log($scope.checkedOutletTypes);
					setCookie('currentOutletList', JSON.stringify($scope.checkedOutletTypes), 1);
					setCookie('currentCuisineList', JSON.stringify($scope.checkedCuisineTypes), 1);
					setCookie('radiobtn1', $scope.Delivery, 1);
					setCookie('radiobtn2', $scope.serves_alcohol, 1);
					setCookie('radiobtn3', $scope.outdoor_Seating, 1);
					$scope.$broadcast('clickMessageFromParent', {
						data : "SOME msg to the child"
					})
					if (data.outlet) {
						$scope.outletID = data.outlet.id;
						setCookie('currentOutlet', data.outlet.id, 1);

						$scope.updateMode = true;
						$('#location').css({
							'opacity' : '1'
						});
					}
					$scope.successMsg = true;
					//$scope.profileShow = false;
					$scope.successoutlet = true;
					$('#location').css({
						'opacity' : '1'
					});
				}).error(function(data, status) {
					console.log("data in error" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					$scope.errormsg = data.errors[0];
					$scope.error = true;
					$scope.successoutlet = false;
				});
			} else {
				$scope.error = true;
				$scope.valide_phone = true;
			}

		};

		$scope.create_tablet_id = function() {
			$scope.password_changed = "";
			$scope.staff_deleted = "";
			$scope.errorMsg = "";
			$('.tabletId').show();
			$('.changePass_tablet').hide();
			$scope.successTabletId = false;
			$scope.errorTabletId = false;
		};
		$scope.close_tabletId = function() {
			$('.tabletId').hide();
			$('#tabletIdForm')[0].reset();
			$scope.successTabletId = false;
			$scope.errorTabletId = false;
		};

		$scope.listTabletIds = function() {
			var param = {
				"auth_token" : getCookie('authToken'),
				"outlet_id" : $routeParams.outletId
			}
			$http({
				method : 'get',
				url : '/api/staffs',
				params : param,
			}).success(function(data, status) {
				console.log("data in success " + data + " status " + status);
				$scope.listTabIds = data.staffs;
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		};
		$scope.listTabletIds();

		$scope.create_tabletId = function(createTabletId) {
			if ($scope.createTabletId.$valid && $("#txt").val()) {
				//alert("in submit");
				$('#tabBtn').addClass("tabletBtn1");

				$('.tabletBtn1').show();
				$('.tabletBtn2').hide();
				var param = {
					"user" : {
						"password" : $scope.tabletId_password,
						"password_confirmation" : $scope.tabletId_confirm_password,
						"outlet_id" : $routeParams.outletId
					},
					"auth_token" : getCookie('authToken')
				}

				console.log("outlet id " + $routeParams.outletId);

				$http({
					method : 'post',
					url : '/api/staffs',
					data : param,
				}).success(function(data, status) {
					console.log("data in success " + data + " status " + status);
					$scope.listTabletIds();
					$scope.errorTabletId = false;
					$scope.successTabletId = true;
					$('#tabletIdForm')[0].reset();
					$("#txt").val("");

				}).error(function(data, status) {
					console.log("data in error" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					$('#tabletIdForm')[0].reset();
					$scope.errorMsg = data.errors[0];

					$scope.errorTabletId = true;
					$scope.successTabletId = false;
				});
			}
		};

		$scope.DeleteStaff = function(staffId) {
			//alert(managerId);
			var param = {
				"auth_token" : getCookie('authToken')
			};
			$http({
				method : 'delete',
				url : '/api/staffs/' + staffId,
				params : param,
			}).success(function(data, status) {
				console.log("Data in success " + data + " status " + status);
				$scope.staff_deleted = "Tablet has been deleted successfully"
				$scope.listTabletIds();
			}).error(function(data, status) {
				console.log("data in error " + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		};

		$scope.change_tablet_pass = function(tabletId) {
			$scope.tabletId = tabletId;
			$scope.successTabletId = false;
			$scope.errorTabletId = false;
			$scope.errorMsg = "";
			$('.tabletId').hide();
			$('.changePass_tablet').show();
			$scope.successTabletId = false;
			$scope.errorTabletId = false;
		};
		$scope.close_change_tablet_pass = function() {
			$('.changePass_tablet').hide();
			$('#passwordChange')[0].reset();
			$scope.successTabletId = false;
			$scope.errorTabletId = false;
		};

		$scope.Change_password = function(changePass) {
			if ($scope.changePass.$valid && $("#txtP").val()) {
				var param = {
					"staff" : {
						"password" : $scope.password,
						"password_confirmation" : $scope.password_confirmation
					},
					"auth_token" : getCookie('authToken')
				};
				$http({
					method : 'PUT',
					url : '/api/staffs/' + $scope.tabletId,
					data : param,
				}).success(function(data, status) {
					console.log("Data in success " + data + " status " + status);
					$('#passwordChange')[0].reset();
					$scope.errorMsg = "";
					$("#txtP").val("");
					$scope.password_changed = "Password has been changed successfully."
					$scope.listTabletIds();
				}).error(function(data, status) {
					// $('#passwordChange')[0].reset();
					if (status == 401) {
						$location.url("/login");
					}
					$scope.password_changed = "";
					$scope.errorMsg = data.errors[0];
					console.log("data in error " + data + " status " + status);
				});
			}
		};

		/**Start Outlet Manager Functionality**/
		if ($location.path() == "/outlet_manager") {
			$rootScope.header = "Outlet Manager | Kanari";
			$('.navBarCls ul li').removeClass('active');
			$('#account').addClass('active');
		}

		$scope.add_new_manager = function() {
			$('.add_manager').show();
			$('.edit_manager').hide();
			$scope.manager_deleted = "";
		}
		$scope.close_manager = function() {
			$('.add_manager').hide();
		}
		$scope.close_updatemanager = function() {
			$('.edit_manager').hide();
		}
		$scope.master = {};
		$scope.create_manager = function(createManager) {
			if ($scope.createManager.$valid && $(".phoneno_3").val()) {
				$scope.valide_phone = false;
				var param = {
					"user" : {
						"email" : $scope.email_address_manager1,
						"first_name" : $scope.first_name1,
						"last_name" : $scope.last_name1,
						"phone_number" : $(".phoneno_3").val(),
						"password" : $scope.password,
						"password_confirmation" : $scope.confirmpassword
					},
					"auth_token" : getCookie('authToken')
				}

				$http({
					method : 'post',
					url : '/api/managers',
					data : param,
				}).success(function(data, status) {
					console.log("data in success " + data + " status " + status);
					$scope.error = false;
					$scope.manager_id = data.manager.id;
					$scope.success1 = true;
					$scope.getManagerList();
					$('#formid')[0].reset();
				}).error(function(data, status) {
					console.log("data in error" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					$scope.errorMsg = data.errors[0];
					if ($scope.errorMsg == "Email has already been taken") {
						$scope.errorMsg = "This email address is already being used by a manager.";
					}
					$scope.error = true;
					$scope.success1 = false;
				});
			} else {
				$scope.valide_phone = true;
				$scope.success1 = false;
			}
		};

		$scope.DeleteManager = function(managerId) {
			var param = {
				"auth_token" : getCookie('authToken')
			};
			$http({
				method : 'delete',
				url : '/api/managers/' + managerId,
				params : param,
			}).success(function(data, status) {
				console.log("Data in success " + data + " status " + status);
				$scope.manager_deleted = "Manager has been deleted successfully";
				$scope.getManagerList();
				$('#editManager')[0].reset();
				$('.edit_manager').hide();

			}).error(function(data, status) {
				console.log("data in error " + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		};

		$scope.getManager = function(managerId) {
			$('.add_manager').hide();
			$('.edit_manager').show();
			$('#formid')[0].reset();
			$scope.valide_phone = false;
			$scope.errorMsg = "";
			$scope.success1 = false;
			$scope.manager_deleted = "";
			$scope.manager_updated = "";
			var param = {
				"auth_token" : $scope.auth_token
			}
			$http({
				method : 'get',
				url : '/api/managers/' + managerId,
				params : param,
			}).success(function(data, status) {
				console.log("data in success " + data + " status " + status);
				$('.edit_manager').show();
				$scope.manager_ID = data.manager.id;
				$scope.first_name = data.manager.first_name;
				$scope.last_name = data.manager.last_name;
				$scope.email_address_manager = data.manager.email;
				$(".phoneno_2").val(data.manager.phone_number);
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		};

		$scope.updateManager = function(editManager) {
			if ($scope.editManager.$valid && $(".phoneno_2").val()) {
				$scope.valide_phone = false;
				var param = {
					"manager" : {
						"first_name" : $scope.first_name,
						"last_name" : $scope.last_name,
						"phone_number" : $(".phoneno_2").val()
					},
					"auth_token" : $scope.auth_token
				}
				$http({
					method : 'put',
					url : '/api/managers/' + $scope.manager_ID,
					data : param,
				}).success(function(data, status) {
					console.log("data in success " + data + " status " + status);
					$scope.manager_updated = "Manager has been updated successfully";
					$scope.getManagerList();
				}).error(function(data, status) {
					console.log("data in error" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
				});
			} else {
				console.log("here");
				$scope.manager_updated = "";
				$scope.valide_phone = true;
			}
		};
		/**End Outlet Manager Functionality**/

		$scope.changeTab = function(currentTab) {
			$scope.staff_deleted = "";
			if ($scope.updateMode) {
				if (currentTab == "profileShow") {
					$('#viewmap').hide();
					$('#hidemap').show();
					$scope.profileShow = true;
					$scope.locationShow = false;
					$scope.TabletIdShow = false;
					$scope.permissionShow = false;
					$scope.successMsg = false;
					$scope.ReportShow = false;
					$(".customErr").css("display", "none");
					$('#formid')[0].reset();
					//$(".input-help").css("display","none");
				} else if (currentTab == "locationShow") {
					$('#viewmap').show();
					$('#hidemap').hide();
					$scope.$broadcast('clickMessageFromParent', {
						data : "SOME msg to the child"
					})
					$scope.profileShow = false;
					$scope.locationShow = true;
					$scope.TabletIdShow = false;
					$scope.permissionShow = false;
					$scope.ReportShow = false;
					$(".customErr").css("display", "none");
					//$(".input-help").css("display","none");
				} else if (currentTab == "permissionShow") {
					$('#viewmap').hide();
					$('#hidemap').show();
					$scope.profileShow = false;
					$scope.locationShow = false;
					$scope.TabletIdShow = false;
					$scope.permissionShow = true;
					$scope.ReportShow = false;
					$(".customErr").css("display", "none");
					//$(".input-help").css("display","none");
				} else if (currentTab == "ReportShow") {
					$('#viewmap').hide();
					$('#hidemap').show();
					$scope.profileShow = false;
					$scope.locationShow = false;
					$scope.permissionShow = false;
					$scope.TabletIdShow = false;
					$scope.ReportShow = true;
					$(".customErr").css("display", "none");
					//$(".input-help").css("display","none");
				} else if (currentTab == "TabletIdShow") {
					$('#viewmap').hide();
					$('#hidemap').show();
					$('.tabletId').hide();
					$scope.listTabletIds();
					$scope.profileShow = false;
					$scope.locationShow = false;
					$scope.permissionShow = false;
					$scope.ReportShow = false;
					$scope.TabletIdShow = true;
					$(".customErr").css("display", "none");
					//$(".input-help").css("display","none");
				}
			}
		}
	} else {
		$location.url("/login");
	}
});

module.controller('outletManagerCtrl', function($rootScope, $scope, $routeParams, $http, $location) {
	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.navBarCls').show();
		$('#dasboard').hide();
		$('#adminConsole').hide();
		$('#accountm').show();
		$('.navBarCls ul li').removeClass('active');
		$('#accountm').addClass('active');
		$('#dasboardCustomer').show();
		$rootScope.header = "Outlet Manager | Kanari";

		var manager_id = getCookie('userId');

		var param = {
			"auth_token" : getCookie('authToken')
		}
		$http({
			method : 'get',
			url : 'api/users',
			params : param,
		}).success(function(data, status) {
			console.log("data in success " + data + " status " + status);
			$('.edit_manager').show();
			$scope.manager_ID = data.user.id;
			$scope.first_name = data.user.first_name;
			$scope.last_name = data.user.last_name;
			$scope.email_address_manager = data.user.email;
			$(".phoneno_2").val(data.user.phone_number);
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);
			if (status == 401) {
				$location.url("/login");
			}
		});

		$scope.update_Manager = function(updateManager) {
			if ($scope.editManager.$valid && $(".phoneno_2").val()) {

				$scope.valide_phone = false;
				var param = {
					"user" : {
						"first_name" : $scope.first_name,
						"last_name" : $scope.last_name,
						"phone_number" : $(".phoneno_2").val()
					},
					"auth_token" : getCookie('authToken')
				}
				$http({
					method : 'put',
					url : '/api/users/',
					data : param,
				}).success(function(data, status) {
					console.log("data in success " + data + " status " + status);
					setCookie('authToken', data.auth_token, 1);
					$scope.manager_updated = "Manager has been updated successfully";
				}).error(function(data, status) {
					console.log("data in error" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
				});
			} else {
				console.log("here");
				$scope.manager_updated = "";
				$scope.valide_phone = true;
			}
		};

		$scope.goback = function() {
			$location.url("/outlets");
		}
	}
});

module.controller('acceptInvitationCtrl', function($rootScope, $scope, $routeParams, $http, $location) {
	$scope.validateForm = function() {
		if ($scope.password || $scope.password_confirmation || $scope.first_name || $scope.last_name) {
			return true;
		} else {
			return false;
		}
	};
	$rootScope.header = "Accept Invitation | Kanari";
	$http({
		method : 'get',
		url : '/api/users/invitation/' + $routeParams.invi_token,
	}).success(function(data, status) {
		console.log("data in success " + data + " status " + status);
		$scope.emailId = data.email;

	}).error(function(data, status) {
		console.log("data in error" + data + " status " + status);
		if (status == 401) {
			$location.url("/login");
		}

	});
	$scope.acceptInvitation = function(acceptInv) {
		if ($scope.acceptInv.$valid && $(".phoneno_1").val()) {
			$scope.valide_phone = false;
			var param = {
				"user" : {
					"password" : $scope.password,
					"password_confirmation" : $scope.password_confirmation,
					"first_name" : $scope.first_name,
					"last_name" : $scope.last_name,
					"phone_number" : $(".phoneno_1").val(),
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
				if (status == 401) {
					$location.url("/login");
				}
				$scope.errorMsg = data.errors[0];
				$scope.error = true;
				$scope.success = false;
			});
		} else {
			$scope.errorClient = true;
			$scope.success = false;
			$scope.valide_phone = true;
		}
	}
});
module.controller('acceptInvitation2Ctrl', function($rootScope, $scope, $routeParams, $http, $location) {
	if (getCookie('authToken')) {
		$rootScope.header = "Accept Invitation | Kanari";
		if (getCookie('userRole') == "customer_admin") {
			$('.welcome').show();
		}
		$scope.auth_token = getCookie('authToken');
		$scope.acceptInvitation2 = function(acceptInv2) {
			if ($scope.acceptInv2.$valid && $(".phoneno_1").val()) {
				$scope.valide_phone = false;
				console.log("city" + $scope.registered_address_city + "country " + $scope.registered_address_country);
				var param = {
					"customer" : {
						"name" : $scope.name,
						"phone_number" : $(".phoneno_1").val(),
						"registered_address_line_1" : $scope.registered_address_line_1,
						"registered_address_line_2" : $scope.registered_address_line_2,
						"registered_address_city" : "Dubai",
						"registered_address_country" : "UAE",
						"mailing_address_line_1" : $scope.mailing_address_line_1,
						"mailing_address_line_2" : $scope.mailing_address_line_2,
						"mailing_address_city" : "Dubai",
						"mailing_address_country" : "UAE",
						"email" : $scope.email
					},
					"auth_token" : $scope.auth_token

				}

				$http({
					method : 'post',
					url : '/api/customers',
					data : param,
				}).success(function(data, status) {
					console.log("data in success " + data + " status " + status);
					$scope.error = false;
					if (acceptInvitationStep2 == true) {
						$location.url("/outlets");
					} else {
						$scope.success = true;
					}
				}).error(function(data, status) {
					console.log("data in error" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					$scope.errorMsg = data.errors[0];
					$scope.error = true;
					$scope.success = false;
				});

			} else {
				$scope.valide_phone = true;
			}
		}
	} else {
		$location.url("/login");
	}
});

module.controller('viewaccountCtrl', function($rootScope, $scope, $http, $location) {
	if (getCookie('authToken')) {
		$rootScope.header = "Settings | Kanari";
		$('.welcome').show();
		$('.navBarCls').show();
		$('.navBarCls ul li').removeClass('active');
		$('#dasboard').hide();
		$('#adminConsole').hide();
		$('#account').addClass('active');
		$('#dasboardCustomer').show();

		$scope.success = false;
		var customer_id = getCookie('userId');

		var param = {
			"auth_token" : getCookie('authToken')
		}

		$http({
			method : 'get',
			url : '/api/customers/' + customer_id,
			params : param,
		}).success(function(data, status) {
			console.log("data in success " + data + " status " + status);
			$scope.first_name = data.customer.customer_admin.first_name;
			$scope.last_name = data.customer.customer_admin.last_name;
			$scope.email = data.customer.customer_admin.email;
			$(".phoneno_1").val(data.customer.customer_admin.phone_number);
			$scope.compnyNm = data.customer.name;
			$(".phoneno_2").val(data.customer.phone_number);
			$scope.add1 = data.customer.registered_address_line_1;
			$scope.add2 = data.customer.registered_address_line_2;
			$scope.city = "Dubai";
			$scope.country = "UAE";
			$scope.mailadd1 = data.customer.mailing_address_line_1;
			$scope.mailadd2 = data.customer.mailing_address_line_2;
			$scope.mailcity = "Dubai";
			$scope.mailcountry = "UAE";
			$scope.emailAdd = data.customer.email;
		}).error(function(data, status) {
			console.log("data in error" + data + " status " + status);
			if (status == 401) {
				$location.url("/login");
			}

		});

		$scope.view_account = function(viewAcc) {
			if ($scope.viewAcc.$valid && $(".phoneno_2").val()) {
				$scope.valide_phone = false;
				var param = {
					"customer" : {
						"name" : $scope.compnyNm,
						"email" : $scope.email,
						"registered_address_line_1" : $scope.add1,
						"registered_address_line_2" : $scope.add2,
						"registered_address_city" : "Dubai",
						"registered_address_country" : "UAE",
						"phone_number" : $(".phoneno_2").val(),
						"mailing_address_line_1" : $scope.mailadd1,
						"mailing_address_line_2" : $scope.mailadd2,
						"mailing_address_city" : "Dubai",
						"mailing_address_country" : "UAE",
						"email" : $scope.emailAdd
					},
					"auth_token" : getCookie('authToken')
				}

				$http({
					method : 'put',
					url : '/api/customers/' + customer_id,
					data : param,
				}).success(function(data, status) {
					console.log("data in success " + data + " status " + status);
					//	$scope.success = true;

				}).error(function(data, status) {
					console.log("data in error" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					//$scope.success = false;
				});
				var param2 = {
					"user" : {
						"first_name" : $scope.first_name,
						"last_name" : $scope.last_name,
						"phone_number" : $(".phoneno_1").val(),
						"current_password" : $scope.password
					},
					"auth_token" : getCookie('authToken')
				}
				console.log($scope.phoneno_1);
				$http({
					method : 'put',
					url : '/api/users/',
					data : param2,
				}).success(function(data, status) {
					console.log("data in success " + data + " status " + status);
					setCookie('authToken', data.auth_token, 7);
					$scope.success = true;
					$scope.error = false;

				}).error(function(data, status) {
					console.log("data in errorrr" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					$scope.success = false;
					$scope.error = true;
					$scope.errormsg = data.errors[0];
				});

			} else {
				console.log("here");
				$scope.success = false;
				$scope.valide_phone = true;
			}
		}
		$scope.gotoChangePassword = function() {
			$location.url("/change_password");
		}
		$scope.goback = function() {
			$location.url("/outlets");
		}
	}
});
module.controller('changePassCtrl', function($rootScope, $scope, $routeParams, $route, $http, $location) {
	if (getCookie('authToken')) {
		$rootScope.header = "Change Password | Kanari";
		$('.welcome').show();
		$('.navBarCls').show();
		$('.navBarCls ul li').removeClass('active');
		$('#dasboard').hide();
		$('#adminConsole').hide();
		$('#account').addClass('active');
		$('#dasboardCustomer').show();

		$scope.success = false;
		$scope.error = false;

		$scope.BackLink = function() {
			$location.url("/view_account");
		};

		$scope.changePassword = function(changePass) {
			if ($scope.changePass.$valid) {
				var param2 = {
					"user" : {
						"password" : $scope.password,
						"password_confirmation" : $scope.password_confirmation,
						"current_password" : $scope.old_password
					},
					"auth_token" : getCookie('authToken')
				}
				$http({
					method : 'put',
					url : '/api/users/',
					data : param2,
				}).success(function(data, status) {
					console.log("data in success " + data + " status " + status);
					setCookie('authToken', data.auth_token, 7);
					$scope.success = true;
					$scope.error = false;

				}).error(function(data, status) {
					console.log("data in errorrr" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					$scope.success = false;
					$scope.error = true;
					$scope.errormsg = data.errors[0];
				});

			} else {
				$scope.success = false;
			}
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

module.controller('createKanariCodeCtrl', function($scope, $routeParams, $route, $http, $location) {
	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.navBarCls').show();
		$('.navBarCls ul li').removeClass('active');
		$('#dasboard').hide();
		$('#adminConsole').hide();
		$('#dasboardCustomer').show();
		$('#account').addClass('active');
		$('.dashboardLi').hide();

		$scope.success = false;
		$scope.error = false;
	} else {
		$location.url("/login");
	}
	$scope.create_kanariCode = function(createKanariCode) {
		if ($scope.createKanariCode.$valid) {
			var param = {
				"bill_amount" : $scope.bill_amount
			}

			$http({
				method : 'POST',
				url : '/api/kanari_codes',
				data : param,
			}).success(function(data, status) {
				console.log("data in success " + data + " status " + status);

			}).error(function(data, status) {
				console.log("data in errorr" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}

			});
		}
	};

});

module.controller('outletCuisineTypeCtrl', function($scope, $rootScope, $routeParams, $route, $http, $location) {
	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.navBarCls').show();
		$('.navBarCls ul li').removeClass('active');
		$('#outlet').hide();
		$('#account').hide();
		$('#adminConsole').show();
		$('#dasboard').addClass('active');
		$('#dasboardCustomer').hide();
		$rootScope.header = "Add Outlet/Cuiseine Type | Kanari";
		$scope.outletTypes = [];
		$scope.updateOMode = false;
		$scope.updateCMode = false;
		$scope.updateMode1 = false;
		$scope.updateMode2 = false;
		$scope.cuisineTypes = [];
		$scope.getOutletTypes = function() {

			var param = {
				"auth_token" : getCookie('authToken')
			}
			$http({
				method : 'get',
				url : '/api/outlet_types',
				params : param,
			}).success(function(data, status) {
				$scope.error = false;
				$scope.outletTypes = data.outlet_types;
				$scope.success = true;

			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
				$scope.error = true;
				$scope.success = false;
			});
		};
		$scope.getOutletTypes();
		$scope.getCuisineTypes = function() {
			var param = {
				"auth_token" : getCookie('authToken')
			}
			$http({
				method : 'get',
				url : '/api/cuisine_types',
				params : param,
			}).success(function(data, status) {
				$scope.error = false;
				$scope.cuisineTypes = data.cuisine_types;
				$scope.success = true;

			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
				$scope.error = true;
				$scope.success = false;
			});
		};
		$scope.getCuisineTypes();

		$scope.updateOutletType = function(opt) {
			var opt_text = $("#list option[value='" + opt + "']").text();
			if ($scope.formoutlet1) {
				$('.updateBtn').show();
				$('.saveBtn').hide();
				$scope.outletSuccess = false;
				$scope.updateMode1 = true;
				$scope.outlet_types = opt_text;
			} else {
				$('.saveBtn').show();
				$('.updateBtn').hide();
				$scope.updateMode1 = false;
				$scope.outlet_types = "";
			}
		}

		$scope.add_outlet_type = function(outlet_type) {
			$scope.updateOMode = false;
			if ($scope.outlet_type.$valid) {
				var url = "/api/outlet_types"
				var method = "post"
				if ($scope.updateMode1) {
					if ($scope.formoutlet1) {
						url = "/api/outlet_types/" + $scope.formoutlet1;
						method = "PUT";
						$scope.updateOMode = true;
					}

				} else {
					$scope.updateOMode = false;
				}
				var param = {
					"outlet_type" : {
						"name" : $scope.outlet_types
					},
					"auth_token" : getCookie('authToken')
				}

				$http({
					method : method,
					url : url,
					data : param,
				}).success(function(data, status) {
					console.log("data in success " + data + " status " + status);
					$scope.outletSuccess = true;
					$scope.getOutletTypes();
					$('.saveBtn').show();
					$('.updateBtn').hide();
					$scope.formoutlet1 = "";
					$scope.outlet_deleted = "";
					$scope.outlet_types = "";

				}).error(function(data, status) {
					console.log("data in errorrr" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					$scope.outletSuccess = false;
				});

			}
		};
		$scope.deleteOutletType = function() {
			var param = {
				"auth_token" : getCookie('authToken')
			};
			$http({
				method : 'delete',
				url : '/api/outlet_types/' + $scope.formoutlet1,
				params : param,
			}).success(function(data, status) {
				console.log("Data in success " + data + " status " + status);
				$scope.outlet_deleted = "Outlet type has been deleted successfully"
				$scope.getOutletTypes();
				$('.saveBtn').show();
				$('.updateBtn').hide();
				$scope.outlet_types = "";
			}).error(function(data, status) {
				console.log("data in error " + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		}
		$scope.updateCuisineType = function(optU) {
			var optu_text = $("#Clist option[value='" + optU + "']").text();
			if ($scope.formcuisine1) {
				$('.updateCBtn').show();
				$('.saveCBtn').hide();
				$scope.cuisineSuccess = false;
				$scope.updateMode2 = true;
				$scope.cuisine_types = optu_text;
			} else {
				$('.saveCBtn').show();
				$('.updateCBtn').hide();
				$scope.updateMode2 = false;
				$scope.cuisine_types = "";
			}
		}

		$scope.add_cuisine_type = function(cuisine_type) {
			if ($scope.cuisine_type.$valid) {
				$scope.updateCMode = false;
				var url = "/api/cuisine_types"
				var method = "post"
				if ($scope.updateMode2) {
					if ($scope.formcuisine1) {
						url = "/api/cuisine_types/" + $scope.formcuisine1;
						method = "PUT";
						$scope.updateCMode = true;
					}
				} else {
					$scope.updateCMode = false;
				}
				var param = {
					"outlet_type" : {
						"name" : $scope.outlet_types
					},
					"auth_token" : getCookie('authToken')
				}

				var param = {
					"cuisine_type" : {
						"name" : $scope.cuisine_types
					},
					"auth_token" : getCookie('authToken')
				}

				$http({
					method : method,
					url : url,
					data : param,
				}).success(function(data, status) {
					console.log("data in success " + data + " status " + status);
					$scope.cuisineSuccess = true;
					$scope.getCuisineTypes();
					$('.saveCBtn').show();
					$scope.cuisine_deleted = "";
					$('.updateCBtn').hide();
					$scope.formcuisine1 = "";
					$scope.cuisine_types = "";

				}).error(function(data, status) {
					console.log("data in errorrr" + data + " status " + status);
					if (status == 401) {
						$location.url("/login");
					}
					$scope.cuisineSuccess = false;
				});

			}
		};
		$scope.deleteCuisineType = function() {
			var param = {
				"auth_token" : getCookie('authToken')
			};
			$http({
				method : 'delete',
				url : '/api/cuisine_types/' + $scope.formcuisine1,
				params : param,
			}).success(function(data, status) {
				console.log("Data in success " + data + " status " + status);
				$scope.cuisine_deleted = "Cuisine type has been deleted successfully"
				$scope.getCuisineTypes();
				$('.saveCBtn').show();
				$('.updateCBtn').hide();
				$scope.cuisine_types = "";
			}).error(function(data, status) {
				console.log("data in error " + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		}
	} else {
		$location.url("/login");
	}
});

module.controller('paymentHistoryCtrl', function($scope, $rootScope, $routeParams, $route, $http, $location) {
	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.navBarCls').show();
		$('.navBarCls ul li').removeClass('active');
		$('#outlet').show();
		$('#dasboard').hide();
		$('#adminConsole').hide();
		$('#dasboardCustomer').show();
		$('#account').addClass('active');
		$('.dashboardLi').hide();

		$rootScope.header = "Payment History | Kanari";
		$scope.paymentHistoryList = [];

		$(function() {
			$('#payDate1').datepicker().on('changeDate', function(ev) {
				var dt = new Date(ev.date.valueOf());
				var month = dt.getMonth() + 1;
				startDt = dt.getFullYear() + "-" + month + "-" + dt.getDate();
				if (startDt != 'undefined' && typeof endDt != 'undefined') {
					console.log("hi in start date");
					$scope.listPaymentHistory();
					$(".outletDropDown").change(function() {
						$scope.listPaymentHistory();
					});
				}
			});
			$('#payDate2').datepicker().on('changeDate', function(ev) {
				var dt = new Date(ev.date.valueOf());
				var month = dt.getMonth() + 1;
				endDt = dt.getFullYear() + "-" + month + "-" + dt.getDate();
				if ( typeof startDt != 'undefined' && endDt != 'undefined') {
					console.log("hi in end date");
					$scope.listPaymentHistory();
					$(".outletDropDown").change(function() {
						$scope.listPaymentHistory();
					});
				}
			});
		});
		$scope.paymentHistoryList = [];
		$scope.listPaymentHistory = function() {
			var outletId = $scope.outletOption;
			if (startDt != "" && endDt != "") {
				var param = {
					"auth_token" : getCookie('authToken'),
					"password" : 'X',
					"start_time" : startDt,
					"end_time" : endDt
				};
			} else {
				var param = {
					"auth_token" : getCookie('authToken'),
					"password" : 'X',
				};
			}
			$http({
				method : 'get',
				url : '/api/payment_invoices',
				params : param,
			}).success(function(data, status) {
				console.log("Data in success " + data + " status " + status);
				$scope.paymentHistoryList = [];
				$scope.paymentHistoryList = data.payment_invoices;
				var arrayLength = data.payment_invoices.length;
				for (var i = 0; i < arrayLength; i++) {
					if (data.payment_invoices[i].outlet_id) {
						$scope.getOutlet(data.payment_invoices[i].outlet_id, i)
					}
				}
				//console.log($scope.outletList);
			}).error(function(data, status) {
				console.log("data in error " + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		};

		$scope.getOutlet = function(outletId, payInNo) {

			var param = {
				"auth_token" : getCookie('authToken'),
				"password" : 'X',
			};

			$http({
				method : 'get',
				url : '/api/outlets/' + outletId,
				params : param,
			}).success(function(data, status) {
				console.log("Data in success " + data + " status " + status);
				console.log(payInNo);
				$scope.paymentHistoryList[payInNo].outlet_id = data.outlet.name;
				console.log($scope.paymentHistoryList);
			}).error(function(data, status) {
				console.log("data in error " + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		}

		$scope.listPaymentHistory();
	} else {
		$location.url("/login");
	}
});

var startDt;
var endDt;
module.controller('dashboardCommentsCtrl', function($scope, $rootScope, $routeParams, $route, $http, $location) {
	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.hideNav').hide();
		$('.showNav').show();
		$('.navBarCls ul li').removeClass('active');
		$('#adminConsole').hide();
		$('#comments').addClass('active');
		$rootScope.header = "Dashboard Comments | Kanari";
		$scope.feedbackList = [];
		$scope.outletNameList = [];

		var outerDivHeight = $("body").height();
		//alert(outerDivHeight);
		$(".home_page_view").height(outerDivHeight - 170);

		if ($routeParams.outletId) {
			$scope.addOutletId = true;
			$scope.addOutletNo = $routeParams.outletId;
			$scope.outletOption = $routeParams.outletId;
		} else {
			$scope.addOutletId = false;
		}

		$scope.v = {
			Dt : Date.now()
		}

		$("#dp3 .add-on").click(function() {
			$('.datepicker').addClass("addLeft");
		});

		$("#dp2 .add-on").click(function() {
			$('.datepicker').removeClass("addLeft");
		});

		$(function() {
			$('#dp2').datepicker().on('changeDate', function(ev) {
				var dt = new Date(ev.date.valueOf());
				var month = dt.getMonth() + 1;
				startDt = dt.getFullYear() + "-" + month + "-" + dt.getDate();
				if (startDt != 'undefined' && typeof endDt != 'undefined') {
					console.log("hi in start date");
					$scope.listFeedbacksDate();
					$(".outletDropDown").change(function() {
						$scope.listFeedbacksDate();
					});
				}
			});
			$('#dp3').datepicker().on('changeDate', function(ev) {
				var dt = new Date(ev.date.valueOf());
				var month = dt.getMonth() + 1;
				endDt = dt.getFullYear() + "-" + month + "-" + dt.getDate();
				if ( typeof startDt != 'undefined' && endDt != 'undefined') {
					console.log("hi in end date");
					$scope.listFeedbacksDate();
					$(".outletDropDown").change(function() {
						$scope.listFeedbacksDate();
					});
				}
			});
		});

		$scope.listOutletNames = function() {
			var param = {
				"auth_token" : getCookie('authToken'),
				"password" : 'X',
			};
			$http({
				method : 'get',
				url : '/api/outlets',
				params : param,
			}).success(function(data, status) {
				console.log("Data in success " + data + " status " + status);
				$scope.outletNameList = data.outlets;
				if ($routeParams.outletId) {
					$scope.outletOption = parseInt($routeParams.outletId);
				}
			}).error(function(data, status) {
				console.log("data in error " + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		};
		$scope.listOutletNames();

		var outletId = $scope.outletOption;
		$scope.listFeedbacksDate = function() {
			console.log("outetId " + $scope.outletOption);
			var param = {
				"auth_token" : getCookie('authToken'),
				"password" : "X",
				"outlet_id" : $scope.outletOption,
				"start_time" : startDt,
				"end_time" : endDt
			}

			$http({
				method : 'get',
				url : '/api/feedbacks',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				$scope.feedbackList = data.feedbacks;
				console.log(data.feedbacks.length);
				if (data.feedbacks.length == 0) {
					$scope.feedBackListCount = true;
				} else {
					$scope.feedBackListCount = false;
				}
			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));
				if (status == 401) {
					$location.url("/login");
				}
			});
		};

		$scope.listFeedbacks = function() {
			//$.mobile.loading('show');
			var param = {
				"auth_token" : getCookie('authToken'),
				"outlet_id" : $scope.outletOption,
				"password" : "X"
			}

			$http({
				method : 'get',
				url : '/api/feedbacks',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				$scope.feedbackList = data.feedbacks;
				//console.log(data.feedbacks.length);
				if (data.feedbacks.length == 0) {
					$scope.feedBackListCount = true;
				} else {
					$scope.feedBackListCount = false;
				}

			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));
				if (status == 401) {
					$location.url("/login");
				}

			});
		};

		$scope.listFeedbacks();
		$scope.selectOutlet = function() {
			$scope.listFeedbacks();
		}
	} else {
		$location.url("/login");
	}
});

module.controller('dashboardTrendsCtrl', function($scope, $rootScope, $routeParams, $route, $http, $location, limitToFilter) {
	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.hideNav').hide();
		$('.showNav').show();
		$('.navBarCls ul li').removeClass('active');
		$('#adminConsole').hide();
		$('#trends').addClass('active');
		$rootScope.header = "Dashboard Trends | Kanari";
		$scope.outletNameList = [];
		$scope.trendsList = [];
		var results1 = [];
		var results2 = [];
		var results3 = [];
		var resultsDate = [];
		var idV = "";
		var metricsId = "custExp";
		var usageLegend = "";
		var npsBreakdownV = 0;
		var npsOverview = 0;

		if ($routeParams.outletId) {
			//alert("in");
			$scope.addOutletId = true;
			$scope.addOutletNo = $routeParams.outletId;
			$scope.outletTrend = parseInt($routeParams.outletId);
		} else {
			$scope.addOutletId = false;
			//$scope.outletTrend = parseInt($routeParams.outletId);
		}

		$scope.v = {
			Dt : Date.now()
		}

		var d = new Date();

		var month = d.getMonth() + 1;
		var day = d.getDate();

		var currentDate = d.getFullYear() + '-' + (('' + month).length < 2 ? '0' : '') + month + '-' + (('' + day).length < 2 ? '0' : '') + day;

		$scope.chart_subheading = "Food Quality";
		$("#dashboard_trends ul li a").click(function() {
			$('#dashboard_trends ul li a').removeClass("active");
			$(this).addClass("active");
			$scope.chart_subheading = $(this).text();
			idV = $(this).attr("id");
			if (idV == "timeOfVisit") {
				$("#dp3").hide();
				$("#startDt").attr("placeholder", "Select Date");
			} else {
				$("#dp3").show();
				$("#startDt").attr("placeholder", "Start Date");
			}
			$scope.listOfTrendsDate(idV);
		});

		$scope.chart_heading = "Customer Experience";
		$("#dashboard_trends ul").click(function() {
			metricsId = $(this).attr("class");
			if (metricsId == "custExp") {
				$scope.chart_heading = "Customer Experience";
			} else if (metricsId == "netPromo") {
				$scope.chart_heading = "Net Promoter Score";
			} else if (metricsId == "usage") {
				$scope.chart_heading = "Usage";
			} else if (metricsId == "customers") {
				$scope.chart_heading = "Customers";
			}
		});

		$("#dp3 .add-on").click(function() {
			$('.datepicker').addClass("addLeft");
		});

		$("#dp2 .add-on").click(function() {
			$('.datepicker').removeClass("addLeft");
		});

		$(function() {
			$('#dp2').datepicker().on('changeDate', function(ev) {
				var dt = new Date(ev.date.valueOf());
				var month = dt.getMonth() + 1;
				startDt = dt.yyyymmdd();
				if (idV == "timeOfVisit") {
					endDt = startDt;
				}
				if (startDt != 'undefined' && typeof endDt != 'undefined') {
					if ((new Date(startDt).getTime() > new Date(endDt).getTime())) {
						var r = confirm("End Date should be greater than Start Date");
						if (r == true) {

						}
					} else {
						$scope.listOfTrendsDate(idV);
					}
					$(".outletDropDown").change(function() {
						$scope.listOfTrendsDate(idV);
					});
				}
			});
			$('#dp3').datepicker().on('changeDate', function(ev) {
				var dt = new Date(ev.date.valueOf());
				var month = dt.getMonth() + 1;
				endDt = dt.yyyymmdd();
				if ( typeof startDt != 'undefined' && endDt != 'undefined') {
					if ((new Date(startDt).getTime() > new Date(endDt).getTime())) {
						var r = confirm("End Date should be greater than Start Date");
						if (r == true) {

						}
					} else {
						$scope.listOfTrendsDate(idV);
					}
					$(".outletDropDown").change(function() {
						$scope.listOfTrendsDate(idV);
					});
				}
			});
		});

		Date.prototype.yyyymmdd = function() {

			var yyyy = this.getFullYear().toString();
			var mm = (this.getMonth() + 1).toString();
			// getMonth() is zero-based
			var dd = this.getDate().toString();

			return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-' + (dd[1] ? dd : "0" + dd[0]);
		};

		//var outletId = $scope.outletOption;
		$scope.selectOutlet = function() {
			$scope.listOfTrendsDate(idV);
		}

		$scope.listOfTrendsDate = function(idValue) {
			console.log("inFun" + $scope.outletTrend);
			if (!idValue) {
				idValue = "food";
				metricsId = "custExp";
				var param = {
					"auth_token" : getCookie('authToken'),
					"outlet_id" : $scope.outletTrend,
					"start_time" : startDt,
					"end_time" : endDt
				}

			} else if (idValue == "timeOfVisit" && !startDt) {
				var param = {
					"auth_token" : getCookie('authToken'),
					"outlet_id" : $scope.outletTrend,
					"start_time" : currentDate,
					"end_time" : currentDate
				}
			} else if (idValue == "timeOfVisit" && startDt) {
				var param = {
					"auth_token" : getCookie('authToken'),
					"outlet_id" : $scope.outletTrend,
					"start_time" : startDt,
					"end_time" : startDt
				}

			} else {
				var param = {
					"auth_token" : getCookie('authToken'),
					"outlet_id" : $scope.outletTrend,
					"start_time" : startDt,
					"end_time" : endDt
				}
			}

			$http({
				method : 'get',
				url : '/api/feedbacks/trends',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				results1 = [];
				results2 = [];
				results3 = [];
				resultsDate = [];
				var time = [];
				finaltime = [];
				timeOfV = 0;
				npsBreakdownV = 0;
				npsOverview = 0;
				//var timeOfVisit = [];
				$scope.trendsList = data.feedback_trends.detailed_statistics;
				var arrayLength = Object.keys($scope.trendsList).length;
				for (var i = 0; i < arrayLength; i++) {
					dateV = Object.keys($scope.trendsList)[i];
					/** Customer Experience Start**/
					if (idValue == "food") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].food_quality.like;
						var foodNeutral = data.feedback_trends.detailed_statistics[dateV].food_quality.neutral;
						var foodDisLike = data.feedback_trends.detailed_statistics[dateV].food_quality.dislike;
					} else if (idValue == "speed") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].speed_of_service.like;
						var foodNeutral = data.feedback_trends.detailed_statistics[dateV].speed_of_service.neutral;
						var foodDisLike = data.feedback_trends.detailed_statistics[dateV].speed_of_service.dislike;
					} else if (idValue == "friendly") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].friendliness_of_service.like;
						var foodNeutral = data.feedback_trends.detailed_statistics[dateV].friendliness_of_service.neutral;
						var foodDisLike = data.feedback_trends.detailed_statistics[dateV].friendliness_of_service.dislike;
					} else if (idValue == "ambiance") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].ambience.like;
						var foodNeutral = data.feedback_trends.detailed_statistics[dateV].ambience.neutral;
						var foodDisLike = data.feedback_trends.detailed_statistics[dateV].ambience.dislike;
					} else if (idValue == "cleanly") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].cleanliness.like;
						var foodNeutral = data.feedback_trends.detailed_statistics[dateV].cleanliness.neutral;
						var foodDisLike = data.feedback_trends.detailed_statistics[dateV].cleanliness.dislike;
					} else if (idValue == "moneyVal") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].value_for_money.like;
						var foodNeutral = data.feedback_trends.detailed_statistics[dateV].value_for_money.neutral;
						var foodDisLike = data.feedback_trends.detailed_statistics[dateV].value_for_money.dislike;
					}
					/** Customer Experience End**/

					/**Net Promoter Score start**/
					else if (idValue == "npsBreakdown") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].net_promoter_score.like;
						var foodNeutral = data.feedback_trends.detailed_statistics[dateV].net_promoter_score.neutral;
						var foodDisLike = data.feedback_trends.detailed_statistics[dateV].net_promoter_score.dislike;
						npsBreakdownV = 1;
					} else if (idValue == "npsOverview") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].net_promoter_score.like - data.feedback_trends.detailed_statistics[dateV].net_promoter_score.dislike;
						npsOverview = 1;
						usageLegend = "NPS Overview";
					}
					/**Net Promoter Score End**/

					/**Usage start**/
					else if (idValue == "feedbackSubmit") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].usage.feedbacks_count;
						usageLegend = "Feedback count";
					} else if (idValue == "redemProc") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].usage.redemptions_count;
						usageLegend = "Redemption count";
					} else if (idValue == "discountClaim") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].usage.discounts_claimed;
						usageLegend = "Discount claimed ";
					} else if (idValue == "pointsIssued") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].usage.points_issued;
						usageLegend = "Points issued";
					} else if (idValue == "rewardsPool") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].usage.rewards_pool;
						usageLegend = "Reward pool";
					}
					/**Usage end**/

					/**Customers start**/
					else if (idValue == "demographics") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].customers.male;
						var foodDisLike = data.feedback_trends.detailed_statistics[dateV].customers.female;
						custLegend1 = "Male";
						custLegend2 = "Female";
					} else if (idValue == "usersGraph") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].customers.new_users;
						var foodDisLike = data.feedback_trends.detailed_statistics[dateV].customers.returning_users;
						custLegend1 = "New";
						custLegend2 = "Returning";
					} else if (idValue == "timeOfVisit") {
						finaltime = [];
						for (var j = 0; j < 24; j++) {
							time[j] = data.feedback_trends.detailed_statistics[dateV].customers.time_of_visit[j];
							finaltime.push(time[j]);
						}
						timeOfV = 1;
					} else if (idValue == "chequeSize") {
						var foodLike = data.feedback_trends.detailed_statistics[dateV].average_bill_amount;
						npsOverview = 1;
						usageLegend = "Cheque Size";
					}
					/**Customers End**/

					resultsDate.push(i + 1);
					results1.push(foodLike);
					results2.push(foodNeutral);
					results3.push(foodDisLike);
				}
				if (metricsId == "custExp" || npsBreakdownV == "1") {
					getCustExpGraph();
				} else if (metricsId == "usage" || npsOverview == "1") {
					getUsageGraph();
				} else if (metricsId == "customers" && timeOfV == "1") {
					//alert("in");
					getTimeVisitGraph();
				} else if (metricsId == "customers") {
					customerGraph();
				}

			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));
				if (status == 401) {
					$location.url("/login");
				}
			});
		};

		$scope.listOfTrendsDate(idV);
		$scope.listOutletNames = function() {
			var param = {
				"auth_token" : getCookie('authToken'),
				"password" : 'X',
			};
			$http({
				method : 'get',
				url : '/api/outlets',
				params : param,
			}).success(function(data, status) {
				console.log("Data in success " + data + " status " + status);
				$scope.outletNameList = data.outlets;
				if ($routeParams.outletId) {
					$scope.outletTrend = parseInt($routeParams.outletId);
				}
			}).error(function(data, status) {
				console.log("data in error " + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		};
		$scope.listOutletNames();

		function getDaysBetweenDates(d0, d1) {

			var msPerDay = 8.64e7;

			// Copy dates so don't mess them up
			var x0 = new Date(d0);
			var x1 = new Date(d1);

			// Set to noon - avoid DST errors
			x0.setHours(12, 0, 0);
			x1.setHours(12, 0, 0);

			// Round to remove daylight saving errors
			return Math.round((x1 - x0) / msPerDay);
		}

		function incr_date(date_str, no_of_days_to_add) {
			var futureDate = new Date(date_str);

			futureDate.setDate(new Date().getDate() + no_of_days_to_add);
			var next_date_str = futureDate;

			return next_date_str;
		}

		function getCustExpGraph() {
			$('#container').highcharts({

				chart : {
					type : 'column'
				},

				title : {
					text : $scope.chart_heading + ' | Stacked column chart',
					color : '#A08A75',
					style : {
						display : 'none'
					}
				},

				xAxis : {
					categories : resultsDate,
					title : {
						text : 'Days Of week',
						style : {
							color : '#7C7A7D',
						}
					}
				},

				yAxis : {
					allowDecimals : false,
					min : 0,
					title : {
						text : 'Points%',
						style : {
							color : '#7C7A7D',
						}
					}
				},

				tooltip : {
					formatter : function() {
						return '<b>' + this.x + '</b><br/>' + this.series.name + ': ' + this.y + '<br/>' + 'Total: ' + this.point.stackTotal;
					},
				},

				plotOptions : {
					column : {
						stacking : 'normal'
					}
				},
				legend : {
					x : -300,
					backgroundColor : '#fff',
					style : {
						fontColor : '#A08A75'
					}
				},
				series : [{
					name : 'Positive',
					data : results1,
					color : '#D8882F',
				}, {
					name : 'Neutral',
					data : results2,
					color : '#3A240D'
				}, {
					name : 'Negative',
					data : results3,
					color : '#664766'
				}]
			});
		}

		function getUsageGraph() {
			$('#container').highcharts({
				chart : {
					type : 'column'
				},
				title : {
					text : $scope.chart_heading + ' | Stacked column chart',
					color : '#A08A75',
					style : {
						display : 'none'
					}
				},
				xAxis : {
					categories : resultsDate,
					labels : {
						align : 'right',
						style : {
							fontSize : '13px',
							fontFamily : 'Verdana, sans-serif'
						}
					},
					title : {
						text : 'Days Of week',
						style : {
							color : '#7C7A7D',
						}
					}
				},
				yAxis : {

					title : {
						text : 'Points%',
						style : {
							color : '#7C7A7D',
						}
					}
				},
				legend : {
					x : -350,
					backgroundColor : '#fff',
					style : {
						fontColor : '#A08A75'
					}
				},
				tooltip : {
					pointFormat : usageLegend + ' <b>{point.y:.1f}</b>',
				},
				series : [{
					name : usageLegend,
					data : results1,
					color : '#664766'
				}]
			});
		}

		function customerGraph() {
			$('#container').highcharts({
				chart : {
					type : 'column'
				},
				title : {
					text : $scope.chart_heading + ' | Stacked column chart',
					color : '#A08A75',
					style : {
						display : 'none'
					}
				},
				xAxis : {
					categories : resultsDate,
					labels : {
						align : 'right',
						style : {
							fontSize : '13px',
							fontFamily : 'Verdana, sans-serif'
						}
					},
					title : {
						text : 'Days Of week',
						style : {
							color : '#7C7A7D',
						}
					}
				},
				yAxis : {

					title : {
						text : 'Points%',
						style : {
							color : '#7C7A7D',
						}
					}
				},
				legend : {
					x : -350,
					backgroundColor : '#fff',
					style : {
						fontColor : '#A08A75'
					}
				},
				credits : {
					enabled : false
				},
				series : [{
					name : custLegend1,
					data : results1,
					color : '#D8882F'
				}, {
					name : custLegend2,
					data : results3,
					color : '#664766'
				}]
			});
		}

		function getTimeVisitGraph() {
			$('#container').highcharts({

				chart : {
					type : 'line'
				},

				title : {
					text : $scope.chart_heading + ' | Stacked column chart',
					color : '#A08A75',
					style : {
						display : 'none'
					}
				},

				xAxis : {
					categories : [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24],
					title : {
						text : 'Hours of Day',
						style : {
							color : '#7C7A7D',
						}
					}
				},
				yAxis : {
					allowDecimals : false,
					min : 0,
					title : {
						text : 'No of Visits',
						style : {
							color : '#7C7A7D',
						}
					}
				},

				tooltip : {
					formatter : function() {
						//return '<b>' + this.x + '</b><br/>' + this.series.name + ': ' + this.y + '<br/>' + 'Total: ' + this.point.stackTotal;
						return '<b>' + this.x + 'th </b>Hour : <b>' + this.y + '</b> Visit';
					},
				},

				plotOptions : {
					column : {
						stacking : 'normal'
					}
				},
				legend : {
					x : -370,
					backgroundColor : '#fff',
					style : {
						fontColor : '#A08A75'
					}
				},
				series : [{
					name : 'No of Visits',
					data : finaltime,
					color : '#D8882F',
				}]
			});
		}

	} else {
		$location.url("/login");
	}
});
module.controller('dashboardSnapshotCtrl', function($scope, $rootScope, $routeParams, $route, $http, $location) {
	if (getCookie('authToken')) {
		$('.welcome').show();
		$('.hideNav').hide();
		$('.showNav').show();
		$('.navBarCls ul li').removeClass('active');
		$('#snapshot').addClass('active');
		$('#adminConsole').hide();
		$rootScope.header = "Dashboard Snapshot | Kanari";

		if ($routeParams.outletId) {
			$scope.addOutletId = true;
			$scope.addOutletNo = $routeParams.outletId;
			$scope.outletOption = $routeParams.outletId;
		} else {
			$scope.addOutletId = false;
		}

		$scope.feedbackMetrics = function() {
			var param = {
				"auth_token" : getCookie('authToken'),
				"outlet_id" : $scope.outletOption,
				"password" : "X"
			}

			$http({
				method : 'get',
				url : '/api/feedbacks/metrics',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				$scope.foodLike = data.feedback_insights.food_quality.like;
				$scope.foodDisLike = data.feedback_insights.food_quality.dislike;
				$scope.foodDailyChange = data.feedback_insights.food_quality.change;

				if ($scope.foodDailyChange > 0) {
					$scope.foodFlag = 1;
				} else if ($scope.foodDailyChange < 0) {
					$scope.foodFlag = 0;
				} else {
					$scope.foodFlag = -1;
				}

				$scope.speedLike = data.feedback_insights.speed_of_service.like;
				$scope.speedDisLike = data.feedback_insights.speed_of_service.dislike;
				$scope.speedDailyChange = data.feedback_insights.speed_of_service.change;

				if ($scope.speedDailyChange > 0) {
					$scope.speedFlag = 1;
				} else if ($scope.speedDailyChange < 0) {
					$scope.speedFlag = 0;
				} else {
					$scope.speedFlag = -1;
				}

				$scope.friendlinessLike = data.feedback_insights.friendliness_of_service.like;
				$scope.friendlinessDisLike = data.feedback_insights.friendliness_of_service.dislike;
				$scope.friendlinessDailyChange = data.feedback_insights.friendliness_of_service.change;

				if ($scope.friendlinessDailyChange > 0) {
					$scope.friendlinessFlag = 1;
				} else if ($scope.friendlinessDailyChange < 0) {
					$scope.friendlinessFlag = 0;
				} else {
					$scope.friendlinessFlag = -1;
				}

				$scope.cleanlinessLike = data.feedback_insights.cleanliness.like;
				$scope.cleanlinessDisLike = data.feedback_insights.cleanliness.dislike;
				$scope.cleanlinessDailyChange = data.feedback_insights.cleanliness.change;

				if ($scope.cleanlinessDailyChange > 0) {
					$scope.cleanlinessFlag = 1;
				} else if ($scope.cleanlinessDailyChange < 0) {
					$scope.cleanlinessFlag = 0;
				} else {
					$scope.cleanlinessFlag = -1;
				}

				$scope.ambienceLike = data.feedback_insights.ambience.like;
				$scope.ambienceDisLike = data.feedback_insights.ambience.dislike;
				$scope.ambienceDailyChange = data.feedback_insights.ambience.change;

				if ($scope.ambienceDailyChange > 0) {
					$scope.ambienceFlag = 1;
				} else if ($scope.ambienceDailyChange < 0) {
					$scope.ambienceFlag = 0;
				} else {
					$scope.ambienceFlag = -1;
				}

				$scope.valueLike = data.feedback_insights.value_for_money.like;
				$scope.valueDisLike = data.feedback_insights.value_for_money.dislike;
				$scope.valueDailyChange = data.feedback_insights.value_for_money.change;

				if ($scope.valueDailyChange > 0) {
					$scope.valueFlag = 1;
				} else if ($scope.valueDailyChange < 0) {
					$scope.valueFlag = 0;
				} else {
					$scope.valueFlag = -1;
				}

				$scope.netScore = data.feedback_insights.net_promoter_score.like - data.feedback_insights.net_promoter_score.dislike;
				//$scope.netScoreDisLike = data.feedback_insights.net_promoter_score.dislike;
				$scope.netScoreDailyChange = data.feedback_insights.net_promoter_score.change;

				if ($scope.netScore > 0) {
					$scope.netScorePlusBar = true;
					$scope.netScoreMinusBar = false;
				} else if ($scope.netScore < 0) {

					$scope.netScorePlusBar = false;
					$scope.netScoreMinusBar = true;
				}

				if ($scope.netScoreDailyChange > 0) {
					$scope.netflag = 1;
				} else {
					$scope.netflag = 0;
				}

				$scope.feedCount = data.feedback_insights.feedbacks_count;
				if (data.feedback_insights.feedbacks_count == 0) {
					$scope.foodFlag = 2;
					$scope.speedFlag = 2;
					$scope.friendlinessFlag = 2;
					$scope.cleanlinessFlag = 2;
					$scope.ambienceFlag = 2;
					$scope.valueFlag = 2;
				}
				$scope.points = data.feedback_insights.rewards_pool;

			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));
				if (status == 401) {
					$location.url("/login");
				}

			});
		};

		$scope.feedbackMetrics();
		var dt;

		Date.prototype.yyyymmdd = function() {

			var yyyy = this.getFullYear().toString();
			var mm = (this.getMonth() + 1).toString();
			// getMonth() is zero-based
			var dd = this.getDate().toString();

			return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-' + (dd[1] ? dd : "0" + dd[0]);
		};

		$scope.listFeedbacks = function() {
			dt = new Date();
			var time = dt.getHours();
			console.log("time " + time);

			if (time >= 0 && time < 5) {
				console.log("hi i an in");
				dt.setDate(dt.getDate() - 1);
			}
			var startdt = new Date(dt.getFullYear(), dt.getMonth(), dt.getDate(), 5, 0, 0)
			var timeZone = String(String(dt).split("(")[1]).split(")")[0];
			console.log("start date " + startdt);
			if (!$scope.$$phase) {
				//$digest or $apply
			}

			var param = {
				"auth_token" : getCookie('authToken'),
				"outlet_id" : $scope.outletOption,
				"start_time" : startdt,
				"password" : "X"
			}

			$http({
				method : 'get',
				url : '/api/feedbacks',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				$scope.feedbackListSnapShot = data.feedbacks;
				console.log(data.feedbacks.length);
				if (data.feedbacks.length == 0) {
					$scope.feedBackListCount = true;
				} else {
					$scope.feedBackListCount = false;
				}

			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));
				if (status == 401) {
					$location.url("/login");
				}

			});
		};

		$scope.listFeedbacks();

		$scope.selectOutletSnap = function() {
			$scope.listFeedbacks();
			$scope.feedbackMetrics();
		}

		$scope.listOutletNames = function() {
			var param = {
				"auth_token" : getCookie('authToken'),
				"password" : 'X',
			};
			$http({
				method : 'get',
				url : '/api/outlets',
				params : param,
			}).success(function(data, status) {
				console.log("Data in success " + data + " status " + status);
				$scope.outletNameList = data.outlets;
				if ($routeParams.outletId) {
					$scope.outletOption = parseInt($routeParams.outletId);
				}
			}).error(function(data, status) {
				console.log("data in error " + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		};
		$scope.listOutletNames();

	} else {
		$location.url("/login");
	}
});

module.controller('adminConsoleOutletCtrl', function($scope, $rootScope, $routeParams, $route, $http, $location) {
	if (getCookie('authToken')) {
		$rootScope.header = "Admin Console | Kanari";
		$('.welcome').show();
		$('.navBarCls').show();
		//$('.navBarCls ul li').removeClass('active');
		$('#dasboard').show();
		$('#outlet').hide();
		$('#account').hide();
		$('#dasboardCustomer').hide();
		$('.navBarCls ul li').removeClass('active');
		$('#outlet').hide();
		$('#account').hide();
		$('#adminConsole').show();
		$('#adminConsole').addClass('active');
		//$('#account').addClass('active');
		$scope.success = false;
		$scope.enabled = false;
		$scope.disabled = false;

		$scope.outletDetails = [];

		$scope.loadOutletDetails = function() {
			var param = {
				"auth_token" : getCookie('authToken'),
				"password" : 'X',
			};
			$http({
				method : 'get',
				url : '/api/outlets',
				params : param,
			}).success(function(data, status) {
				console.log("Data in success " + data + " status " + status);
				$scope.outletDetails = data.outlets;
			}).error(function(data, status) {
				console.log("data in error " + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		};

		$scope.loadOutletDetails();

		$scope.disableOutlet = function(chk, id, outletName) {
			//$scope.auth_token = getCookie('authToken');
			console.log("hi " + chk);

			var params = {
				"outlet" : {
					"disabled" : chk
				},
				"auth_token" : getCookie('authToken')
			}
			$http({
				method : 'PUT',
				url : '/api/outlets/' + id + "/disable",
				data : params,
			}).success(function(data, status) {
				console.log("data in success " + data + " status " + status);
				$scope.error = data.auth_token;
				//$scope.outNO = id;
				$scope.outletName = outletName;
				//conseol.log("id "+$scope.outNO);
				if (chk == true) {
					$scope.enabled = true;
					$scope.disabled = false;
				} else {
					$scope.enabled = false;
					$scope.disabled = true;
				}
				$scope.statement = true;
				$scope.erromsg = false;
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
				$scope.erromsg = true;

			});
		};
	} else {
		$location.url("/login");
	}
});

module.controller('adminConsoleCustomerCtrl', function($scope, $rootScope, $routeParams, $route, $http, $location) {
	if (getCookie('authToken')) {
		$rootScope.header = "Admin Console | Kanari";
		$('.welcome').show();
		$('.navBarCls').show();
		//$('.navBarCls ul li').removeClass('active');
		$('#dasboard').show();
		$('#outlet').hide();
		$('#account').hide();
		$('#dasboardCustomer').hide();
		$('.navBarCls ul li').removeClass('active');
		$('#outlet').hide();
		$('#account').hide();
		$('#adminConsole').show();
		$('#adminConsole').addClass('active');
		//$('#account').addClass('active');
		$scope.success = false;
		$scope.custUpdate = false;
		$scope.customerName = "";
		$scope.customerDetails = [];

		$scope.loadCustomerDetails = function() {
			var param = {
				"auth_token" : getCookie('authToken'),
				"password" : 'X',
			};
			$http({
				method : 'get',
				url : '/api/customers',
				params : param,
			}).success(function(data, status) {
				console.log("Data in success " + data + " status " + status);
				$scope.customerDetails = data.customers;
				$scope.customerDetails.sort(function(a, b) {
					var nameA = a.name.toLowerCase(), nameB = b.name.toLowerCase()
					if (nameA < nameB)//sort string ascending
						return -1
					if (nameA > nameB)
						return 1
					return 0 //default return value (no sorting)
				});
				$scope.outletNo = data.customers.authorized_outlets;
			}).error(function(data, status) {
				console.log("data in error " + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
			});
		};

		$scope.loadCustomerDetails();

		$scope.increase_decreaseVal = function(id, type) {
			cus = $scope.customerDetails[id]
			if (type == 1) {
				cus.authorized_outlets += 1
			} else if (cus.authorized_outlets != 0) {
				cus.authorized_outlets -= 1
			}
		};

		$scope.updateCustomerOutlets = function(id) {
			console.log("id " + id);
			cus = $scope.customerDetails[id]
			console.log(cus.authorized_outlets)
			console.log($scope.customerDetails[id])
			var params = {
				"customer" : {
					"authorized_outlets" : cus.authorized_outlets,//outletNo,
				},
				"auth_token" : getCookie('authToken')
			}
			$http({
				method : 'PUT',
				url : '/api/customers/' + cus.id,
				data : params,
			}).success(function(data, status) {
				console.log("data in success " + data + " status " + status);
				$scope.error = data.auth_token;
				$scope.customerName = cus.name;
				$scope.custUpdate = true;
				$scope.statement = true;
				$scope.erromsg = false;
			}).error(function(data, status) {
				console.log("data in error" + data + " status " + status);
				if (status == 401) {
					$location.url("/login");
				}
				$scope.erromsg = true;
			});

		};

	} else {
		$location.url("/login");
	}
});
function setCookie(name, value, days) {
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


$(document).ready(function() {
	$("#phoneNumber").blur(validateNumber);
});

function validateNumber() {
	var a = $("#phoneNumber").val();
	var filter = /^\+?([0-9]{2})\)?[-. ]?([0-9]{4})[-. ]?([0-9]{4})$/;
	//if it's valid number
	if (filter.test(a)) {
		console.log("valid phone number");
		return true;
	}
	//if it's NOT valid
	else {
		return false;
	}
}

// function formatPhone(obj) {
// $(obj).addClass('ng-pristine');
// }
