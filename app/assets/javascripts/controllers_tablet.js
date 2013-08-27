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

var refreshIntervalId;
var flag = 0;
var feedbackTimeout;
var insightTimeout;

module.controller('headerCtrl', function($scope, $http, $location) {
	var overlayDiv = $("#overlaySuccess");
	$scope.popup = false;
	$(".headerDiv a").click(function() {
		$(".headerDiv a").removeClass("ui_btn_active");
		$(this).addClass("ui_btn_active");
		$(".headerDiv span").hide();
		$(this).children().show();
	});
	$scope.showPopup = function() {
		$("#overlaySuccess").show();
		$(".popup").show();
		//$scope.popup = true;
		overlayDiv.css({
			'z-index' : '10',
			'background-color' : '#000'
		});
		$(".popup").focus();
	};

	$scope.cancel = function() {
		$("#overlaySuccess").hide();
		$(".popup").hide();
		//$scope.popup = false;
		console.log("IN");
		overlayDiv.css({
			'z-index' : '0',
			'background-color' : 'transparent'
		});
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
			$(".userloggedIn").hide();

			console.log("User Role " + data + " status " + status);
			deleteCookie('authToken');
			deleteCookie('userRole');
			deleteCookie('userName');
			deleteCookie('feedbackId');
			deleteCookie("signInCount");
			$(".popup").hide();
			$location.url("/signin");
			$scope.popup = false;
			overlayDiv.css({
				'z-index' : '0',
				'background-color' : 'transparent'
			});

		}).error(function(data, status) {
			console.log("data " + data + " status " + status + "authToken" + getCookie('authToken'));
		});
		//$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken'));
		deleteCookie('authToken');
		deleteCookie('userRole');
		deleteCookie('userName');
		deleteCookie('feedbackId');
		deleteCookie("signInCount");
		$location.url("/signin");
		$scope.popup = false;
		overlayDiv.css({
			'z-index' : '0',
			'background-color' : 'transparent'
		});
	};
});

module.controller('signInController', function($scope, $http, $location) {
	clearInterval(refreshIntervalId);
	$("#wrapper").removeClass("clsafterLogin");
	$("#wrapper").addClass("clsforLogin");
	$(".userloggedIn").hide();
	$scope.chkLogin = function() {
		if ($scope.email == "" && $scope.password == "" && !$scope.email && !$scope.password) {
			console.log("email is blank");
			$scope.error = " Please enter Email and Password";
			$scope.erromsg = true;
			return false;
		}
		var param = "{email:'" + $scope.email + "@kanari.co','password:'" + $scope.password + "'}";
		$http({
			method : 'post',
			url : '/api/users/sign_in',
		}).success(function(data, status) {
			console.log("User Role " + data.user_role + " status " + status);
			if ($scope.rememberMe) {
				setCookie('userRole', data.user_role, 7);
				setCookie('authToken', data.auth_token, 7);
				setCookie('userName', data.first_name + ' ' + data.last_name, 7);
				setCookie('signInCount', data.sign_in_count);
			} else {
				setCookie('userRole', data.user_role, 0.29);
				setCookie('authToken', data.auth_token, 0.29);
				setCookie('userName', data.first_name + ' ' + data.last_name, 0.29);
				setCookie('signInCount', data.sign_in_count);
			}
			$scope.erromsg = false;
			if (getCookie('userRole') == "manager" && data.registration_complete) {
				$location.url("/login");
			} else if (getCookie('userRole') == "staff" && data.registration_complete) {
				flag = 1;
				$location.url("/feedback");
			}

		}).error(function(data, status) {
			//console.log($scope.password)
			console.log("data " + $scope.email + " status " + $scope.password);
			$scope.error = "Invalid Id or Password";
			$scope.erromsg = true;
		});
	};

	// var selectField1 = document.getElementById('inputFields1');
	// selectField1.addEventListener('touchstart'/*'mousedown'*/, function(e) {
	// alert("in");
	// e.stopPropagation();
	// }, false);
	// var selectField2 = document.getElementById('inputFields2');
	// selectField2.addEventListener('touchstart'/*'mousedown'*/, function(e) {
	// e.stopPropagation();
	// }, false);

	$scope.$watch('email + password', function() {
		$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode($scope.email + '@kanari.co:' + $scope.password);
	});

});

