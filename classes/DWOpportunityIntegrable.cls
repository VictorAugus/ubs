public without sharing class DWOpportunityIntegrable extends DW_Integrable{
    public DWOpportunityIntegrableResponseTemplate responseTemplate;
    public DWGetAccessTokenIntegrableTempate accessToken;
    
    public override void callIntegration(Object obj) {
        this.deserializedRequestObject = obj;
        this.sendRequest();
    }
    
    
    public override String constructEndpoint() {
        return MetadataHelper.getInstance().integracaoERP.EndpointInsertCotacao__c;
        
    }
    
    public override String setMethod() {
       
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
   
    public override String getSerializedRequest() {
       Opportunity opp = (Opportunity)this.deserializedRequestObject;
      
          
        List<OpportunityLineItem> opportunityLineItemList  = ((List<OpportunityLineItem>) DW_QueryFactory.get('OpportunityLineItem')
                            .setCondition(DW_QueryCondition.newInstance('OpportunityId', '=', opp.Id))
                            .withParent('Product2')
                            .run());
                            
        if(opportunityLineItemList.size() ==0 ) throw new IllegalArgumentException('É preciso ter uma linha de produto da oportunidade para a integração funcionar');
        
        
        if(DW_Helper.isNullOrBlank(opp.Account.CodigoERP__c)) throw new IllegalArgumentException('O preenchimento do Código ERP da conta é obrigatorio');
       

        For(OpportunityLineItem oppLineItem : opportunityLineItemList){
            if(DW_Helper.isNullOrBlank(oppLineItem.Product2.CodigoERP__c)) throw new IllegalArgumentException('O preenchimento do Código ERP do produto no item da linha de oportunidade é obrigatorio');
        }
        
         
        DWOpportunityIntegrableRequestTemplate requestTemplate = new DWOpportunityIntegrableRequestTemplate();
        requestTemplate.codigoCliente = opp.Account.CodigoERP__c;
		
        
        List<DWOpportunityIntegrableRequestTemplate.items> listProductsRequest = New List<DWOpportunityIntegrableRequestTemplate.items>();
        For(OpportunityLineItem oppLineItem : opportunityLineItemList){
        	DWOpportunityIntegrableRequestTemplate.items productRequest = New DWOpportunityIntegrableRequestTemplate.items();    
            productRequest.ItemCode = oppLineItem.Product2.CodigoERP__c;
            productRequest.Quantity = String.valueOf(oppLineItem.Quantity);
            productRequest.UnitPrice = String.valueOf(oppLineItem.UnitPrice);
            
            listProductsRequest.add(productRequest);
        }
        requestTemplate.items = listProductsRequest;
        return JSON.serialize(requestTemplate);
        
        
    }
    public override void setDeserializedResponseObject() {
        this.responseTemplate = (DWOpportunityIntegrableResponseTemplate)JSON.deserialize(
            this.requestFactoryInstance.getResponse().getBody(), DWOpportunityIntegrableResponseTemplate.class);
        this.deserializedResponseObject = responseTemplate;
    }
     public override void finish() {
        
    }
}