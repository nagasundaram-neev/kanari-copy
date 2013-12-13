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

var auth_token = "";
var feedbackFlag = 0;
var signInCount = "";
var facebookFlag = 0;
//var logOut = 0;
var flagPage = 0;
var iphoneFlag = 0;
var footerFlag = 0;
var hostName =location.hostname; 
//var localyticsSession;
// switch(hostName){
	// case "localhost": localyticsSession = LocalyticsSession("3377ca92c983287af395e16-ce41cd54-55c4-11e3-96f0-009c5fda0a25");
							// //console.log("hi in localhost");
							// break;
	// case "app.kanari.co": localyticsSession = LocalyticsSession("4541b43eb3c33ab174c297e-429beda6-52ab-11e3-925c-005cf8cbabd8");
							// //console.log("hi in production");
							// break;
	// case "staging.kanari.co": localyticsSession = LocalyticsSession("f5eca14e738338c606503c3-3bcc0202-5276-11e3-1668-004a77f8b47f"); 
							 // //console.log("hi in stagin");
							 // break;
// }

var localyticsSession = LocalyticsSession("f5eca14e738338c606503c3-3bcc0202-5276-11e3-1668-004a77f8b47f");
localyticsSession.open();
module.controller('loginController', function($scope, $http, $location) {
	localyticsSession.tagScreen('Login');
	$scope.storageKey = 'JQueryMobileAngularTodoapp';
	$scope.remember = false;
	$scope.erromsg = false;
	$scope.email = "";
	if (getCookie("authToken")) {
		flagPage = 0;
		footerFlag = 0;
		$location.url("/home");
	} else {
		$scope.chkLogin = function() {
			if ($scope.email == "" && $scope.password == "" && !$scope.email && !$scope.password) {
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
					localyticsSession.tagEvent("Logged In", {
						"Type" : 'Email'
					});
					$location.url("/home");
				} else if (getCookie('userRole') == "kanari_admin" || getCookie('userRole') == "customer_admin" || getCookie('userRole') == "staff" || getCookie('userRole') == "manager") {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
					$scope.error = "You are not authenticated to use this app";
					$scope.erromsg = true;
				}
			}).error(function(data, status) {
				if (getCookie('userRole') == "kanari_admin" || getCookie('userRole') == "customer_admin" || getCookie('userRole') == "staff") {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
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

	}
	addToIphoneHomePage();
	// $scope.$watch('email + password', function() {
	// $http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode($scope.email + ':' + $scope.password);
	// });

	// comment for checking

});
//Function to call addtohomepage on Iphone
function addToIphoneHomePage() {
	var addToHome = (function(w) {
		var nav = w.navigator, isIDevice = 'platform' in nav && (/iphone|ipod|ipad/gi).test(nav.platform), isIPad, isRetina, isSafari, isStandalone, OSVersion, startX = 0, startY = 0, lastVisit = 0, isExpired, isSessionActive, isReturningVisitor, balloon, overrideChecks, positionInterval, closeTimeout, options = {
			autostart : true, // Automatically open the balloon
			returningVisitor : false, // Show the balloon to returning visitors only (setting this to true is HIGHLY RECCOMENDED)
			animationIn : 'drop', // drop || bubble || fade
			animationOut : 'fade', // drop || bubble || fade
			startDelay : 2000, // 2 seconds from page load before the balloon appears
			lifespan : 15000, // 15 seconds before it is automatically destroyed
			bottomOffset : 14, // Distance of the balloon from bottom
			expire : 0, // Minutes to wait before showing the popup again (0 = always displayed)
			message : '', // Customize your message or force a language ('' = automatic)
			touchIcon : false, // Display the touch icon
			arrow : true, // Display the balloon arrow
			hookOnLoad : true, // Should we hook to onload event? (really advanced usage)
			closeButton : true, // Let the user close the balloon
			iterations : 100	// Internal/debug use
		}, intl = {
			ar : '<span dir="rtl">قم بتثبيت هذا التطبيق على <span dir="ltr">%device:</span>انقر<span dir="ltr">%icon</span> ،<strong>ثم اضفه الى الشاشة الرئيسية.</strong></span>',
			ca_es : 'Per instal·lar aquesta aplicació al vostre %device premeu %icon i llavors <strong>Afegir a pantalla d\'inici</strong>.',
			cs_cz : 'Pro instalaci aplikace na Váš %device, stiskněte %icon a v nabídce <strong>Přidat na plochu</strong>.',
			da_dk : 'Tilføj denne side til din %device: tryk på %icon og derefter <strong>Føj til hjemmeskærm</strong>.',
			de_de : 'Installieren Sie diese App auf Ihrem %device: %icon antippen und dann <strong>Zum Home-Bildschirm</strong>.',
			el_gr : 'Εγκαταστήσετε αυτήν την Εφαρμογή στήν συσκευή σας %device: %icon μετά πατάτε <strong>Προσθήκη σε Αφετηρία</strong>.',
			en_us : 'Install this web app on your %device: tap %icon and then <strong>Add to Home Screen</strong>.',
			es_es : 'Para instalar esta app en su %device, pulse %icon y seleccione <strong>Añadir a pantalla de inicio</strong>.',
			fi_fi : 'Asenna tämä web-sovellus laitteeseesi %device: paina %icon ja sen jälkeen valitse <strong>Lisää Koti-valikkoon</strong>.',
			fr_fr : 'Ajoutez cette application sur votre %device en cliquant sur %icon, puis <strong>Ajouter à l\'écran d\'accueil</strong>.',
			he_il : '<span dir="rtl">התקן אפליקציה זו על ה-%device שלך: הקש %icon ואז <strong>הוסף למסך הבית</strong>.</span>',
			hr_hr : 'Instaliraj ovu aplikaciju na svoj %device: klikni na %icon i odaberi <strong>Dodaj u početni zaslon</strong>.',
			hu_hu : 'Telepítse ezt a web-alkalmazást az Ön %device-jára: nyomjon a %icon-ra majd a <strong>Főképernyőhöz adás</strong> gombra.',
			it_it : 'Installa questa applicazione sul tuo %device: premi su %icon e poi <strong>Aggiungi a Home</strong>.',
			ja_jp : 'このウェブアプリをあなたの%deviceにインストールするには%iconをタップして<strong>ホーム画面に追加</strong>を選んでください。',
			ko_kr : '%device에 웹앱을 설치하려면 %icon을 터치 후 "홈화면에 추가"를 선택하세요',
			nb_no : 'Installer denne appen på din %device: trykk på %icon og deretter <strong>Legg til på Hjem-skjerm</strong>',
			nl_nl : 'Installeer deze webapp op uw %device: tik %icon en dan <strong>Voeg toe aan beginscherm</strong>.',
			pl_pl : 'Aby zainstalować tę aplikacje na %device: naciśnij %icon a następnie <strong>Dodaj jako ikonę</strong>.',
			pt_br : 'Instale este aplicativo em seu %device: aperte %icon e selecione <strong>Adicionar à Tela Inicio</strong>.',
			pt_pt : 'Para instalar esta aplicação no seu %device, prima o %icon e depois o <strong>Adicionar ao ecrã principal</strong>.',
			ru_ru : 'Установите это веб-приложение на ваш %device: нажмите %icon, затем <strong>Добавить в «Домой»</strong>.',
			sv_se : 'Lägg till denna webbapplikation på din %device: tryck på %icon och därefter <strong>Lägg till på hemskärmen</strong>.',
			th_th : 'ติดตั้งเว็บแอพฯ นี้บน %device ของคุณ: แตะ %icon และ <strong>เพิ่มที่หน้าจอโฮม</strong>',
			tr_tr : 'Bu uygulamayı %device\'a eklemek için %icon simgesine sonrasında <strong>Ana Ekrana Ekle</strong> düğmesine basın.',
			zh_cn : '您可以将此应用程式安装到您的 %device 上。请按 %icon 然后点选<strong>添加至主屏幕</strong>。',
			zh_tw : '您可以將此應用程式安裝到您的 %device 上。請按 %icon 然後點選<strong>加入主畫面螢幕</strong>。'
		};

		function init() {
			// Preliminary check, all further checks are performed on iDevices only
			//alert("inlogin");
			if (!isIDevice)
				return;

			var now = Date.now(), title, i;

			// Merge local with global options
			if (w.addToHomeConfig) {
				for (i in w.addToHomeConfig ) {
					options[i] = w.addToHomeConfig[i];
				}
			}
			if (!options.autostart)
				options.hookOnLoad = false;

			isIPad = (/ipad/gi).test(nav.platform);
			isRetina = w.devicePixelRatio && w.devicePixelRatio > 1;
			isSafari = (/Safari/i).test(nav.appVersion) && !(/CriOS/i).test(nav.appVersion);
			isStandalone = nav.standalone;
			OSVersion = nav.appVersion.match(/OS (\d+_\d+)/i);
			OSVersion = OSVersion[1] ? +OSVersion[1].replace('_', '.') : 0;

			lastVisit = +w.localStorage.getItem('addToHome');

			isSessionActive = w.sessionStorage.getItem('addToHomeSession');
			isReturningVisitor = options.returningVisitor ? lastVisit && lastVisit + 28 * 24 * 60 * 60 * 1000 > now : true;

			if (!lastVisit)
				lastVisit = now;

			// If it is expired we need to reissue a new balloon
			isExpired = isReturningVisitor && lastVisit <= now;

			if (options.hookOnLoad)
				w.addEventListener('load', loaded, false);
			else if (!options.hookOnLoad && options.autostart)
				loaded();
		}

		function loaded() {
			w.removeEventListener('load', loaded, false);

			if (!isReturningVisitor)
				w.localStorage.setItem('addToHome', Date.now());
			else if (options.expire && isExpired)
				w.localStorage.setItem('addToHome', Date.now() + options.expire * 60000);

			if (!overrideChecks && (!isSafari || !isExpired || isSessionActive || isStandalone || !isReturningVisitor ))
				return;

			var touchIcon = '', platform = nav.platform.split(' ')[0], language = nav.language.replace('-', '_'), i, l;

			balloon = document.createElement('div');
			balloon.id = 'addToHomeScreen';
			balloon.style.cssText += 'left:-9999px;-webkit-transition-property:-webkit-transform,opacity;-webkit-transition-duration:0;-webkit-transform:translate3d(0,0,0);position:' + (OSVersion < 5 ? 'absolute' : 'fixed');

			// Localize message
			if (options.message in intl) {// You may force a language despite the user's locale
				language = options.message;
				options.message = '';
			}
			if (options.message === '') {// We look for a suitable language (defaulted to en_us)
				options.message = language in intl ? intl[language] : intl['en_us'];
			}

			if (options.touchIcon) {
				touchIcon = isRetina ? document.querySelector('head link[rel^=apple-touch-icon][sizes="114x114"],head link[rel^=apple-touch-icon][sizes="144x144"]') : document.querySelector('head link[rel^=apple-touch-icon][sizes="57x57"],head link[rel^=apple-touch-icon]');

				if (touchIcon) {
					touchIcon = '<span style="background-image:url(' + touchIcon.href + ')" class="addToHomeTouchIcon"></span>';
				}
			}

			balloon.className = ( isIPad ? 'addToHomeIpad' : 'addToHomeIphone') + ( touchIcon ? ' addToHomeWide' : '');
			balloon.innerHTML = touchIcon + options.message.replace('%device', platform).replace('%icon', OSVersion >= 4.2 ? '<span class="addToHomeShare"></span>' : '<span class="addToHomePlus">+</span>') + (options.arrow ? '<span class="addToHomeArrow"></span>' : '') + (options.closeButton ? '<span class="addToHomeClose">\u00D7</span>' : '');

			document.body.appendChild(balloon);

			// Add the close action
			if (options.closeButton)
				balloon.addEventListener('click', clicked, false);

			if (!isIPad && OSVersion >= 6)
				window.addEventListener('orientationchange', orientationCheck, false);

			setTimeout(show, options.startDelay);
		}

		function show() {
			var duration, iPadXShift = 208;

			// Set the initial position
			if (isIPad) {
				if (OSVersion < 5) {
					startY = w.scrollY;
					startX = w.scrollX;
				} else if (OSVersion < 6) {
					iPadXShift = 160;
				}

				balloon.style.top = startY + options.bottomOffset + 'px';
				balloon.style.left = startX + iPadXShift - Math.round(balloon.offsetWidth / 2) + 'px';

				switch ( options.animationIn ) {
					case 'drop':
						duration = '0.6s';
						balloon.style.webkitTransform = 'translate3d(0,' + -(w.scrollY + options.bottomOffset + balloon.offsetHeight) + 'px,0)';
						break;
					case 'bubble':
						duration = '0.6s';
						balloon.style.opacity = '0';
						balloon.style.webkitTransform = 'translate3d(0,' + (startY + 50) + 'px,0)';
						break;
					default:
						duration = '1s';
						balloon.style.opacity = '0';
				}
			} else {
				startY = w.innerHeight + w.scrollY;

				if (OSVersion < 5) {
					startX = Math.round((w.innerWidth - balloon.offsetWidth) / 2) + w.scrollX;
					balloon.style.left = startX + 'px';
					balloon.style.top = startY - balloon.offsetHeight - options.bottomOffset + 'px';
				} else {
					balloon.style.left = '50%';
					balloon.style.marginLeft = -Math.round(balloon.offsetWidth / 2) - (w.orientation % 180 && OSVersion >= 6 ? 40 : 0 ) + 'px';
					balloon.style.bottom = options.bottomOffset + 'px';
				}

				switch (options.animationIn) {
					case 'drop':
						duration = '1s';
						balloon.style.webkitTransform = 'translate3d(0,' + -(startY + options.bottomOffset) + 'px,0)';
						break;
					case 'bubble':
						duration = '0.6s';
						balloon.style.webkitTransform = 'translate3d(0,' + (balloon.offsetHeight + options.bottomOffset + 50) + 'px,0)';
						break;
					default:
						duration = '1s';
						balloon.style.opacity = '0';
				}
			}

			balloon.offsetHeight// repaint trick
			balloon.style.webkitTransitionDuration = duration;
			balloon.style.opacity = '1';
			balloon.style.webkitTransform = 'translate3d(0,0,0)';
			balloon.addEventListener('webkitTransitionEnd', transitionEnd, false);

			closeTimeout = setTimeout(close, options.lifespan);
		}

		function manualShow(override) {
			if (!isIDevice || balloon)
				return;

			overrideChecks = override;
			loaded();
		}

		function close() {
			clearInterval(positionInterval);
			clearTimeout(closeTimeout);
			closeTimeout = null;

			// check if the popup is displayed and prevent errors
			if (!balloon)
				return;

			var posY = 0, posX = 0, opacity = '1', duration = '0';

			if (options.closeButton)
				balloon.removeEventListener('click', clicked, false);
			if (!isIPad && OSVersion >= 6)
				window.removeEventListener('orientationchange', orientationCheck, false);

			if (OSVersion < 5) {
				posY = isIPad ? w.scrollY - startY : w.scrollY + w.innerHeight - startY;
				posX = isIPad ? w.scrollX - startX : w.scrollX + Math.round((w.innerWidth - balloon.offsetWidth) / 2) - startX;
			}

			balloon.style.webkitTransitionProperty = '-webkit-transform,opacity';

			switch ( options.animationOut ) {
				case 'drop':
					if (isIPad) {
						duration = '0.4s';
						opacity = '0';
						posY = posY + 50;
					} else {
						duration = '0.6s';
						posY = posY + balloon.offsetHeight + options.bottomOffset + 50;
					}
					break;
				case 'bubble':
					if (isIPad) {
						duration = '0.8s';
						posY = posY - balloon.offsetHeight - options.bottomOffset - 50;
					} else {
						duration = '0.4s';
						opacity = '0';
						posY = posY - 50;
					}
					break;
				default:
					duration = '0.8s';
					opacity = '0';
			}

			balloon.addEventListener('webkitTransitionEnd', transitionEnd, false);
			balloon.style.opacity = opacity;
			balloon.style.webkitTransitionDuration = duration;
			balloon.style.webkitTransform = 'translate3d(' + posX + 'px,' + posY + 'px,0)';
		}

		function clicked() {
			w.sessionStorage.setItem('addToHomeSession', '1');
			isSessionActive = true;
			close();
		}

		function transitionEnd() {
			balloon.removeEventListener('webkitTransitionEnd', transitionEnd, false);

			balloon.style.webkitTransitionProperty = '-webkit-transform';
			balloon.style.webkitTransitionDuration = '0.2s';

			// We reached the end!
			if (!closeTimeout) {
				balloon.parentNode.removeChild(balloon);
				balloon = null;
				return;
			}

			// On iOS 4 we start checking the element position
			if (OSVersion < 5 && closeTimeout)
				positionInterval = setInterval(setPosition, options.iterations);
		}

		function setPosition() {
			var matrix = new WebKitCSSMatrix(w.getComputedStyle(balloon, null).webkitTransform), posY = isIPad ? w.scrollY - startY : w.scrollY + w.innerHeight - startY, posX = isIPad ? w.scrollX - startX : w.scrollX + Math.round((w.innerWidth - balloon.offsetWidth) / 2) - startX;

			// Screen didn't move
			if (posY == matrix.m42 && posX == matrix.m41)
				return;

			balloon.style.webkitTransform = 'translate3d(' + posX + 'px,' + posY + 'px,0)';
		}

		// Clear local and session storages (this is useful primarily in development)
		function reset() {
			w.localStorage.removeItem('addToHome');
			w.sessionStorage.removeItem('addToHomeSession');
		}

		function orientationCheck() {
			balloon.style.marginLeft = -Math.round(balloon.offsetWidth / 2) - (w.orientation % 180 && OSVersion >= 6 ? 40 : 0 ) + 'px';
		}

		// Bootstrap!
		init();

		return {
			show : manualShow,
			close : close,
			reset : reset
		};
	})(window);
}

module.controller('forgotPasswordController', function($scope, $http, $location) {
	$scope.success = false;
	localyticsSession.tagScreen('forgotPass');

	$scope.cancel = function() {
		$location.url("/login");
	};
	flagPage = 0;
	footerFlag = 0;
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
			$scope.error = data.error;
			if (!userEmail) {
				$scope.erromsg = true;
				$scope.success = false;
			} else {
				$scope.success = true;
				$scope.erromsg = false;
			}
		}).error(function(data, status) {
			$scope.erromsg = true;
			$scope.success = false;
		});

	};
});

