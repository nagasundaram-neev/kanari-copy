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
var redemTimeout;
var localyticsSession = LocalyticsSession("a82f806f8ee66e07a62c716-e5454e1c-5375-11e3-926f-005cf8cbabd8");
localyticsSession.open();

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
		overlayDiv.css({
			'z-index' : '0',
			'background-color' : 'transparent'
		});
	};

	$scope.logout = function() {
		var param = {
			"auth_token" : getCookie('authToken')
		}
		$http({
			method : 'delete',
			url : '/api/users/sign_out',
			data : param
		}).success(function(data, status) {
			$(".userloggedIn").hide();

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
			localyticsSession.tagEvent("Exit");
			localyticsSession.upload();
			localyticsSession.close();

		}).error(function(data, status) {
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
	if (getCookie("authToken")) {
		$location.url("/feedback");
	}
	else{
	clearInterval(refreshIntervalId);
	$("#wrapper").removeClass("clsafterLogin");
	$("#wrapper").addClass("clsforLogin");
	$(".userloggedIn").hide();
	$('#overlaySuccess img').hide();
	$scope.chkLogin = function() {
		if ($scope.email == "" && $scope.password == "" && !$scope.email && !$scope.password) {
			$scope.error = " Please enter Email and Password";
			$scope.erromsg = true;
			return false;
		}
		var param = "{email:'" + $scope.email + "@kanari.co','password:'" + $scope.password + "'}";
		$http({
			method : 'post',
			url : '/api/users/sign_in',
		}).success(function(data, status) {
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
			if (data.errors == "Inactive User") {
				$scope.error = "Outlet assigned to you is disabled";
				$scope.erromsg = true;
			} else {
				$scope.error = "Invalid Id or Password";
				$scope.erromsg = true;
			}
		});
	};

	$scope.$watch('email + password', function() {
		$http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode($scope.email + '@kanari.co:' + $scope.password);
	});
	
}
addToIphoneHomePage();


});

//Function to call addtohomepage on Iphone
function addToIphoneHomePage(){
	var addToHome = (function (w) {
	var nav = w.navigator,
		isIDevice = 'platform' in nav && (/iphone|ipod|ipad/gi).test(nav.platform),
		isIPad,
		isRetina,
		isSafari,
		isStandalone,
		OSVersion,
		startX = 0,
		startY = 0,
		lastVisit = 0,
		isExpired,
		isSessionActive,
		isReturningVisitor,
		balloon,
		overrideChecks,

		positionInterval,
		closeTimeout,

		options = {
			autostart: true,			// Automatically open the balloon
			returningVisitor: false,	// Show the balloon to returning visitors only (setting this to true is HIGHLY RECCOMENDED)
			animationIn: 'drop',		// drop || bubble || fade
			animationOut: 'fade',		// drop || bubble || fade
			startDelay: 2000,			// 2 seconds from page load before the balloon appears
			lifespan: 15000,			// 15 seconds before it is automatically destroyed
			bottomOffset: 14,			// Distance of the balloon from bottom
			expire: 0,					// Minutes to wait before showing the popup again (0 = always displayed)
			message: '',				// Customize your message or force a language ('' = automatic)
			touchIcon: false,			// Display the touch icon
			arrow: true,				// Display the balloon arrow
			hookOnLoad: true,			// Should we hook to onload event? (really advanced usage)
			closeButton: true,			// Let the user close the balloon
			iterations: 100				// Internal/debug use
		},

		intl = {
			ar:    '<span dir="rtl">قم بتثبيت هذا التطبيق على <span dir="ltr">%device:</span>انقر<span dir="ltr">%icon</span> ،<strong>ثم اضفه الى الشاشة الرئيسية.</strong></span>',
			ca_es: 'Per instal·lar aquesta aplicació al vostre %device premeu %icon i llavors <strong>Afegir a pantalla d\'inici</strong>.',
			cs_cz: 'Pro instalaci aplikace na Váš %device, stiskněte %icon a v nabídce <strong>Přidat na plochu</strong>.',
			da_dk: 'Tilføj denne side til din %device: tryk på %icon og derefter <strong>Føj til hjemmeskærm</strong>.',
			de_de: 'Installieren Sie diese App auf Ihrem %device: %icon antippen und dann <strong>Zum Home-Bildschirm</strong>.',
			el_gr: 'Εγκαταστήσετε αυτήν την Εφαρμογή στήν συσκευή σας %device: %icon μετά πατάτε <strong>Προσθήκη σε Αφετηρία</strong>.',
			en_us: 'Install this web app on your %device: tap %icon and then <strong>Add to Home Screen</strong>.',
			es_es: 'Para instalar esta app en su %device, pulse %icon y seleccione <strong>Añadir a pantalla de inicio</strong>.',
			fi_fi: 'Asenna tämä web-sovellus laitteeseesi %device: paina %icon ja sen jälkeen valitse <strong>Lisää Koti-valikkoon</strong>.',
			fr_fr: 'Ajoutez cette application sur votre %device en cliquant sur %icon, puis <strong>Ajouter à l\'écran d\'accueil</strong>.',
			he_il: '<span dir="rtl">התקן אפליקציה זו על ה-%device שלך: הקש %icon ואז <strong>הוסף למסך הבית</strong>.</span>',
			hr_hr: 'Instaliraj ovu aplikaciju na svoj %device: klikni na %icon i odaberi <strong>Dodaj u početni zaslon</strong>.',
			hu_hu: 'Telepítse ezt a web-alkalmazást az Ön %device-jára: nyomjon a %icon-ra majd a <strong>Főképernyőhöz adás</strong> gombra.',
			it_it: 'Installa questa applicazione sul tuo %device: premi su %icon e poi <strong>Aggiungi a Home</strong>.',
			ja_jp: 'このウェブアプリをあなたの%deviceにインストールするには%iconをタップして<strong>ホーム画面に追加</strong>を選んでください。',
			ko_kr: '%device에 웹앱을 설치하려면 %icon을 터치 후 "홈화면에 추가"를 선택하세요',
			nb_no: 'Installer denne appen på din %device: trykk på %icon og deretter <strong>Legg til på Hjem-skjerm</strong>',
			nl_nl: 'Installeer deze webapp op uw %device: tik %icon en dan <strong>Voeg toe aan beginscherm</strong>.',
			pl_pl: 'Aby zainstalować tę aplikacje na %device: naciśnij %icon a następnie <strong>Dodaj jako ikonę</strong>.',
			pt_br: 'Instale este aplicativo em seu %device: aperte %icon e selecione <strong>Adicionar à Tela Inicio</strong>.',
			pt_pt: 'Para instalar esta aplicação no seu %device, prima o %icon e depois o <strong>Adicionar ao ecrã principal</strong>.',
			ru_ru: 'Установите это веб-приложение на ваш %device: нажмите %icon, затем <strong>Добавить в «Домой»</strong>.',
			sv_se: 'Lägg till denna webbapplikation på din %device: tryck på %icon och därefter <strong>Lägg till på hemskärmen</strong>.',
			th_th: 'ติดตั้งเว็บแอพฯ นี้บน %device ของคุณ: แตะ %icon และ <strong>เพิ่มที่หน้าจอโฮม</strong>',
			tr_tr: 'Bu uygulamayı %device\'a eklemek için %icon simgesine sonrasında <strong>Ana Ekrana Ekle</strong> düğmesine basın.',
			zh_cn: '您可以将此应用程式安装到您的 %device 上。请按 %icon 然后点选<strong>添加至主屏幕</strong>。',
			zh_tw: '您可以將此應用程式安裝到您的 %device 上。請按 %icon 然後點選<strong>加入主畫面螢幕</strong>。'
		};

	function init () {
		// Preliminary check, all further checks are performed on iDevices only
		if ( !isIDevice ) return;

		var now = Date.now(),
			title,
			i;

		// Merge local with global options
		if ( w.addToHomeConfig ) {
			for ( i in w.addToHomeConfig ) {
				options[i] = w.addToHomeConfig[i];
			}
		}
		if ( !options.autostart ) options.hookOnLoad = false;

		isIPad = (/ipad/gi).test(nav.platform);
		isRetina = w.devicePixelRatio && w.devicePixelRatio > 1;
		isSafari = (/Safari/i).test(nav.appVersion) && !(/CriOS/i).test(nav.appVersion);
		isStandalone = nav.standalone;
		OSVersion = nav.appVersion.match(/OS (\d+_\d+)/i);
		OSVersion = OSVersion[1] ? +OSVersion[1].replace('_', '.') : 0;

		lastVisit = +w.localStorage.getItem('addToHome');

		isSessionActive = w.sessionStorage.getItem('addToHomeSession');
		isReturningVisitor = options.returningVisitor ? lastVisit && lastVisit + 28*24*60*60*1000 > now : true;

		if ( !lastVisit ) lastVisit = now;

		// If it is expired we need to reissue a new balloon
		isExpired = isReturningVisitor && lastVisit <= now;

		if ( options.hookOnLoad ) w.addEventListener('load', loaded, false);
		else if ( !options.hookOnLoad && options.autostart ) loaded();
	}

	function loaded () {
		w.removeEventListener('load', loaded, false);

		if ( !isReturningVisitor ) w.localStorage.setItem('addToHome', Date.now());
		else if ( options.expire && isExpired ) w.localStorage.setItem('addToHome', Date.now() + options.expire * 60000);

		if ( !overrideChecks && ( !isSafari || !isExpired || isSessionActive || isStandalone || !isReturningVisitor ) ) return;

		var touchIcon = '',
			platform = nav.platform.split(' ')[0],
			language = nav.language.replace('-', '_'),
			i, l;

		balloon = document.createElement('div');
		balloon.id = 'addToHomeScreen';
		balloon.style.cssText += 'left:-9999px;-webkit-transition-property:-webkit-transform,opacity;-webkit-transition-duration:0;-webkit-transform:translate3d(0,0,0);position:' + (OSVersion < 5 ? 'absolute' : 'fixed');

		// Localize message
		if ( options.message in intl ) {		// You may force a language despite the user's locale
			language = options.message;
			options.message = '';
		}
		if ( options.message === '' ) {			// We look for a suitable language (defaulted to en_us)
			options.message = language in intl ? intl[language] : intl['en_us'];
		}

		if ( options.touchIcon ) {
			touchIcon = isRetina ?
				document.querySelector('head link[rel^=apple-touch-icon][sizes="114x114"],head link[rel^=apple-touch-icon][sizes="144x144"]') :
				document.querySelector('head link[rel^=apple-touch-icon][sizes="57x57"],head link[rel^=apple-touch-icon]');

			if ( touchIcon ) {
				touchIcon = '<span style="background-image:url(' + touchIcon.href + ')" class="addToHomeTouchIcon"></span>';
			}
		}

		balloon.className = (isIPad ? 'addToHomeIpad' : 'addToHomeIphone') + (touchIcon ? ' addToHomeWide' : '');
		balloon.innerHTML = touchIcon +
			options.message.replace('%device', platform).replace('%icon', OSVersion >= 4.2 ? '<span class="addToHomeShare"></span>' : '<span class="addToHomePlus">+</span>') +
			(options.arrow ? '<span class="addToHomeArrow"></span>' : '') +
			(options.closeButton ? '<span class="addToHomeClose">\u00D7</span>' : '');

		document.body.appendChild(balloon);

		// Add the close action
		if ( options.closeButton ) balloon.addEventListener('click', clicked, false);

		if ( !isIPad && OSVersion >= 6 ) window.addEventListener('orientationchange', orientationCheck, false);

		setTimeout(show, options.startDelay);
	}

	function show () {
		var duration,
			iPadXShift = 208;

		// Set the initial position
		if ( isIPad ) {
			if ( OSVersion < 5 ) {
				startY = w.scrollY;
				startX = w.scrollX;
			} else if ( OSVersion < 6 ) {
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

			if ( OSVersion < 5 ) {
				startX = Math.round((w.innerWidth - balloon.offsetWidth) / 2) + w.scrollX;
				balloon.style.left = startX + 'px';
				balloon.style.top = startY - balloon.offsetHeight - options.bottomOffset + 'px';
			} else {
				balloon.style.left = '50%';
				balloon.style.marginLeft = -Math.round(balloon.offsetWidth / 2) - ( w.orientation%180 && OSVersion >= 6 ? 40 : 0 ) + 'px';
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

		balloon.offsetHeight;	// repaint trick
		balloon.style.webkitTransitionDuration = duration;
		balloon.style.opacity = '1';
		balloon.style.webkitTransform = 'translate3d(0,0,0)';
		balloon.addEventListener('webkitTransitionEnd', transitionEnd, false);

		closeTimeout = setTimeout(close, options.lifespan);
	}

	function manualShow (override) {
		if ( !isIDevice || balloon ) return;

		overrideChecks = override;
		loaded();
	}

	function close () {
		clearInterval( positionInterval );
		clearTimeout( closeTimeout );
		closeTimeout = null;

		// check if the popup is displayed and prevent errors
		if ( !balloon ) return;

		var posY = 0,
			posX = 0,
			opacity = '1',
			duration = '0';

		if ( options.closeButton ) balloon.removeEventListener('click', clicked, false);
		if ( !isIPad && OSVersion >= 6 ) window.removeEventListener('orientationchange', orientationCheck, false);

		if ( OSVersion < 5 ) {
			posY = isIPad ? w.scrollY - startY : w.scrollY + w.innerHeight - startY;
			posX = isIPad ? w.scrollX - startX : w.scrollX + Math.round((w.innerWidth - balloon.offsetWidth)/2) - startX;
		}

		balloon.style.webkitTransitionProperty = '-webkit-transform,opacity';

		switch ( options.animationOut ) {
			case 'drop':
				if ( isIPad ) {
					duration = '0.4s';
					opacity = '0';
					posY = posY + 50;
				} else {
					duration = '0.6s';
					posY = posY + balloon.offsetHeight + options.bottomOffset + 50;
				}
				break;
			case 'bubble':
				if ( isIPad ) {
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


	function clicked () {
		w.sessionStorage.setItem('addToHomeSession', '1');
		isSessionActive = true;
		close();
	}

	function transitionEnd () {
		balloon.removeEventListener('webkitTransitionEnd', transitionEnd, false);

		balloon.style.webkitTransitionProperty = '-webkit-transform';
		balloon.style.webkitTransitionDuration = '0.2s';

		// We reached the end!
		if ( !closeTimeout ) {
			balloon.parentNode.removeChild(balloon);
			balloon = null;
			return;
		}

		// On iOS 4 we start checking the element position
		if ( OSVersion < 5 && closeTimeout ) positionInterval = setInterval(setPosition, options.iterations);
	}

	function setPosition () {
		var matrix = new WebKitCSSMatrix(w.getComputedStyle(balloon, null).webkitTransform),
			posY = isIPad ? w.scrollY - startY : w.scrollY + w.innerHeight - startY,
			posX = isIPad ? w.scrollX - startX : w.scrollX + Math.round((w.innerWidth - balloon.offsetWidth) / 2) - startX;

		// Screen didn't move
		if ( posY == matrix.m42 && posX == matrix.m41 ) return;

		balloon.style.webkitTransform = 'translate3d(' + posX + 'px,' + posY + 'px,0)';
	}

	// Clear local and session storages (this is useful primarily in development)
	function reset () {
		w.localStorage.removeItem('addToHome');
		w.sessionStorage.removeItem('addToHomeSession');
	}

	function orientationCheck () {
		balloon.style.marginLeft = -Math.round(balloon.offsetWidth / 2) - ( w.orientation%180 && OSVersion >= 6 ? 40 : 0 ) + 'px';
	}

	// Bootstrap!
	init();

	return {
		show: manualShow,
		close: close,
		reset: reset
	};
})(window);
}

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
		$timeout.cancel(redemTimeout);
		var dt;
		var overlayDiv = $("#overlaySuccess");
		$scope.active1 = true;
		$scope.feedbkMsg = false;
		$scope.feedbackList = [];
		//$('#overlaySuccess').show();
		//$('#overlaySuccess').append('<img id="theImg" src="/assets/ajax-loader.gif" />')
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
			dt = new Date();
			var time = dt.getHours();

			if (time >= 0 && time < 5) {
				dt.setDate(dt.getDate() - 1);
			}

			var startdt = new Date(dt.getFullYear(), dt.getMonth(), dt.getDate(), 5, 0, 0)

			var timeZone = String(String(dt).split("(")[1]).split(")")[0];

			//var now = new Date();
			//var nowUtc = new Date( now.getTime() + (now.getTimezoneOffset() * 60000));
			//var strtDt = new Date();
			if (!$scope.$$phase) {
				//$digest or $apply
			}

			var param = {
				"auth_token" : getCookie('authToken'),
				"start_time" : startdt,
				"password" : "X"
			}

			$http({
				method : 'get',
				url : '/api/feedbacks',
				params : param
			}).success(function(data, status) {
				$scope.feedbackList = data.feedbacks;
				$("#overlaySuccess").hide();
				$('#overlaySuccess img').hide();
				$("#overlaySuccess").css({
					'z-index' : '0',
					'background-color' : 'transparent'
				});
				if ($scope.feedbackList.length > 0) {
					$scope.feedbkMsg = false
				} else {
					$scope.feedbkMsg = true;
				}
				setTimeout(loaded, 2000);
			}).error(function(data, status) {
				//$.mobile.loading('hide');
				overlayDiv.css({
					'z-index' : '0',
					'background-color' : 'transparent'
				});
				if (status == 401) {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
					$location.url("/signin");
				}
			});

			//feedbackTimeout = $timeout($scope.listFeedbacks, 120000);

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
		$timeout.cancel(redemTimeout);
		var dt;
		$scope.active2 = true;
		flag = 1;
		Date.prototype.yyyymmdd = function() {

			var yyyy = this.getFullYear().toString();
			var mm = (this.getMonth() + 1).toString();
			// getMonth() is zero-based
			var dd = this.getDate().toString();

			return yyyy + '-' + (mm[1] ? mm : "0" + mm[0]) + '-' + (dd[1] ? dd : "0" + dd[0]);
		};

		$scope.feedbackMetrics = function() {

			dt = new Date();

			var time = dt.getHours();

			if (time >= 0 && time < 5) {
				dt.setDate(dt.getDate() - 1);
			}

			var startdt = new Date(dt.getFullYear(), dt.getMonth(), dt.getDate(), 5, 0, 0)


			var param = {
				"auth_token" : getCookie('authToken'),
				"date" : startdt,
				"password" : "X"
			}
			$http({
				method : 'get',
				url : '/api/feedbacks/metrics',
				params : param
			}).success(function(data, status) {
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
				if (status == 401) {
					//alert("hi");
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
					$location.url("/signin");
				}

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
	$("#overlaySuccess").hide();
	$(".redeemptions").hide();
	if (getCookie('authToken')) {
		$timeout.cancel(insightTimeout);
		// overlayDiv.css({
			// 'z-index' : '0',
			// 'background-color' : 'transparent'
		// });
		$scope.redemptionMsg = false;
		$scope.showRedemptions = function() {
			//window.history.back();
			//flagP = 1;
			$scope.processedRedemptions();
			//setTimeout(setupScrollbars, 1000);
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
				$scope.redemptionList = data.redemptions;
				if ($scope.redemptionList.length > 0) {
					$scope.redemptionMsg = false;
				} else {
					$scope.redemptionMsg = true;
				}
			}).error(function(data, status) {
				if (status == 401) {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
					$location.url("/signin");
				}

			});
			
			redemTimeout = $timeout($scope.listRedemptions, 120000);
			
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
				$scope.processedRedemptionList = data.redemptions;
			}).error(function(data, status) {
				if (status == 401) {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
					$location.url("/signin");
				}

			});
			
		};

		$scope.listRedemptions();
		
		$('#scrollbar3').oneFingerScroll();
		
		$scope.confirm = function(id) {
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
				$scope.listRedemptions();
				localyticsSession.tagEvent("Redemption Confirmed");
				
			}).error(function(data, status) {
				if (status == 401) {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
					$location.url("/signin");
				}

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
		$timeout.cancel(redemTimeout);
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
					$scope.error = "Please enter valid bill amount";
					$scope.succmsg = false;
					$scope.erromsg = true;
				} else {
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
						$scope.erromsg = false;
						$scope.codeGenerate = false;
						$scope.codeGenerated = true;

						$scope.code = data.code;

						//$scope.billAmount = "";
						$('#billAmnt').val("");

						$scope.loader = false;
					}).error(function(data, status) {
						$scope.error = data.error[0];
						$scope.succmsg = false;
						$scope.erromsg = true;
						$scope.loader = false;
						if (status == 401) {
							deleteCookie('authToken');
							deleteCookie('userRole');
							deleteCookie('userName');
							deleteCookie('feedbackId');
							deleteCookie("signInCount");
							$location.url("/signin");
						}
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

				$scope.listCodes = data.feedbacks;

			}).error(function(data, status) {
				if (status == 401) {
					deleteCookie('authToken');
					deleteCookie('userRole');
					deleteCookie('userName');
					deleteCookie('feedbackId');
					deleteCookie("signInCount");
					$location.url("/signin");
				}
			});
		};

		$scope.listGeneratedCodes();
		//setTimeout(setupScrollbars, 2000);

		$('#scrollbar2').oneFingerScroll();

		$scope.parseDate = function(jsonDate) {
			$scope.v = {
				DDt : Date.parse(jsonDate)
			}
		};

		$scope.done = function() {
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
		//e.preventDefault();
	});
	$(this).bind('touchmove', function(event) {
		var e = event.originalEvent;
		$(this).scrollTop(scrollStartPos - e.touches[0].pageY);
		//e.preventDefault();
	});
	return this;
};

function pullUpAction() {
	setTimeout(function() {// <-- Simulate network congestion, remove setTimeout from production!
		myScroll.refresh();
		// Remember to refresh when contents are loaded (ie: on ajax completion)
	}, 2000);
	// <-- Simulate network congestion, remove setTimeout from production!
}

function loaded() {
	//alert("in loaded");
	myScroll = new iScroll('wrapper');
	pullDownEl = document.getElementById('pullDown');
	pullDownOffset = 5;
	//pullUpEl = document.getElementById('pullUp');
	//pullUpOffset = pullUpEl.offsetHeight;

	myScroll = new iScroll('wrapper', {
		//useTransition: true,
		topOffset : pullDownOffset,
		onRefresh : function() {
			if (pullDownEl.className.match('loading')) {
				pullDownEl.className = '';
				pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Loading...';
				pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Pull down to refresh...';
			}
			// else if (pullUpEl.className.match('loading')) {
			// pullUpEl.className = '';
			// pullUpEl.querySelector('.pullUpLabel').innerHTML = '';
			// }
		},
		onScrollMove : function() {
			if (this.y > 5 && !pullDownEl.className.match('flip')) {
				pullDownEl.className = 'flip';
				pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Release to refresh...';
				$("#overlaySuccess").show();
				$('#overlaySuccess img').show();
				$("#overlaySuccess").css({
					'z-index' : '10',
					'background-color' : '#000'
				});
				this.minScrollY = 0;
			} else if (this.y < 5 && pullDownEl.className.match('flip')) {
				pullDownEl.className = '';
				pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Pull down to refresh...';
				this.minScrollY = -pullDownOffset;
			}
			// else if (this.y < (this.maxScrollY - 5) && !pullUpEl.className.match('flip')) {
			// pullUpEl.className = 'flip';
			// pullUpEl.querySelector('.pullUpLabel').innerHTML = '';
			// this.maxScrollY = this.maxScrollY;
			// } else if (this.y > (this.maxScrollY + 5) && pullUpEl.className.match('flip')) {
			// pullUpEl.className = '';
			// pullUpEl.querySelector('.pullUpLabel').innerHTML = '';
			// this.maxScrollY = pullUpOffset;
			// }
		},
		onScrollEnd : function() {
			if (pullDownEl.className.match('flip')) {
				pullDownEl.className = 'loading';
				pullDownAction();
				pullDownEl.querySelector('.pullDownLabel').innerHTML = 'Loading...';
				// Execute custom function (ajax call?)
			}
			// else if (pullUpEl.className.match('flip')) {
			// pullUpEl.className = 'loading';
			// pullUpEl.querySelector('.pullUpLabel').innerHTML = '';
			// pullUpAction();
			// // Execute custom function (ajax call?)
			// }
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
/*!
 * Add to Homescreen v2.0.5 ~ Copyright (c) 2013 Matteo Spinelli, http://cubiq.org
 * Released under MIT license, http://cubiq.org/license
 */


