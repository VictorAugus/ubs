/**
 * Created by guilhermereis on 22/02/21.
 */

public with sharing class DW_IntegrableTestMock implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        if (request.getEndpoint().contains('http://teste.com')){
            Account account = new Account();
            account.Name = 'teste';
            response.setBody(JSON.serialize(account));
            response.setStatusCode(200);
            return response;
        }
        return null;
    }
}