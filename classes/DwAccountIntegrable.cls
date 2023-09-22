public without sharing class DwAccountIntegrable extends DW_Integrable{
    public DWAccountIntegrableResponseTemplate responseTemplate;
    public DWGetAccessTokenIntegrableTempate accessToken;

    public override void callIntegration(Object obj) {
        this.deserializedRequestObject = obj;
        this.sendRequest();
    }
  
    public override String constructEndpoint() {
        // exemplo se desejar usar para acionar um metodo de update ou insert
        Account account = (Account)this.deserializedRequestObject;
        if (! String.isBlank(account.CodigoERP__c)) {
            //exemplo de passar na url de atualização o código erp
            return  MetadataHelper.getInstance().integracaoERP.EndpointUpdateParceiro__c+'/'+account.CodigoERP__c;
            
        }
        return MetadataHelper.getInstance().integracaoERP.EndpointInsertParceiro__c;
        
    }

    public override String setMethod() {
        // exemplo se desejar usar para acionar um metodo de update ou insert
         Account account = (Account)this.deserializedRequestObject;
        if (! String.isBlank(account.CodigoERP__c)) {
            return 'PATCH';
        }
        return 'POST';
    } 
    
    public override Map<String, String> constructHeaders() {
        // exemplo de buscar o token antes da requisição da integração de um registro
        // descomentar se ver que antes da integração acontecer precisa obter o token
        
        /*DWGetAccessTokenIntegrable getAccessTemplate = new DWGetAccessTokenIntegrable();
        getAccessTemplate.callIntegration(null);
        DWGetAccessTokenIntegrableTempate responseObterToken = (DWGetAccessTokenIntegrableTempate)getAccessTemplate.deserializedResponseObject;
        
        
        if(! Test.isRunningTest()){
            token = responseObterToken.token;
        }*/
        String token = 'token_para_classe_teste';
        return new Map<String, String>{
            'Authorization' => 'Bearer ' + token,
                'Content-Type'=>'application/json'
                };
                    
                    }

    public override Map<String, String> constructQueryParameters() {
        return new Map<String, String>();
    }
    public  static String requestUpdate(Account ac){
        if(DW_Helper.isNullOrBlank(ac.Description)) throw new IllegalArgumentException('O preenchimento da descrição da conta é obrigatorio para atualizar a conta no ERP');
        //classe request de update // modelo para realizar o parse da atualização da conta 
        DWAccountUpdateIntegrableRequestTemplate requestTemplate = new DWAccountUpdateIntegrableRequestTemplate();
        requestTemplate.caminhoUpdateName = ac.Name;
        return JSON.serialize(requestTemplate);
        
    }
    public  static String requestInsert(Account ac){
        if(DW_Helper.isNullOrBlank(ac.Description)) throw new IllegalArgumentException('O preenchimento da descrição da conta é obrigatorio para atualizar a conta no ERP');
        //classe request de insert // modelo para realizar o parse da inserção da conta 
        DWAccountIntegrableRequestTemplate requestTemplate = new DWAccountIntegrableRequestTemplate();
        requestTemplate.caminhoInsertName = ac.Name;
        return JSON.serialize(requestTemplate);
        
    }
    public override String getSerializedRequest() {
        // exemplo se desejar usar para acionar um metodo de update ou insert
        Account ac = (Account)this.deserializedRequestObject;
        if (!String.isBlank(ac.CodigoERP__c)) {
            return DwAccountIntegrable.requestUpdate(ac);
        }else{
            return DWAccountIntegrable.requestInsert(ac);
        }
    }
    public override void setDeserializedResponseObject() {
        Account account = (Account)this.deserializedRequestObject;
        if (!String.isBlank(account.CodigoERP__c)) {
              this.responseTemplate = (DWAccountIntegrableResponseTemplate)JSON.deserialize(
                this.requestFactoryInstance.getResponse().getBody(), DWAccountIntegrableResponseTemplate.class
            );
            this.deserializedResponseObject = responseTemplate;
            
        }else{
            this.responseTemplate = (DWAccountIntegrableResponseTemplate)JSON.deserialize(
                this.requestFactoryInstance.getResponse().getBody(), DWAccountIntegrableResponseTemplate.class
            );
            this.deserializedResponseObject = responseTemplate;
        }
        
    }

    public override void finish() {

    }
}