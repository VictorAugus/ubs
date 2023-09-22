public with sharing class DW_GetAccountsFromERPIntegrable extends DW_Integrable {
    public Integer page;
    public DW_GetAccountsFromERPResponseTemplate responseTemplate;
    
    public override void callIntegration(Object obj) {
        this.deserializedRequestObject = obj;
        this.sendRequest();
    }
 
    public override String constructEndpoint() {
        return MetadataHelper.getInstance().integracaoERP.EndpointBuscaContas__c;
    }

    public override String setMethod() {
        return 'GET';
    }

    public override Map<String, String> constructHeaders() {
        
        // outra forma de chamar um token se desejar
        //'Authorization' => 'Basic ' + DaspeMicroservicoHelper.getInstance().daspeMicroservico.Token__c,
       
        return new Map<String, String>{
            
            'Accept' => 'application/json'
        };
    }

    public override Map<String, String> constructQueryParameters() {
        return new Map<String, String>{ 'page' => String.valueOf(page), 'pagesize' => '200' };
    }

    public override String getSerializedRequest() {
        // AccountIntegrableRequestTemplate requestTemplate = new AccountIntegrableRequestTemplate();
        // Account account = (Account)this.deserializedRequestObject;
        // requestTemplate.account = account;
        return '';
    }

    public override void setDeserializedResponseObject() {
        String body = this.requestFactoryInstance.getResponse().getBody();
        body = body.replaceAll('\\t', '');
        body = body.replaceAll('\\n', '');
        body = body.replaceAll('\\r', '');
        body = body.replaceAll('\\\\', '-');
        System.debug('body: '+body);
        this.responseTemplate = (DW_GetAccountsFromERPResponseTemplate)JSON.deserialize(
            body, DW_GetAccountsFromERPResponseTemplate.class
        );
        
        this.deserializedResponseObject = responseTemplate;
    }

    public override void finish() {

    }
}