module.controller('resetPassController', function($scope, $http, $location, $routeParams) {
	localyticsSession.tagScreen('resetPass');
	flagPage = 0;
	footerFlag = 0;
	$scope.success = false;
	$scope.erromsg = false;
	$scope.resetPass = function() {
		//alert($routeParams.reset_password_token);
		var userPass = $scope.password;
		var userConfirmPass = $scope.confirmpassword;
		var resetPassToken = $routeParams.reset_password_token;
		if (!$scope.confirmpassword || !$scope.password) {
			$scope.error = "Please enter the password";
			$scope.success = false;
			$scope.erromsg = true;

		} else if ($scope.confirmpassword != $scope.password) {
			$scope.error = "The passwords you entered don't match, please re-enter them.";
			$scope.erromsg = true;
			$scope.success = false;
		} else {
			var param = {
				"user" : {
					"password" : userPass,
					"password_confirmation" : userConfirmPass,
					"reset_password_token" : resetPassToken
				}
			};
			$http({
				method : 'put',
				url : '/api/users/password',
				data : param,
			}).success(function(data, status) {
				$scope.success = true;
				$scope.erromsg = false;
			}).error(function(data, status) {
				$scope.error = data.errors[0];
				$scope.erromsg = true;
				$scope.success = false;
			});
		}

	};

	$scope.home = function() {
		$location.url("/login");
	};

});