module.controller('homePageController', function($scope, $http, $location, $timeout) {
	$(".userloggedIn").show();
	$("#wrapper").removeClass("clsforLogin");
	$("#wrapper").addClass("clsafterLogin");
	$(".headerDiv a").removeClass("ui_btn_active");
	$(".headerDiv span").hide();
	$("#feedback").addClass("ui_btn_active");
	$("#feedback span").show();
	$(".popup").hide();
	if (getCookie('authToken')) {
		var overlayDiv = $("#overlaySuccess");
		$scope.active1 = true;
		$scope.feedbackList = [];
		
		
		Date.prototype.yyyymmdd = function() {
			var yyyy = this.getFullYear().toString();
			var mm = (this.getMonth() + 1).toString();
			// getMonth() is zero-based
			var dd = this.getDate().toString();

			return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-' + (dd[1] ? dd : "0" + dd[0]);
		};

		$scope.listFeedbacks = function() {
			//alert(new Date());
			//$.mobile.loading('show');
			var dt = new Date();
			console.log("date "+dt.yyyymmdd()+" 5:00:00");
			var param = {
				"auth_token" : getCookie('authToken'),
				"start_time" : dt.yyyymmdd()+" 5:00:00",
				"password" : "X"
			}

			$http({
				method : 'get',
				url : '/api/feedbacks',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				$scope.feedbackList = data.feedbacks;
				//$.mobile.loading('hide');
				overlayDiv.css({
					'z-index' : '0',
					'background-color' : 'transparent'
				});
				console.log("in list feedbacks");
			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));
				//$.mobile.loading('hide');
				overlayDiv.css({
					'z-index' : '0',
					'background-color' : 'transparent'
				});
			});

			//feedbackTimeout = $timeout($scope.listFeedbacks,120000);

		};

		$scope.listFeedbacks();

		$scope.refresh = function() {
			overlayDiv.css({
				'z-index' : '10',
				'background-color' : '#000'
			});
			$scope.listFeedbacks();
		};
		//document.addEventListener('DOMContentLoaded', function() {
		//alert("in");
		//	if(flag == 1){
		setTimeout(loaded, 2000);
		//}

		//feedbackTimeout = $timeout($scope.listFeedbacks,120000);

	} else {
		$location.url("/signin");
	}

});

module.controller('insightsController', function($scope, $http, $location, $timeout) {
	$(".userloggedIn").show();
	$("#wrapper").removeClass("clsforLogin");
	$("#wrapper").addClass("clsafterLogin");
	$("#insights").addClass("ui_btn_active");
	$("#insights span").show();
	if (getCookie('authToken')) {
		$scope.active2 = true;
		flag = 1;

		$scope.feedbackMetrics = function() {
			var param = {
				"auth_token" : getCookie('authToken'),
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
				} else {
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

			});

			insightTimeout = $timeout($scope.feedbackMetrics, 120000);
		};

		$scope.feedbackMetrics();
		setTimeout(setupScrollbars, 1000);

	} else {
		$location.url("/signin");
	}

});

module.controller('redemeController', function($scope, $http, $location, $timeout) {
	$(".userloggedIn").show();
	var overlayDiv = $("#overlaySuccess");
	$("#wrapper").removeClass("clsforLogin");
	$("#wrapper").addClass("clsafterLogin");
	$("#redemption").addClass("ui_btn_active");
	$("#redemption span").show();
	if (getCookie('authToken')) {
		$timeout.cancel(insightTimeout);
		// $timeout.cancel(feedbackTimeout);
		// var flagP = 0;
		// $scope.popupHeight = $(window).height() - 150;
		// $(window).bind('orientationchange', 'load', function(event) {
			// $scope.popupHeight = $(window).height() - 150;
			// if(flagP == 1){
				// $scope.showRedemptions();
			// }
		// });
		$scope.showRedemptions = function() {
			//window.history.back();
			//flagP = 1;
			$scope.processedRedemptions();
			setTimeout(setupScrollbars, 1000);
			$("#overlaySuccess").show();
			$(".redeemptions").show();
			//$scope.popup = true;
			overlayDiv.css({
				'z-index' : '10',
				'background-color' : '#000'
			});
			$(".redeemptions").focus();
			$('#scrollbar1').oneFingerScroll();
		};

		$scope.close = function() {
			//console.log("IN");
			flagP = 0;
			$("#overlaySuccess").hide();
			$(".redeemptions").hide();
			//$scope.popup = false;
			overlayDiv.css({
				'z-index' : '0',
				'background-color' : 'transparent'
			});
		};

		$scope.active3 = true;
		flag = 1;
		$scope.redemptionList = [];
		$scope.processedRedemptionList = [];

		$scope.listRedemptions = function() {
			var param = {
				"type" : "pending",
				"auth_token" : getCookie('authToken')
			}

			$http({
				method : 'get',
				url : '/api/redemptions',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				$scope.redemptionList = data.redemptions;
				console.log("list" + $scope.redemptionList)
			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));

			});
		};

		$scope.processedRedemptions = function() {
			var param = {
				"auth_token" : getCookie('authToken')
			}

			$http({
				method : 'get',
				url : '/api/redemptions',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				$scope.processedRedemptionList = data.redemptions;
				console.log("list" + $scope.redemptionList)
			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));

			});
		};

		$scope.listRedemptions();
		$('#scrollbar3').oneFingerScroll();

		$scope.confirm = function(id) {
			console.log("confirmed" + id);
			var param = {
				"redemption" : {
					"approve" : true
				},
				"auth_token" : getCookie('authToken')
			}

			$http({
				method : 'put',
				url : '/api/redemptions/' + id,
				data : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);
				$scope.listRedemptions();
			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));

			});
		};

		//setTimeout(setupScrollbars, 2000);

	} else {
		$location.url("/signin")
	}

});

