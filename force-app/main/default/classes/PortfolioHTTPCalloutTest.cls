@isTest
private class PortfolioHTTPCalloutTest {

     @isTest 
     static void portfolioCalloutSuccessTest() {
        Test.setMock(HttpCalloutMock.class, new PortfolioMockHTTPResponse());
        HttpResponse response = PortfolioHTTPCallout.makeCallout();
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        String expectedValue = '{"items":[{"accountIdLink":"a1b2c3e4","accountId":"001Qy00000Dqx1YIAR"},{"accountIdLink":"f6g7h8i9","accountId":"001Qy00000Dqx1YIBR"}]}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
    }
    
}