module.controller('homeController', function($scope, $http, $location) {
	localyticsSession.tagScreen('Home');
	$scope.points = "";
	if (getCookie("authToken")) {
		flagPage = 0;
		footerFlag = 0;
		$scope.getUserData = function() {
			var param = {
				"auth_token" : getCookie('authToken'),
				"password" : "X"
			}

			$http({
				method : 'get',
				url : '/api/users',
				params : param
			}).success(function(data, status) {
				//var date = new Date();
				$scope.points = data.user.points_available;
				$scope.userName = data.user.first_name + " " + data.user.last_name;
				$scope.role = getCookie('userRole');
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
			}).error(function(data, status) {
				if (status == 401) {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
					deleteAllCookies();
					$location.url("/login");
				}
			});
		};

		if (getCookie("signInCount") == 1) {
			$scope.getUserData();
		}

		if (getCookie("signInCount") == 0 && getCookie('feedbackId')) {
			var param = {
				"feedback_id" : getCookie('feedbackId'),
				"auth_token" : getCookie('authToken'),
				"password" : "X"
			}
			$http({
				method : 'post',
				url : '/api/new_registration_points',
				data : param
			}).success(function(data, status) {
				//var date = new Date();
				$scope.points = data.points;
				$scope.feedbackSubmissions = 1;
				$scope.getUserData();
				//signInCount = 0;
				deleteCookie('feedbackId');
			}).error(function(data, status) {
				if (status == 401) {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
					deleteAllCookies();
					$location.url("/login");
				}
			});

		} else {
			$scope.getUserData();
		}
		//$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken') + ':X');
		// $scope.userName = getCookie('userName');
		$scope.role = getCookie('userRole');

		//document.body.style.background = #FFFFFF;

		$scope.homeClk = function() {
			$location.url("/home");
		};

		$scope.feedback = function() {
			localyticsSession.tagEvent("Leave Feedback");
			$location.url("/feedback");
		};

		$scope.redeemPoints = function() {
			localyticsSession.tagEvent("List Restaurants");
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
	localyticsSession.tagScreen('Index');
	localyticsSession.tagEvent("Start", {
		"Accessed Via" : 'Direct'
	});
	flagPage = 0;
	footerFlag = 0;
	$scope.emailCLick = function() {
		//$location.url("/login");
		window.location = "/#/login";
		localyticsSession.tagEvent("Log In");
		window.location.reload();
	};
	$scope.signUpCLick = function() {
		localyticsSession.tagEvent("Sign Up");
		$location.url("/signUp");
	};
	$scope.leaveFeedback = function() {
		$location.url("/feedback");
	};
});

module.controller('signUpController', function($scope, $http, $location) {
	localyticsSession.tagScreen('Sign Up');
	$scope.confPassword = "";
	flagPage = 0;
	footerFlag = 0;
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
		} else if (!$scope.acceptTerms) {
			$scope.error = "Please accept Kanari's User Terms";
			$scope.errorMsg = true;
		} else {
			var param = {
				"user" : {
					"first_name" : $scope.firstName,
					"last_name" : $scope.lastName,
					"email" : $scope.email,
					"gender" : "male",
					"password" : $scope.password,
					"password_confirmation" : $scope.confPassword
				}
			}
			$http({
				method : 'post',
				url : '/api/users',
				data : param
			}).success(function(data, status) {
				//setCookie('email', $scope.email, 0.29);
				//setCookie('password', $scope.password, 0.29);
				setCookie('userRole', data.user_role, 0.29);
				setCookie('authToken', data.auth_token, 0.29);
				setCookie('userName', data.first_name + ' ' + data.last_name, 0.29);
				setCookie('signInCount', data.sign_in_count, 0.29);
				localyticsSession.tagEvent("Signed Up", {
					"Type" : 'Email'
				});
				$location.url("/home");
			}).error(function(data, status) {
				if (data.errors[0] == "Email can't be blank") {
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

module.controller('signedUpController', function($scope, $http, $location, $routeParams) {
	// $scope.email = getCookie('email');
	// $scope.password = getCookie('password');
	localyticsSession.tagScreen('Signed Up');

	flagPage = 0;
	footerFlag = 0;

	$scope.errorMsg = false;

	var param = {
		"confirmation_token" : $routeParams.confirmation_token
	}

	$http({
		method : 'get',
		url : '/api/users/confirmation',
		params : param
	}).success(function(data, status) {
		localyticsSession.tagEvent("Account Confirmed");
	}).error(function(data, status) {
		$scope.errorMsg = true;
		$scope.errorMsg = data.error;
	});

	$scope.proceedAccount = function() {
		$location.url("/login");
	};
});
module.controller('changePasswordController', function($scope, $http, $location) {
	localyticsSession.tagScreen('Change Password');
	$scope.back = function() {
		$location.url("/settings");
	};
	flagPage = 0;
	footerFlag = 0;
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
				deleteCookie('authToken');
				setCookie('authToken', data.auth_token, 0.29);
				$scope.errorMsg = false;
				$scope.succMsg = true;
				$scope.currentPassword = "";
				$scope.confirmPassword = "";
				$scope.newPassword = "";
			}).error(function(data, status) {
				$scope.error = data.errors[0];
				$scope.errorMsg = true;
				$scope.succMsg = false;
			});

		}
	};

});

module.controller('settingsController', function($scope, $http, $location) {
	localyticsSession.tagScreen('Settings');
	if (getCookie('authToken')) {
		flagPage = 0;
		footerFlag = 1;
		if (getCookie('facebookFlag')) {
			$scope.changePass = false;
		} else {
			$scope.changePass = true;
		}

		$scope.succMsg = false;
		$scope.errorMsg = false;

		$scope.home = function() {
			$location.url("/home");
		};

		$scope.changePassword = function() {
			$location.url("/changePassword");
		};

		$scope.tansactionHistory = function() {
			//location.reload();
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
				if (data.user.date_of_birth) {
					date = data.user.date_of_birth.split("-");
					$scope.firstName = data.user.first_name;
					$scope.lastName = data.user.last_name;
					$scope.email = data.user.email;
					$scope.password = data.user.password;
					$scope.date = date[2] + "/" + date[1] + "/" + date[0];
					$scope.gender = data.user.gender;
					$scope.location = data.user.location;
				} else {
					$scope.firstName = data.user.first_name;
					$scope.lastName = data.user.last_name;
					$scope.email = data.user.email;
					$scope.password = data.user.password;
					$scope.date = "";
					$scope.gender = data.user.gender;
					$scope.location = data.user.location;
				}

			}).error(function(data, status) {
				if (status == 401) {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
					deleteAllCookies();
					$location.url("/login");
				}
			});

			//$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken') + ':X');
		};

		$scope.getProfile();

		$scope.saveProfile = function() {
			if (!$scope.firstName || !$scope.lastName) {
				$scope.error = "Please provide first name and last name";
				$scope.errorMsg = true;
				$scope.succMsg = false;
			} else {
				var param = {
					"user" : {
						"first_name" : $scope.firstName,
						"last_name" : $scope.lastName,
						"date_of_birth" : $scope.date,
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
					//var pt_data = {}
					var gender = '';
					var date = '';
					var city = '';

					if ($scope.gender) {
						gender = 'Yes';
					} else {
						gender = 'No';
					}
					if ($scope.date) {
						date = 'Yes';
					} else {
						date = 'No';
					}
					if ($scope.location) {
						city = 'Yes';
					} else {
						city = 'No';
					}
					localyticsSession.tagEvent("Settings Summary", {
						"Gender" : gender,
						"Date" : date,
						"City" : city
					});

					deleteCookie('authToken');
					setCookie('authToken', data.auth_token, 0.29);
					$scope.errorMsg = false;
					$scope.succMsg = true;
				}).error(function(data, status) {
					$scope.error = data.errors[0];
					$scope.errorMsg = true;
					$scope.succMsg = false;
				});
			}
		};

		$scope.logout = function() {
			localyticsSession.tagEvent("Log Out");
			var param = {
				"auth_token" : getCookie('authToken')
			}
			$http({
				method : 'delete',
				url : '/api/users/sign_out',
				data : param
			});
			$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode(getCookie('authToken'));
			deleteCookie('authToken');
			deleteCookie('userRole');
			deleteCookie('userName');
			deleteCookie('feedbackId');
			deleteCookie("signInCount");
			deleteAllCookies();
			footerFlag = 0;
			$location.url("/login");
			localyticsSession.tagEvent("Exit");
			localyticsSession.upload();
			localyticsSession.close();
		};
	} else {
		$location.url("/login");
	}
});

var pointsEarned = 0;

module.controller('feedbackController', function($scope, $http, $location) {
	localyticsSession.tagScreen('Enter Code');
	flagPage = 0;
	footerFlag = 0;
	$scope.digit1 = "";
	$scope.digit2 = "";
	$scope.digit3 = "";
	$scope.digit4 = "";
	$scope.digit5 = "";
	$scope.error = false;

	$scope.home = function() {
		if (getCookie('authToken')) {
			$location.url("/home");
		} else {
			$location.url("/index");
		}
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
			setCookie("feedbackId", data.feedback_id, 0.29);
			setCookie("restName", data.outlet_name, 0.29);
			localyticsSession.tagEvent("Enter Code");
			$location.url("/feedback_step2");
		}).error(function(data, status) {
			if (status == 401) {
				deleteCookie('authToken');
				deleteCookie('userRole');
				deleteCookie('userName');
				deleteCookie('feedbackId');
				deleteCookie("signInCount");
				deleteAllCookies();
				$location.url("/login");
			}
			$scope.errorMsg = data.errors[0];
			$scope.error = true;
		});

	};
	
	// $scope.ValidatePassKey = function(first,second) {
 	 // if($("#digit"+first).val().length == 1)
 	  // // inputs.eq( inputs.index(this)+ 1 ).focus();
 	   // $("#digit"+second).click();
//  	   
 	   // alert("digit"+second);
 	// };
 	
 	$('.txtPin').keypress(function() {
    var value = $(this).val();
    if(value.length >= 1) {
        var inputs = $(this).closest('form').find(':input');
        inputs.eq( inputs.index(this)+ 1 ).focus();
    }
});

var max_chars = 1;

$('#digit4').keydown( function(e){
	//alert("here");
    if ($(this).val().length >= 1) { 
        $(this).val($(this).val().substr(0, max_chars));
    }
});

$('#digit4').keyup( function(e){
	$(this).type='text';
    if ($(this).val().length >= 1) { 
        $(this).val($(this).val().substr(0, max_chars));
    }
});
	
});

