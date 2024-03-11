public class PortfolioHTTPCallout {

    public static List<Portfolio__c> portfolios = new List<Portfolio__c> ();

    @invocableMethod(callout=true label='CalloutForQTSystem' description='Sends information from updated portfolio objects to external system.')
    public static void getResponseFromExternalService(List<sObject> body) {
        portfolios = (List<Portfolio__c>) body;
        makeCallout();
    }

    public static HttpResponse makeCallout() {

        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint('https://www.marcbenioff/v1/v2');
        request.setMethod('POST');
        
        RequestWrapper requestWrapper = new RequestWrapper();
        
        List<RequestItem> itemList = new List<RequestItem>();
        RequestItem temp = new RequestItem();
        
        for(Portfolio__c portfolio : portfolios){
            temp.accountId = portfolio.Account__c;
            temp.accountIdLink = portfolio.externalId__c;
            itemList.add(temp);
        }
        requestWrapper.items = itemList;
        String jsonData = JSON.serialize(requestWrapper);
        System.debug(jsonData);

        String expectedValue = jsonData;
        request.setBody(expectedValue); 
        Http http = new Http();
        HttpResponse response = http.send(request);

        return response;
       
    }

    // public static void getResponseFromExternalService(List<sObject> body) {

    //     HttpRequest request = new HttpRequest();
    //     request.setHeader('Content-Type', 'application/json');
    //     request.setEndpoint('https://www.marcbenioff/v1/v2');
    //     request.setMethod('POST');
        
    //     List<Portfolio__c> portfolios = (List<Portfolio__c>) body;
    //     RequestWrapper requestWrapper = new RequestWrapper();
        
    //     List<RequestItem> itemList = new List<RequestItem>();
    //     RequestItem temp = new RequestItem();
        
    //     for(Portfolio__c portfolio : portfolios){
    //         temp.accountId = portfolio.Account__c;
    //         temp.accountIdLink = portfolio.externalId__c;
    //         itemList.add(temp);
    //     }
    //     requestWrapper.items = itemList;
    //     String jsonData = JSON.serialize(requestWrapper);
    //     System.debug(jsonData);

    //     String expectedValue = jsonData;
    //     request.setBody(expectedValue); 
    //     Http http = new Http();
    //     HttpResponse response = http.send(request);
       
    // }

    public class RequestWrapper {
        public List<RequestItem> items; 
    }
    public class RequestItem {
        public String accountIdLink;
        public String accountId;
    }
}