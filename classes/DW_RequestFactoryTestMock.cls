/**
 * Created by guilhermereis on 22/04/21.
 */

public with sharing class DW_RequestFactoryTestMock implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest httpRequest){
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        return httpResponse;
    }
}