module.controller('feedback_step2Controller', function($scope, $http, $location) {
	localyticsSession.tagScreen('Feedback 1/3');
	flagPage = 1;
	footerFlag = 0;
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
	$scope.feedBackCategoryName = ["food", "friendliness", "speed", "ambiance", "cleanliness", "value"];
	$(".nxt").css("width", "100%");
	$(".nxt img").css("padding-top", "0");

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
		$scope.willRecommend = parseInt(count);
	};

	var response = 0;
	$scope.categoryname = "";
	$scope.select_feedback_category = function(category) {
		category_switch = 0;
		if ($scope.like) {
			if ($scope.feedBackArray[category] == 0) {
				$scope.feedBackArray[category] = 1;
				$("#feed_" + category + " img").attr('src', '/icons/icon_' + $scope.feedBackCategoryName[category] + '4.svg');
				$("#feed_" + category).css("background-color", "#664765");
				$("#feed_" + category + " span").css("color", "#E5E6E8");
			} else if ($scope.feedBackArray[category] == 1) {
				$scope.feedBackArray[category] = 0;
				$("#feed_" + category + " img").attr('src', '/icons/icon_' + $scope.feedBackCategoryName[category] + '3.svg');
				$("#feed_" + category).css("background-color", "#E5E6E8");
				$("#feed_" + category + " span").css("color", "#664765");
			}

		} else {
			if ($scope.feedBackArray[category] == 0) {
				$scope.feedBackArray[category] = -1;
				$("#feed_" + category + " img").attr('src', '/icons/icon_' + $scope.feedBackCategoryName[category] + '2.svg');
				$("#feed_" + category).css("background-color", "#664765");
				$("#feed_" + category + " span").css("color", "#E5E6E8");
			} else if ($scope.feedBackArray[category] == -1) {
				$scope.feedBackArray[category] = 0;
				$("#feed_" + category + " img").attr('src', '/icons/icon_' + $scope.feedBackCategoryName[category] + '1.svg');
				$("#feed_" + category).css("background-color", "#E5E6E8");
				$("#feed_" + category + " span").css("color", "#664765");
			}
		}

	};

	$scope.next = function() {
		if ($scope.nextFlag == 0) {
			localyticsSession.tagScreen('Feedback 2/3');
			for (var i = 0; i < $scope.feedBackSize; i++) {
				if ($scope.feedBackArray[i] == 0) {
					$scope.feedBackArray[i] = 0;
					$("#feed_" + i + " img").attr('src', '/icons/icon_' + $scope.feedBackCategoryName[i] + '1.svg');
					$("#feed_" + i).css("background-color", "#E5E6E8");
					$("#feed_" + i + " span").css("color", "#664765");
				} else if ($scope.feedBackArray[i] == 1) {
					$scope.feedBackArray[i] = 1;
					$("#feed_" + i + " img").attr('src', '/icons/icon_' + $scope.feedBackCategoryName[i] + '2.svg');
					$("#feed_" + i).css("background-color", "#CCCCCC");
					$("#feed_" + i + " span").css("color", "#664765");
				} else if ($scope.feedBackArray[i] == -1) {
					$scope.feedBackArray[i] = -1;
					$("#feed_" + i + " img").attr('src', '/icons/icon_' + $scope.feedBackCategoryName[i] + '2.svg');
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
			$(".nxt").css("width", "50.22%");
			$(".nxt img").css("padding-top", "1%");
		} else if ($scope.nextFlag == 1) {
			localyticsSession.tagScreen('Feedback 3/3');
			$scope.like = false;
			$scope.dislike = false;
			$scope.recomendation = true;
			$scope.recomendationBar = true;
			$scope.optionKeypad = false;
			$scope.prev = true;
			$scope.prevFlag = 1;
			$scope.nextFlag = -1;
			$(".nxt").css("width", "50.22%");
			$(".nxtTxt").html("SUBMIT");
			$scope.erromsg = false;
			$(".nxt img").hide();
		} else if ($scope.nextFlag == -1) {
			if (!$scope.willRecommend) {
				if ($scope.willRecommend == '0') {
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
						setCookie("pointsEarned", data.points, 0.29);
						$scope.erromsg = false;
						if (!$("#comment").val()) {
							if (data.points > 0 && data.points < 5) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '0-5'
								});
							} else if (data.points >= 5 && data.points < 10) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '5-10'
								});
							} else if (data.points >= 10 && data.points < 30) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '10-30'
								});
							} else if (data.points >= 30 && data.points < 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '30-50'
								});
							} else if (data.points >= 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '50+'
								});
							}
						} else if ($("#comment").val()) {
							if (data.points > 0 && data.points < 5) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '0-5'
								});
							} else if (data.points >= 5 && data.points < 10) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '5-10'
								});
							} else if (data.points >= 10 && data.points < 30) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '10-30'
								});
							} else if (data.points >= 30 && data.points < 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '30-50'
								});
							} else if (data.points >= 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '50+'
								});
							}
						}

						if (getCookie('authToken')) {
							$location.url("/feedbackSubmitSuccess");
							deleteCookie('feedbackId');
						} else {
							feedbackFlag = 1;
							$location.url("/signUp");
							//deleteCookie('feedbackId');
						}
					}).error(function(data, status) {
						if (status == 401) {
							deleteCookie('authToken');
							deleteCookie('userRole');
							deleteCookie('userName');
							deleteCookie('feedbackId');
							deleteCookie("signInCount");
							deleteAllCookies();
							$location.url("/login");
						} else if (status == 404) {
							$scope.error = "Code expired"
							$scope.erromsg1 = true;
						} else {
							$scope.error = data.errors[0];
							$scope.erromsg1 = true;
						}
						deleteCookie('feedbackId');
					});

				} else {
					$scope.error = "Your feedback is valuable! We'd really appreciate you answering the above questions.";
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
					pointsEarned = data.points;
					setCookie("pointsEarned", data.points, 0.29);
					$scope.erromsg = false;
					if (getCookie('authToken')) {
						if (!$("#comment").val()) {
							if (data.points > 0 && data.points < 5) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '0-5'
								});
							} else if (data.points >= 5 && data.points < 10) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '5-10'
								});
							} else if (data.points >= 10 && data.points < 30) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '10-30'
								});
							} else if (data.points >= 30 && data.points < 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '30-50'
								});
							} else if (data.points >= 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '50+'
								});
							}
						} else if ($("#comment").val()) {
							if (data.points > 0 && data.points < 5) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '0-5'
								});
							} else if (data.points >= 5 && data.points < 10) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '5-10'
								});
							} else if (data.points >= 10 && data.points < 30) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '10-30'
								});
							} else if (data.points >= 30 && data.points < 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '30-50'
								});
							} else if (data.points >= 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '50+'
								});
							}
						}
						$location.url("/feedbackSubmitSuccess");
						deleteCookie('feedbackId');
					} else {
						if (!$("#comment").val()) {
							if (data.points > 0 && data.points < 5) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '0-5'
								});
							} else if (data.points >= 5 && data.points < 10) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '5-10'
								});
							} else if (data.points >= 10 && data.points < 30) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '10-30'
								});
							} else if (data.points >= 30 && data.points < 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '30-50'
								});
							} else if (data.points >= 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'No',
									"Points" : '50+'
								});
							}
						} else if ($("#comment").val()) {
							if (data.points > 0 && data.points < 5) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '0-5'
								});
							} else if (data.points >= 5 && data.points < 10) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '5-10'
								});
							} else if (data.points >= 10 && data.points < 30) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '10-30'
								});
							} else if (data.points >= 30 && data.points < 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '30-50'
								});
							} else if (data.points >= 50) {
								localyticsSession.tagEvent("Submit Feedback", {
									"Comment" : 'Yes',
									"Points" : '50+'
								});
							}
						}
						feedbackFlag = 1;
						$location.url("/signUp");
						//deleteCookie('feedbackId');
					}
				}).error(function(data, status) {
					if (status == 401) {
						deleteCookie('authToken');
						deleteCookie('userRole');
						deleteCookie('userName');
						deleteCookie('feedbackId');
						deleteCookie("signInCount");
						deleteAllCookies();
						$location.url("/login");
					} else if (status == 404) {
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
		if ($scope.prevFlag == 0) {
			localyticsSession.tagScreen('Feedback 1/3');
			for (var i = 0; i < $scope.feedBackSize; i++) {
				if ($scope.feedBackArray[i] == 0) {
					$scope.feedBackArray[i] = 0;
					$("#feed_" + i + " img").attr('src', '/icons/icon_' + $scope.feedBackCategoryName[i] + '3.svg');
					$("#feed_" + i).css("background-color", "#E5E6E8");
					$("#feed_" + i + " span").css("color", "#664765");
				} else if ($scope.feedBackArray[i] == -1) {
					$scope.feedBackArray[i] = -1;
					$("#feed_" + i + " img").attr('src', '/icons/icon_' + $scope.feedBackCategoryName[i] + '4.svg');
					$("#feed_" + i).css("background-color", "#CCCCCC");
					$("#feed_" + i + " span").css("color", "#664765");
				} else if ($scope.feedBackArray[i] == 1) {
					$scope.feedBackArray[i] = 1;
					$("#feed_" + i + " img").attr('src', '/icons/icon_' + $scope.feedBackCategoryName[i] + '4.svg');
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
			$(".nxt img").css("padding-top", "0%");
			$scope.nextFlag = 0;
		} else if ($scope.prevFlag == 1) {
			localyticsSession.tagScreen('Feedback 2/3');
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
			$(".nxt img").css("padding-top", "1%");
		}
	};
});

var socialMessage;
var tweetMessage;
module.controller('feedbackSubmitController', function($scope, $http, $routeParams, $location) {
	localyticsSession.tagScreen('Feedback Submitted');
	if (getCookie('authToken')) {
		flagPage = 0;
		footerFlag = 0;
		$("#fbShareSuccMsg").hide();
		$("#tweetShareSuccMsg").hide();
		$("#gPlusShareSuccMsg").hide();
		$scope.tweetShareSuccMsg = false;
		if (getCookie('pointsEarned')) {
			$scope.points = getCookie('pointsEarned');
		} else {
			$location.url("/home");
		}

		socialMessage = 'I just saved AED ' + getCookie('pointsEarned') + ' by leaving feedback at ' + getCookie('restName') + '. Thanks Kanari! Check it out: http://kanari.co';
		tweetMessage = 'I just saved AED ' + getCookie('pointsEarned') + ' by leaving feedback at ' + getCookie('restName') + '. Thanks @GetKanari! Check it out: http://kanari.co';

		$scope.home = function() {
			deleteCookie('pointsEarned');
			deleteCookie('restName');
			$location.url("/home");
		};

		$scope.twitter = function() {
			var popup = window.open("https://twitter.com/share?text=" + tweetMessage, 'popUpWindow', 'height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes');

			var timer = setInterval(function() {
				if (popup.closed) {
					clearInterval(timer);
					//alert('closed');
					$("#fbShareSuccMsg").hide();
					localyticsSession.tagEvent("Social Share", {
						"Platform" : 'Twitter'
					});
					$("#tweetShareSuccMsg").show();
				}
			}, 1000);
		};

		$scope.google = function() {
			var popup = window.open("https://plus.google.com/share?data-text=lkjnkln" + socialMessage, 'popUpWindow', 'height=500,width=400,left=100,top=100,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes');
			localyticsSession.tagEvent("Social Share", {
				"Platform" : 'Google+'
			});
		};

	} else {
		$location.url("/login");
	}
});

module.controller('restaurantListController', function($scope, $http, $location) {
	localyticsSession.tagScreen('Restaurant Listing');
	if (getCookie('authToken')) {
		$scope.outlets = [];
		flagPage = 1;
		footerFlag = 0;
		$scope.home = function() {
			$location.url("/home");
		};

		$scope.previous = function() {
			$location.url("/home");
		};

		$scope.authToken = getCookie('authToken');

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
				$scope.outlets = data.outlets;
			}).error(function(data, status) {
				if (status == 401) {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie('pointsEarned');
					deleteCookie("signInCount");
					deleteAllCookies();
					$location.url("/login");
				}
			});

		};
		$scope.getRestaurantList();

		$scope.redeemPoint = function(outletId) {
			localyticsSession.tagEvent("Redeem Points", {
				"Clicked From" : 'Listing'
			});
			$location.url("/confirmRedeem?outletId=" + outletId);
		};

		$scope.showRestaurant = function(outletId) {
			$location.url("/showRestaurant?outletId=" + outletId);
		};

		$scope.setLocalytics = function() {
			localyticsSession.tagEvent("Search Restaurant");
		};

	} else {
		$location.url("/login");
	}
});