var flag = 0;
var testID = 0;

module.controller('numericCodeController', function($scope, $http, $location, $timeout) {
	$(".userloggedIn").show();
	$("#wrapper").removeClass("clsforLogin");
	$("#wrapper").addClass("clsafterLogin");
	$("#numeric_code").addClass("ui_btn_active");
	$("#numeric_code span").show();
	if (getCookie('authToken')) {
		$timeout.cancel(insightTimeout);
		//$timeout.cancel(feedbackTimeout);
		flag = 1;
		$scope.loader = false;
		$scope.codeGenerate = true;
		$scope.codeGenerated = false;
		$scope.billAmount = "";
		$scope.active4 = true;
		$scope.erromsg = false;
		$scope.listCodes = [];
		// $( "#generateCode" ).click(function(event) {
		// alert("in"+flag)
		// flag = 0;
		// event.preventDefault();
		// });
		$scope.generateCode = function() {

			if (testID != $scope.billAmount) {
				testID = $scope.billAmount;
				if (!$scope.billAmount) {
					$scope.error = "Please enter valid bill amount";
					$scope.succmsg = false;
					$scope.erromsg = true;
				} else if ($scope.billAmount < 0) {
					console.log("in else if");
					$scope.error = "Please enter valid bill amount";
					$scope.succmsg = false;
					$scope.erromsg = true;
				} else {
					console.log("amount " + $scope.billAmount)
					$scope.loader = true;
					var param = {
						"bill_amount" : $scope.billAmount,
						"auth_token" : getCookie("authToken")
					}

					$http({
						method : 'POST',
						url : '/api/kanari_codes',
						data : param,
					}).success(function(data, status) {
						console.log("data in success " + data + " status " + status);
						$scope.erromsg = false;
						$scope.codeGenerate = false;
						$scope.codeGenerated = true;

						$scope.code = data.code;

						//$scope.billAmount = "";
						$('#billAmnt').val("");

						$scope.loader = false;
					}).error(function(data, status) {
						console.log("data in errorrr" + data + " status " + status);
						$scope.error = data.error[0];
						$scope.succmsg = false;
						$scope.erromsg = true;
						$scope.loader = false;
					});
				}
			}
		};

		var selectField = document.getElementById('Field10');
		selectField.addEventListener('touchstart'/*'mousedown'*/, function(e) {
			//alert("in");
			e.stopPropagation();
		}, false);

		$scope.listGeneratedCodes = function() {
			var param = {
				"type" : "pending",
				"auth_token" : getCookie('authToken')
			}

			$http({
				method : 'get',
				url : '/api/feedbacks',
				params : param
			}).success(function(data, status) {
				console.log("User Role " + data + " status " + status);

				$scope.listCodes = data.feedbacks;
				//console.log("codes"+$scope.listCodes);

			}).error(function(data, status) {
				console.log("data " + data + " status " + status + " authToken" + getCookie('authToken'));
			});
		};

		$scope.listGeneratedCodes();
		//setTimeout(setupScrollbars, 2000);
		
		$('#scrollbar2').oneFingerScroll();

		$scope.parseDate = function(jsonDate) {
			console.log("date " + jsonDate + " parsed date " + new Date(Date.parse(jsonDate)));
			$scope.v = {
				DDt : Date.parse(jsonDate)
			}
		};

		$scope.done = function() {
			//console.log("in done btn pressed");
			$scope.codeGenerate = true;
			$scope.loader = false;
			$scope.codeGenerated = false;
			$scope.billAmount = "";
			//$scope.active4 = true;
			$scope.erromsg = false;
			$scope.listGeneratedCodes();
		};

	} else {
		$location.url("/signin");
	}
});

