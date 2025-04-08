sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'booksui/test/integration/FirstJourney',
		'booksui/test/integration/pages/BooksAnalyticsList',
		'booksui/test/integration/pages/BooksAnalyticsObjectPage'
    ],
    function(JourneyRunner, opaJourney, BooksAnalyticsList, BooksAnalyticsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('booksui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheBooksAnalyticsList: BooksAnalyticsList,
					onTheBooksAnalyticsObjectPage: BooksAnalyticsObjectPage
                }
            },
            opaJourney.run
        );
    }
);