function truncate(string) {
	if (string.length > 15)
		return string.substring(0, 13) + '...';
	else
		return string;
};

module.controller('showRestaurantController', function($scope, $http, $routeParams, $location) {
	localyticsSession.tagScreen('Restaurant Details');
	if (getCookie('authToken')) {
		$.mobile.loading('show');
		flagPage = 1;
		footerFlag = 0;
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
			$scope.outletID = data.outlet.id;
			$scope.restaurant_name = truncate(data.outlet.name);
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
			localyticsSession.tagEvent("View Restaurant", {
				"Name" : data.outlet.name
			});
		}).error(function(data, status) {
			if (status == 401) {
				deleteCookie('authToken');
				deleteCookie('userRole');
				deleteCookie('userName');
				deleteCookie('feedbackId');
				deleteCookie("signInCount");
				deleteAllCookies();
				$location.url("/login");
			}
		});

		$scope.home = function() {
			$location.url("/home");
		};

		$scope.previous = function() {
			$location.url("/redeemPoints");
		};

		$scope.redeemUpto = function() {
			localyticsSession.tagEvent("Redeem Points", {
				"Clicked From" : 'Details'
			});
			$location.url("/confirmRedeem?outletId=" + $routeParams.outletId);
		};

		$scope.email = function() {
			localyticsSession.tagEvent("Email");
		};

		$scope.phone = function() {
			localyticsSession.tagEvent("Phone");
		};

		$scope.locationMap = function() {
			localyticsSession.tagEvent("View Map");
			$location.url("/locationMap?outletId=" + $routeParams.outletId + "&lat=" + $scope.lattitude + "&long=" + $scope.longitude);
		};
		$.mobile.loading('hide');
	} else {
		$location.url("/login");
	}

});

