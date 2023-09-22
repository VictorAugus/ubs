global class DWOpportunityIntegrableBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Schedulable{
    @InvocableMethod(label='Chamar integracao de oportunidade')
    global static void testQA(List<String> id) {
        List<SObject> sObjectList = DW_QueryFactory.get('Opportunity')
        .setCondition(
            DW_QueryCondition.newInstance(
                'Id', new List<String>{id.get(0)}))
            .withParent('Account')
            
            .with('OpportunitylineItems')
            
            .run();
        
        (new DWOpportunityIntegrableBatch()).execute(new DWOpportunityIntegrableBatch.BatchContext(), sObjectList);
    }
  List<String> statusList = new List<String>();
    public DWOpportunityIntegrableBatch(){
        
    }
    public void execute(SchedulableContext param1) {
        Database.executeBatch(new DWOpportunityIntegrableBatch(), 1);
    }
    
   global static void scheduleThisClass(String cron){
        cron = cron == null ? '0 0 * * * ?' : cron;
        System.schedule('DWOpportunityIntegrableBatch ' + cron, cron , new DWOpportunityIntegrableBatch());
    }
    
    global static void runEveryNMinutes(Integer each) {
        for (Integer i = 0; i < 60; i += each){
            String cron = '0 ' + i + ' * * * ?';
            System.schedule('DWOpportunityIntegrableBatch ' + cron, cron, new DWOpportunityIntegrableBatch());
        }
    }
    
  global static void cancelThisSchedule() {
        CronTrigger[] asyncApexJob = [
            SELECT Id, CronJobDetail.name
            FROM CronTrigger
            WHERE CronJobDetail.name LIKE '%DWOpportunityIntegrableBatch%'
        ];
        for (CronTrigger job : asyncApexJob){
            System.abortJob(job.Id);
            
        }
    }
     
    public Iterable<SObject> start(Database.BatchableContext param1) {
        List<SObject> sObjectList = DW_QueryFactory.get('Opportunity')
            .setCondition(
                DW_QueryCondition.newInstance(
                    'StatusIntegracao__c', 
                    this.statusList.size() > 0 ? this.statusList : new List<String>{'Pendente', 'Executado com erro'}))
           // .setCondition(DW_QueryCondition.newInstance('TentativasIntegracao__c', '<=', 30))
           			.withParent('Account')
            
            .with('OpportunitylineItems')
            .run();
            System.debug(LoggingLevel.INFO, '@@@DWOpportunityIntegrableBatch sObjectList' + sObjectList);

        return (List<Opportunity>)sObjectList;
    }
     
    public void execute(Database.BatchableContext param1, List<Opportunity> opportunityList) {
        List<OpportunityLineItem> oppLineItemForUpdate = new List<OpportunityLineItem>();
        List<HttpRequestLog__c> httpRequestLogList = new List<HttpRequestLog__c>();
        System.debug(LoggingLevel.INFO, '@@@DWOpportunityIntegrableBatch opportunityList' + opportunityList);
        Set<Id> opportunitySet = new Set<Id>();
        for (Opportunity opportunity : opportunityList){
            opportunitySet.add(opportunity.Id);
        }
        Map<String,OpportunityLineItem> mapOpportunityLineItem = new Map<String,OpportunityLineItem>();
        List<OpportunityLineItem> sObjectList  = ((List<OpportunityLineItem>) DW_QueryFactory.get('OpportunityLineItem')
                            .setCondition(DW_QueryCondition.newInstance('OpportunityId', opportunitySet))
                            .withParent('Product2')
                            .run());
         
        for(OpportunityLineItem opportunityLineItem :sObjectList ){
            mapOpportunityLineItem.put(opportunityLineItem.Product2.CodigoERP__c,opportunityLineItem);
        }
        for (Opportunity opportunity : opportunityList){
            opportunitySet.add(opportunity.Id);
            HttpRequestLog__c log = new HttpRequestLog__c();
            DWOpportunityIntegrable opportunityIntegrable = new DWOpportunityIntegrable();
   
            System.debug(LoggingLevel.INFO, '@@@DWOpportunityIntegrable QuoteIntegrableBatch.requestFactoryInstance.getLog()' + opportunityIntegrable.requestFactoryInstance.getLog());
 
            log = DW_Helper.hasSomeContent(opportunityIntegrable.requestFactoryInstance.getLog()) ? opportunityIntegrable.requestFactoryInstance.getLog():log;
            try{
                opportunityIntegrable.callIntegration(opportunity);
                System.debug(LoggingLevel.INFO, '@@@QuoteIntegrableBatch this.isError' + opportunityIntegrable.isError);

                System.debug(LoggingLevel.INFO, '@@@QuoteIntegrableBatch quoteIntegrable.responseTemplate' + opportunityIntegrable.responseTemplate);
                if(opportunityIntegrable.isError){
                     //se a integração cair nesse IF, a conta não pode integrar, como estamos na versão de teste...
                    //descomentar quando tiver sendo desenvolvido e retirar as ultimas tres linha
                    //opportunity.StatusIntegracao__c = 'Integrado com erro';
                    //                    log.ResponseBody__c = opportunityIntegrable.errorMessage;

                    //lembre-se de remover essas  linhas
                    opportunity.StatusIntegracao__c = 'Integrado com sucesso';
                    opportunity.CodigoERP__c =opportunity.Id;
                    opportunity.TentativasIntegracao__c = 0;
                    log.ResponseBody__c = opportunityIntegrable.errorMessage +'-'+opportunityIntegrable.requestFactoryInstance.getResponse().getBody() ;
                    
                }
               /*
                else if ((opportunityIntegrable.requestFactoryInstance.getResponse().getStatusCode() == 201 || opportunityIntegrable.requestFactoryInstance.getResponse().getStatusCode() == 200)) {
                    DWOpportunityIntegrableResponseTemplate responseTemplate = (DWOpportunityIntegrableResponseTemplate)opportunityIntegrable.deserializedResponseObject;
                    opportunity.StatusIntegracao__c = 'Integrado com sucesso';
                    opportunity.TentativasIntegracao__c = 0;
                    opportunity.CodigoERP__C = opportunity.Id;
                    
                    for(DWOpportunityIntegrableResponseTemplate.items proctProdut : responseTemplate.items){
                        String codProduto = proctProdut.ItemCode;

                        OpportunityLineItem opportuniyLineItem = new OpportunityLineItem();
                        System.debug('mapOpportunityLineItem.get(codProduto).Id; '+mapOpportunityLineItem.get(codProduto).Id);
                        opportuniyLineItem.id = mapOpportunityLineItem.get(codProduto).Id;
                        Double totalPercentualICMS = 0; // 10 ICMS  11 ICMS-IMP 12 ICMS-DIF //27          ICMS-Diferimento 
                        Double totalPercentualPIS = 0; //25          PIS_Exclusão_ICMS
                        Double totalPercentualIPI = 0; //16          IPI   
                        Double totalPercentualCofins = 0; //26          COFINS_Exclusão_ICMS
                        Double totalPercentualICMSST = 0; //13 ICMS-ST-ALIQ //14 ICMS-ST-PAUT //15 ICMS-ST-COMP
                        String taxas = '';
                        
                        //exemplo de taxas que irão retornar do calculo de tributação
                        //opportuniyLineItem.BaseCalc__c = quoteProduts.impostos.BASE_CALC != null ? quoteProduts.impostos.BASE_CALC :0 ;
                        // oppLineItemForUpdate.add(opportuniyLineItem);
                        
                    }
                    
                   

                }else if(opportunityIntegrable.requestFactoryInstance.getResponse().getStatusCode() != 200 && opportunityIntegrable.requestFactoryInstance.getResponse().getStatusCode() != 201 ){
                    
                    opportunity.StatusIntegracao__c = 'Integrado com erro';
                    log.ResponseBody__c = opportunityIntegrable.responseTemplate.toString();
                }else{
                    log.ResponseBody__c = opportunityIntegrable.responseTemplate.toString();
                    
                    opportunity.StatusIntegracao__c = 'Integrado com erro';
                }*/
                
            }catch (Exception e){
                System.debug(LoggingLevel.ERROR, '@@@QuoteIntegrableBatch e.getMessage()' + e.getMessage());
                System.debug(LoggingLevel.ERROR, '@@@QuoteIntegrableBatch e.getStackTraceString()' + e.getStackTraceString());
                log.ResponseBody__c = e.getMessage();
                opportunity.StatusIntegracao__c = 'Integrado com erro';
            }finally {
                if (opportunityIntegrable.requestFactoryInstance.getLog() != null) {
                    log = opportunityIntegrable.requestFactoryInstance.getLog();
                }
                log.Oportunidade__c = opportunity.Id;
                log.Name = opportunity.Name == null ? 'Integração da oportunidade ': 'IQ : '+opportunity.Name ;
                httpRequestLogList.add(log);
                opportunity.TentativasIntegracao__c = opportunity.TentativasIntegracao__c == null
                    ? 1
                    : opportunity.TentativasIntegracao__c+1;
                    
            }
        }
        
        
        if (httpRequestLogList.size() > 0) {
            System.debug(LoggingLevel.ERROR, '@@@QuoteIntegrableBatch httpRequestLogList' + httpRequestLogList);

            insert httpRequestLogList;
        }
        update oppLineItemForUpdate;
        Map<Id, String> quoteToPostErrorMessageMap = new Map<Id, String>();
        List<Database.UpsertResult> upsertResultList = Database.upsert(opportunityList, true);
        update opportunityList;
        for (Integer i = 0; i < opportunityList.size(); i++) {
            Database.UpsertResult upsertResult = upsertResultList[i];
            Opportunity origRecord = opportunityList[i];
            if (!upsertResult.isSuccess()) {
                quoteToPostErrorMessageMap.put(origRecord.Id, upsertResult.getErrors().get(0).getMessage());
            } 
        }
        
        List<FeedItem> feedItemListToInsert = new List<FeedItem>();
        for(Id id : quoteToPostErrorMessageMap.keySet()){
            FeedItem feed = new FeedItem();
            feed.ParentId =  id;
            feed.Body = 'Erro ao tentar enviar cotação para o ERP. ' + quoteToPostErrorMessageMap.get(id);
            feedItemListToInsert.add(feed);
        }
        List<List<SObject>> searchList = [
            FIND 'Erro ao tentar enviar cotação para o ERP.*' IN ALL FIELDS 
            RETURNING FeedItem (Id, Body WHERE id in :opportunitySet)];
        List<FeedItem> feedItemList = (List<FeedItem>)searchList[0];
        if(feedItemList.size() > 0){
            delete feedItemList;
        }
        
        insert feedItemListToInsert;
    }
    
    public void finish(Database.BatchableContext param1) {
    }    
    public class BatchContext implements Database.BatchableContext {

        public Id getChildJobId() {
            return null;
        }

        public Id getJobId() {
            return null;
        }
    }
}