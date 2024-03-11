@RestResource(urlMapping='/Portfolio/*')

global with sharing class PortfolioIntegrationRestAPI {

  @HttpPost
  global static ItemResponseWrapper doPost() {
    List<Portfolio__c> portfolios = new List<Portfolio__c>();
    List<Error_Log__c> errorLogs = new List<Error_Log__c>();
    RestRequest request = RestContext.request;
    RestResponse response = RestContext.response;
    ItemResponseWrapper responseStatus = new ItemResponseWrapper();

    try{
      String requestBody = request.requestBody.toString();
      Map<String, List<ItemWrapper>> requestBodyMap = (Map<String, List<ItemWrapper>>) JSON.deserialize(requestBody, Map<String, List<ItemWrapper>>.class);
      List<ItemWrapper> items = requestBodyMap.get('items');
    
      for(ItemWrapper item : items) {
        System.debug('item');
        System.debug(item);
        System.debug(item.color);
        portfolios.add(
          new Portfolio__c(
            Color__c = item.color,
            ExternalId__c = item.externalId
          )
        );
      }

      if(!portfolios.isEmpty()){
        insert portfolios;
      }

      responseStatus.Message = 'OK';
      responseStatus.statusCode = 200;

    } catch (Exception e) {
      errorLogs.add(
        new Error_Log__c (
          Name = 'portfolioIntegrationRestAPI.doPost',
          Message__c = e.getMessage(),
          Line__c = e.getLineNumber()
        )
      );
      insert errorLogs;
      
      responseStatus.Message = 'ERROR';
      responseStatus.statusCode = 500;
    }

    return responseStatus;
  }

  global class ItemWrapper {
    public String externalId;
    public String color;
  }

  global class ItemResponseWrapper {
    public String message;
    public Integer statusCode;
  }

}