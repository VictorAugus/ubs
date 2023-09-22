public class DwOrderIntegrable extends DW_Integrable{
    public DWAccountIntegrableResponseTemplate responseTemplate;
    public DWGetAccessTokenIntegrableTempate accessToken;

    public override void callIntegration(Object obj) {
        this.deserializedRequestObject = obj;
        this.sendRequest();
    }
  
    public override String constructEndpoint() {
        // para pedido é usado apenas o endpoint de criação
        return MetadataHelper.getInstance().integracaoERP.EndPointCriacaoPedido__c; 
    }

    public override String setMethod() {
       // para pedido é usado criação
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
   
    public  static String requestInsert(Order order){
        if(DW_Helper.isNullOrBlank(order.Account.CodigoERP__c)) throw new IllegalArgumentException('A conta precisa estar integrada antes de enviar o pedido');
        //classe request de insert 
        //aqui também possivel que envie os produtos junto com o pedido
        DWOrderIntegrableRequestTemplate requestTemplate = new DWOrderIntegrableRequestTemplate();
        requestTemplate.caminhoInsertName = order.Name;

        return JSON.serialize(requestTemplate);    
    }
    public override String getSerializedRequest() {
        // pedido é somente insert
        Order order = (Order)this.deserializedRequestObject;
        return DwOrderIntegrable.requestInsert(order);
    }
    public override void setDeserializedResponseObject() {
        Order order = (Order)this.deserializedRequestObject;
        this.responseTemplate = (DWAccountIntegrableResponseTemplate)JSON.deserialize(
            this.requestFactoryInstance.getResponse().getBody(), DWAccountIntegrableResponseTemplate.class
        );
        this.deserializedResponseObject = responseTemplate;        
    }

    public override void finish() {

    }
}