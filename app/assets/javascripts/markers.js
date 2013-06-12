var MYMAP;
$(document).ready(function() {
	MYMAP = {
	map : null,
	bounds : null
};
	$("#map").css({
		height : 500,
		width : 600
	});
	var myLatLng = new google.maps.LatLng(17.74033553, 83.25067267);
	MYMAPinit('#map', myLatLng, 11);

	
function MYMAPinit(selector, latLng, zoom) {
	var myOptions = {
		zoom : zoom,
		center : latLng,
		mapTypeId : google.maps.MapTypeId.ROADMAP
	}
	this.map = new google.maps.Map($(selector)[0], myOptions);
	this.bounds = new google.maps.LatLngBounds();
	google.maps.event.addListener(this.map, 'click', function(event) {
		alert(event.country);
		//var point = new google.maps.LatLng(parseFloat(lat),parseFloat(lng));

		// extend the bounds to include the new point
		MYMAP.bounds.extend(event.latLng);

		var marker = new google.maps.Marker({
			position : event.latLng,
			map : MYMAP.map
		});
		var geocoder = new google.maps.Geocoder();
		geocoder.geocode({
			"latLng" : event.latLng
		}, function(results, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				console.log(results[0].formatted_address);
				var infoWindow = new google.maps.InfoWindow();
				var html = '<strong>Kanari</strong.><br />' + results[0].formatted_address;
				google.maps.event.addListener(marker, 'click', function() {
					infoWindow.setContent(html);
					infoWindow.open(MYMAP.map, marker);
				});
				MYMAP.map.fitBounds(MYMAP.bounds);
			}
		});

	});
}

});