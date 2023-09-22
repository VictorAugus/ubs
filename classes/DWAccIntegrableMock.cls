@IsTest
global class DWAccIntegrableMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest httpRequest){
        HttpResponse httpResponse = new HttpResponse();        
        httpResponse.setBody('');
        httpResponse.setStatusCode(200);
        return httpResponse;
        
    }
}