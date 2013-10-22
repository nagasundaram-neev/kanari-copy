console.log("in dashboard report");
Highcharts.drawTable = function() {
			
			var myArray1 = ["Over Period", "Change VS Preceding Period"];
			var myArray2 = [[10, 10, 12], [11, 11, 12]];
			var count1 = myArray1.length;
			var count2 = myArray2.length;
			// user options
			var tableTop = 400, colWidth = 100, tableLeft = 20, rowHeight = 20, cellPadding = 2.5, valueDecimals = 1, valueSuffix = ' °C';

			// internal variables
			var chart = this, series = chart.series, renderer = chart.renderer, cellLeft = tableLeft;

			$.each(series, function(i, serie) {
				renderer.text(serie.name, cellLeft + cellPadding, tableTop + (i + 2) * rowHeight - cellPadding).css({
					fontWeight : 'bold'
				}).add();
			});

			$.each(myArray1, function(count1, myArray1) {
				cellLeft += colWidth;

				// Apply the cell text
				renderer.text(myArray1, cellLeft - cellPadding + colWidth, tableTop + rowHeight - cellPadding).attr({
					align : 'right'
				}).css({
					fontWeight : 'bold'
				}).add();

				$.each(myArray2[count1], function(count2, myArray2) {
					// Apply the cell text
					renderer.text(myArray2, cellLeft + colWidth - cellPadding, tableTop + (count2 + 2) * rowHeight - cellPadding).attr({
						align : 'right'
					}).add();

				});

			});
		};

/**
 * Draw a single line in the table
 */
Highcharts.tableLine = function (renderer, x1, y1, x2, y2) {
    renderer.path(['M', x1, y1, 'L', x2, y2])
        .attr({
            'stroke': 'silver',
            'stroke-width': 1
        })
        .add();
}

/**
 * Create the chart
 */
window.chart = new Highcharts.Chart({

    chart: {
        renderTo: 'container',
        events: {
            load: Highcharts.drawTable
        },
        borderWidth: 2
    },
    
    title: {
        text: 'Average monthly temperatures'
    },
    
    xAxis: {
        categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    },
    
    yAxis: {
        title: {
            text: 'Temperature (°C)'
        }
    },

    legend: {
        y: -300
    },

    series: [{
         name: 'Tokyo',
         data: results1
      }, {
         name: 'New York',
         data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]
      }, {
         name: 'Berlin',
         data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]
      }, {
         name: 'London',
         data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
      }]
});