@IsTest
global class DWOpportunityIntegrableMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest httpRequest){
        HttpResponse httpResponse = new HttpResponse();        
        httpResponse.setBody('retornoJSON');
        httpResponse.setStatusCode(200);
        return httpResponse;
        
    }
}