module.controller('redeemPointsController', function($scope, $http, $location, $routeParams) {
	localyticsSession.tagScreen('Redeem Points');
	if (getCookie('authToken')) {
		flagPage = 0;
		footerFlag = 0;
		$scope.successMsg = false;
		$scope.erromsg = false;

		$scope.previous = function() {
			window.history.back();
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
				url : '/api/outlets/' + $routeParams.outletId,
				params : param
			}).success(function(data, status) {
				$scope.points = data.outlet.redeemable_points;
			}).error(function(data, status) {
				if (status == 401) {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
					deleteAllCookies();
					$location.url("/login");
				}
			});
		};

		$scope.listPoints();

		$scope.confirmRedeem = function() {
			if (!$scope.amount) {
				$scope.error = "Please enter valid amount for redemption";
				$scope.successMsg = false;
				$scope.erromsg = true;
			} else if ($scope.amount < 0 || $scope.amount == 0) {
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
					if ($scope.amount > 0 && $scope.amount < 50) {
						localyticsSession.tagEvent("Request Redemption", {
							"Discount" : '0-50'
						});
					} else if ($scope.amount >= 50 && $scope.amount < 100) {
						localyticsSession.tagEvent("Request Redemption", {
							"Discount" : '50-100'
						});
					} else if ($scope.amount >= 100 && $scope.amount < 300) {
						localyticsSession.tagEvent("Request Redemption", {
							"Discount" : '100-300'
						});
					} else if ($scope.amount >= 300 && $scope.amount < 500) {
						localyticsSession.tagEvent("Request Redemption", {
							"Discount" : '300-500'
						});
					} else if ($scope.amount >= 500) {
						localyticsSession.tagEvent("Request Redemption", {
							"Discount" : '500+'
						});
					}
					$scope.listPoints();
					$("#overlaySuccess").show();
					$("#overlaySuccess").css({
						'z-index' : '10',
						'background-color' : '#000'
					});
					$scope.successMsg = true;
					$scope.erromsg = false;
				}).error(function(data, status) {
					$scope.error = data.errors[0];
					$scope.successMsg = false;
					$scope.erromsg = true;
				});
			}

		};
		$scope.closeRedeemSuccMsg = function() {
			$("#overlaySuccess").hide();
			$scope.listPoints();
			$scope.successMsg = false;
			$location.url("/home");
		}
	} else {
		$location.url("/login");
	}
});

