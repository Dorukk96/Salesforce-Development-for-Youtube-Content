public with sharing class APODCalloutService {
    
    public static String baseEndpoint = 'https://science.nasa.gov';
    public static String GET_METHOD = 'GET';

    public static void getAPODInformation () {

        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseEndpoint + '/wp-json/wp/v2/apod-basic');
        request.setMethod(GET_METHOD);
        request.setHeader('Content-Type', 'application/json');

        try {
            // Prepare the internet
            HttpResponse response = (new Http()).send(request);
    
            Integer statusCode = response.getStatusCode();
    
            if (statusCode == 200) {
                // process the data
                List<APOD__c> apodToInsert = new List<APOD__c>();
                List<APODWrapper> apods = (List<APODWrapper>) System.JSON.deserialize(response.getBody(), List<APODWrapper>.class);

                for (APODWrapper apod : apods) {
                    APOD__c a = new APOD__c();
                    a.AltText__c = apod.alt;
                    a.BasicHTML__c = apod.basic_html;
                    a.BasicHTMLURL__c = apod.basic_html_url;
                    a.Copyright__c = apod.copyright;
                    a.Credit__c = apod.credit;
                    a.Date__c = apod.str_date;
                    a.Explanation__c = apod.explanation;
                    a.HDURL__c = apod.hdurl;
                    a.URL__c = apod.url;
                    a.MediaType__c = apod.media_type;
                    a.Permalink__c = apod.permalink;
                    a.PostID__c = apod.post_id;
                    a.Title__c = apod.title;

                    apodToInsert.add(a);
                }

                if (!apodToInsert.isEmpty()) {
                    insert as user apodToInsert;
                }
            } else {
                System.debug('Something went wrong while getting the data >> ' + statusCode);
            }
        } catch (System.CalloutException ce) {
            System.debug('System.CalloutException >> ' + ce.getMessage());
        } catch (System.Exception exc) {
            System.debug('System.Exception >>> ' + exc.getMessage());
        }
    }
}