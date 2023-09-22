public without sharing class DWGetAccessTokenIntegrable extends DW_Integrable{
    public DWGetAccessTokenIntegrableTempate responseTemplate;
    public override void callIntegration(Object obj) {
        this.deserializedRequestObject = obj;
        this.sendRequest();
    }

    
    public override String constructEndpoint() {
        return MetadataHelper.getInstance().integracaoERP.EndpointObterToken__c;
    }

    public override String setMethod() {
        return 'POST';
    }

    public override Map<String, String> constructHeaders() {
        
        return new Map<String, String>{
            'Content-Type' => 'application/json',
                'Accept' => 'application/json'
                };
                    }

    public override Map<String, String> constructQueryParameters() {

        return new Map<String, String>();
    }

    public override String getSerializedRequest() {
        if(DW_Helper.isNullOrBlank(MetadataHelper.getInstance().integracaoERP.Usuario__c)) throw new IllegalArgumentException('O preenchimento do usuario no metadado é obrigatorio para obter o TOKEN');
        if(DW_Helper.isNullOrBlank(MetadataHelper.getInstance().integracaoERP.Senha__c)) throw new IllegalArgumentException('O preenchimento da senha no metadado é obrigatorio para obter o TOKEN');
        
        DWGetAccessTokenRequestTempate request = new DWGetAccessTokenRequestTempate();
        request.user = MetadataHelper.getInstance().integracaoERP.Usuario__c ;
        request.Password = MetadataHelper.getInstance().integracaoERP.Senha__c ;
        return JSON.serialize(request);
    }

    public override void setDeserializedResponseObject() {
        this.responseTemplate = (DWGetAccessTokenIntegrableTempate)JSON.deserialize(
            this.requestFactoryInstance.getResponse().getBody(), DWGetAccessTokenIntegrableTempate.class
        );
        this.deserializedResponseObject = responseTemplate;
    }

    public override void finish() {

    }

}