function callScroller() {
	//alert("in scroll call");
	myscroll = new iScroll('wrapper');
}

function setupScrollbars() {
	//Created an array for adding n iScroll objects
	var myScroll = new Array();
	$('.scrollable').each(function() {
		id = $(this).attr('id');
		myScroll.push(new iScroll(id));
	});
}

/* Cookie functions	*/
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

var myScroll, pullDownEl, pullDownOffset, pullUpEl, pullUpOffset, generatedCount = 0;

function pullDownAction() {
	setTimeout(function() {// <-- Simulate network congestion, remove setTimeout from production!
		console.log("hi in hello refresh");
		angular.element($('#homepage')).scope().listFeedbacks();
		myScroll.refresh();
		// Remember to refresh when contents are loaded (ie: on ajax completion)
	}, 2000);
	// <-- Simulate network congestion, remove setTimeout from production!
}

jQuery.fn.oneFingerScroll = function() {
	//alert("in scroll");
	var scrollStartPos = 0;
	$(this).bind('touchstart', function(event) {
		// jQuery clones events, but only with a limited number of properties for perf reasons. Need the original event to get 'touches'
		var e = event.originalEvent;
		scrollStartPos = $(this).scrollTop() + e.touches[0].pageY;
		e.preventDefault();
	});
	$(this).bind('touchmove', function(event) {
		var e = event.originalEvent;
		$(this).scrollTop(scrollStartPos - e.touches[0].pageY);
		e.preventDefault();
	});
	return this;
};

function pullUpAction() {
	setTimeout(function() {// <-- Simulate network congestion, remove setTimeout from production!
		//console.log("hi in hello refresh");
		myScroll.refresh();
		// Remember to refresh when contents are loaded (ie: on ajax completion)
	}, 2000);
	// <-- Simulate network congestion, remove setTimeout from production!
}

function loaded() {
	//alert("in loaded");
	myScroll = new iScroll('wrapper');
	pullDownEl = document.getElementById('pullDown');
	pullDownOffset = pullDownEl.offsetHeight;
	pullUpEl = document.getElementById('pullUp');
	pullUpOffset = pullUpEl.offsetHeight;

	myScroll = new iScroll('wrapper', {
		//useTransition: true,
		topOffset : pullDownOffset,
		onRefresh : function() {
			if (pullDownEl.className.match('loading')) {
				pullDownEl.className = '';
				pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Loading...';
				pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Pull down to refresh...';
			} else if (pullUpEl.className.match('loading')) {
				pullUpEl.className = '';
				pullUpEl.querySelector('.pullUpLabel').innerHTML = '';
			}
		},
		onScrollMove : function() {
			if (this.y > 5 && !pullDownEl.className.match('flip')) {
				pullDownEl.className = 'flip';
				pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Release to refresh...';
				this.minScrollY = 0;
			} else if (this.y < 5 && pullDownEl.className.match('flip')) {
				pullDownEl.className = '';
				pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Pull down to refresh...';
				this.minScrollY = -pullDownOffset;
			} else if (this.y < (this.maxScrollY - 5) && !pullUpEl.className.match('flip')) {
				pullUpEl.className = 'flip';
				pullUpEl.querySelector('.pullUpLabel').innerHTML = '';
				this.maxScrollY = this.maxScrollY;
			} else if (this.y > (this.maxScrollY + 5) && pullUpEl.className.match('flip')) {
				pullUpEl.className = '';
				pullUpEl.querySelector('.pullUpLabel').innerHTML = '';
				this.maxScrollY = pullUpOffset;
			}
		},
		onScrollEnd : function() {
			if (pullDownEl.className.match('flip')) {
				pullDownEl.className = 'loading';
				pullDownAction();
				pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Loading...';
				// Execute custom function (ajax call?)
			} else if (pullUpEl.className.match('flip')) {
				pullUpEl.className = 'loading';
				pullUpEl.querySelector('.pullUpLabel').innerHTML = '';
				pullUpAction();
				// Execute custom function (ajax call?)
			}
		}
	});

	setTimeout(function() {
		document.getElementById('wrapper').style.left = '0';
	}, 800);
}

document.addEventListener('touchmove', function(e) {
	e.preventDefault();
}, false);

//document.addEventListener('DOMContentLoaded', function () { setTimeout(loaded, 2000); }, false);

// document.addEventListener('DOMContentLoaded', function() {
// setTimeout(loaded, 2000);
// }, false);

