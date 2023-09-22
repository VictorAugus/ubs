public with sharing class DW_GetAccountsFromERPIntegrableTestMock implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        DW_GetAccountsFromERPResponseTemplate responseTemplate = new DW_GetAccountsFromERPResponseTemplate();
        
        String responseText = 'exemploResposta';

        response.setBody(responseText);
        response.setStatusCode(200);
        return response;
    }
}