module.controller('transactionHistoryController', function($scope, $http, $location) {
	localyticsSession.tagScreen('Transaction History');
	if (getCookie('authToken')) {
		flagPage = 1;
		footerFlag = 0;
		$scope.home = function() {
			$location.url("/home");
		};

		$scope.previous = function() {
			$location.url("/settings");
		};

		var param = {
			"auth_token" : getCookie('authToken'),
			"password" : 'X'
		}

		$http({
			method : 'get',
			url : '/api/activities',
			params : param
		}).success(function(data, status) {
			$scope.transactionHList = data.activities;
		}).error(function(data, status) {
			if (status == 401) {
				deleteCookie('authToken');
				deleteCookie('userRole');
				deleteCookie('userName');
				deleteCookie('feedbackId');
				deleteCookie("signInCount");
				deleteAllCookies();
				$location.url("/login");
			}
		});

	} else {
		$location.url("/login");
	}
});

module.controller('locationMapController', function($scope, $http, $location, $routeParams) {
	localyticsSession.tagScreen('Restaurant Map');
	$.mobile.loading('show');

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

function setFooter(valueH) {
}


$(document).on("pageshow", ".ui-page", function() {
	localyticsSession.upload();
	$('#date').scroller({
		theme : "ios",
		mode : "scroller",
		display : "bottom",
		dateFormat : 'dd/mm/yy'
	});
	
	
	// $('.fblogin').click(function(event) {
		// console.log(event);
		// event.preventDefault();
		// //Facebook.login()
        // window.location = "http://localhost:8080/#/home";
	// });

	var $page = $(this), vSpace = $page.children('.ui-header').outerHeight() + $page.children('.ui-footer').outerHeight() + $page.children('.ui-content').height();
	$("#divexample1").css('height', '400px');
	if (vSpace < $(window).height()) {
		$page.height($(window).height());
	}
	if ($page.outerHeight() > vSpace) {
		$page.children('.ui-footer').css('position', 'absolute');
	} else {
		$page.children('.ui-footer').css('position', 'relative');
		if (flagPage == 0) {
			$page.children('.ui-footer').css('margin-top', '14px');
		} else {
			$page.children('.ui-footer').css('margin-top', '0');
		}
		//alert("scroll");
	}

	function setFooterIphone() {
		if ($page.height() > $(window).height()) {
			$("#divexample1").css('height', '320px');
			$page.children('.ui-footer').css('position', 'relative');
			if (flagPage == 0) {
				$page.children('.ui-footer').css('margin-top', '14px');
			} else {
				$page.children('.ui-footer').css('margin-top', '0');
			}

		} else {
			//alert("height sufficient no need to scroll")
		}
	}

	//document.write("You are using iOS5");
});
//}

document.ontouchmove = function(e) {
}
function iOSversion() {
	if (/iP(hone|od|ad)/.test(navigator.platform)) {
		// supports iOS 2.0 and later: <http://bit.ly/TJjs1V>
		var v = (navigator.appVersion).match(/OS (\d+)_(\d+)_?(\d+)?/);
		return [parseInt(v[1], 10), parseInt(v[2], 10), parseInt(v[3] || 0, 10)];
	}
}

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

function deleteAllCookies() {
	var cookies = document.cookie.split(";");

	for (var i = 0; i < cookies.length; i++) {
		var cookie = cookies[i];
		var eqPos = cookie.indexOf("=");
		var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
		document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
	}
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

function moveToNext(field, nextFieldID) {
	if (field.value.length >= field.maxLength) {
		document.getElementById(nextFieldID).focus();
	}
}


$(document).ready(function() {
	$('.backColr').live('touchstart', function(e) {
		$(this).addClass('backColr1');
	});

	$('.backColr').live('touchend', function(e) {
		$(this).removeClass('backColr1');
		$(this).addClass('backColr');
	});
	$('.clearBackColr').live('touchstart', function(e) {
		$(this).addClass('clearBackColr1');
	});

	$('.clearBackColr').live('touchend', function(e) {
		$(this).removeClass('clearBackColr1');
		$(this).addClass('clearBackColr');
	});

});

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
					localyticsSession.tagEvent("Signed Up", {
						"Type" : 'Facebook'
					});
					self.auth = response.authResponse;
					FB.api('/me', function(response) {
						var dt = new Date(response.birthday);
						var month = dt.getMonth() + 1;
						var startDt = dt.getFullYear() + "-" + month + "-" + dt.getDate();
						var param = {
							"user" : {
								"first_name" : response.first_name,
								"last_name" : response.last_name,
								"email" : response.email,
								"gender" : response.gender,
								"date_of_birth" : startDt
							},
							"oauth_provider" : "facebook",
							"access_token" : self.auth.accessToken
						};

						$http({
							method : 'post',
							url : '/api/users',
							data : param
						}).success(function(data) {
							if (data.registration_complete == true) {
								setCookie('userRole', data.user_role, 0.29);
								setCookie('authToken', data.auth_token, 0.29);
								setCookie('signInCount', data.sign_in_count, 0.29);
								setCookie('userName', data.first_name + ' ' + data.last_name, 0.29);
								setCookie('facebookFlag', '1', 0.29);
								localyticsSession.tagEvent("Logged In", {
									"Type" : 'Facebook'
								});
								$location.url('/home');
							} else {
								//$location.url("/signedUp");
							}
						}).error(function(data) {

						});

					});
				} else {
				}
			}, {
				scope : 'email,user_birthday',
				redirect_uri : 'http://www.google.com'
			});
		},

		signUp : function() {
			$('#loginForm').addClass('loginClosed');
			$('#loginForm').replaceWith($('#registerFormContainer').html());
		},

		share : function() {
			FB.login(function(response) {
				if (response.authResponse) {
					FB.api('/me/feed', 'post', {
						message : socialMessage
					}, function(response) {
						if (!response || response.error) {
						} else {
							localyticsSession.tagEvent("Social Share", {
								"Platform" : 'Facebook'
							});
							$("#fbShareSuccMsg").show();
						}
					});

				} else {
				}
			}, {
				scope : 'publish_stream'
			});

		},
	}

});

window.fbAsyncInit = function() {
	FB.init({
		//appId : '369424903187034'
		appId : '169570039884537'
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

window.addEventListener('load', function(e) {
	setTimeout(function() {
		window.scrollTo(0, 1);
	}, 1);
}, false);
