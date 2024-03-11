@isTest
global class PortfolioMockHTTPResponse implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        System.assertEquals('https://www.marcbenioff/v1/v2', request.getEndpoint());
        System.assertEquals('POST', request.getMethod());
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"items":[{"accountIdLink":"a1b2c3e4","accountId":"001Qy00000Dqx1YIAR"},{"accountIdLink":"f6g7h8i9","accountId":"001Qy00000Dqx1YIBR"}]}');
        response.setStatusCode(200);
        return response;
    }
}