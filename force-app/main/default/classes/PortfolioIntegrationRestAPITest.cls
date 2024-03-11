@isTest
public with sharing class PortfolioIntegrationRestAPITest {

    @TestSetup
    static void createTestData() {
        Account testAccountRed = new Account(
            Name = 'Red Account',
            Color__c = 'Red',
            ExternalId__c = 'a1b2c3d4'
        );
        insert testAccountRed;
        Account testAccountBlue = new Account(
            Name = 'Blue Account',
            Color__c = 'Blue',
            ExternalId__c = 'e5f6g7h8'
        );
        insert testAccountBlue;
    }

    @isTest
    private static void doPostPortfolioAPISuccessTest() {

        RestRequest request = new RestRequest();
        portfolioIntegrationRestAPI.ItemResponseWrapper response = new portfolioIntegrationRestAPI.ItemResponseWrapper();
                
        Test.startTest();
        request.requestURI = '/services/apexrest/Portfolio';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(
            '{ "items": [ {"color":"Red", "externalId":"a1b2c3d4"}, ' +
            '{"color":"Blue", "externalId":"e5f6g7h8"} ] }');
        RestContext.request = request;
  
        response = portfolioIntegrationRestAPI.doPost();
        Test.stopTest();
        List<Portfolio__c> portfolios = [SELECT Id, ExternalId__c, Account__r.Id, Account__r.ExternalId__c FROM Portfolio__c]; 
        
        System.assertEquals(200, response.statusCode, 'Response status code should be 200');
        System.assertEquals('OK', response.message, 'response message should indicate Portfolio object was created.');
        System.assertEquals(2, portfolios.size(), 'Two Portfolio objects should have been created.');
        System.assertEquals(portfolios[0].ExternalId__c, portfolios[0].Account__r.ExternalId__c, 'Portfolio and Account external ids should match.');
    }

    @isTest
    private static void doPostPortfolioAPIEmptyTest() {

        RestRequest request = new RestRequest();
        portfolioIntegrationRestAPI.ItemResponseWrapper response = new portfolioIntegrationRestAPI.ItemResponseWrapper();
                
        Test.startTest();
        request.requestURI = '/services/apexrest/Portfolio';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{"x":"y"}');
        RestContext.request = request;

        response = portfolioIntegrationRestAPI.doPost();
        Test.stopTest();

        List<Portfolio__c> portfolios = [SELECT Id, ExternalId__c, Account__r.Id, Account__r.ExternalId__c FROM Portfolio__c]; 
        
        System.assertEquals(500, response.statusCode, 'Response status code should be 500');
        System.assertEquals('ERROR', response.message, 'Response message should indicate an Error Occurred.');
        //System.assertEquals(0, portfolios.size(), 'No Portfolio objects should have been created.');
    }

    @isTest
    private static void doPostPortfolioAPIBadPayloadTest() {

        RestRequest request = new RestRequest();
        RestResponse res = new RestResponse();
        portfolioIntegrationRestAPI.ItemResponseWrapper response = new portfolioIntegrationRestAPI.ItemResponseWrapper();
                
        Test.startTest();
        request.requestURI = '/services/apexrest/Portfolio';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('');
        RestContext.request = request;
        RestContext.response= res;
    
        response = portfolioIntegrationRestAPI.doPost();
        Test.stopTest();

        List<Portfolio__c> portfolios = [SELECT Id, ExternalId__c, Account__r.Id, Account__r.ExternalId__c FROM Portfolio__c]; 
        
        System.assertEquals(500, response.statusCode, 'Response status code should be 500');
        System.assertEquals('ERROR', response.message, 'Response message should indicate an Error Occurred.');
        System.assertEquals(0, portfolios.size(), 'No Portfolio objects should have been created.');
    }


}