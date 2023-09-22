global class DwOrderIntegrableBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Schedulable{
    @InvocableMethod(label='Chamar integracao de pedido')
    global static void testQA(List<String> id) {
        List<SObject> sObjectList = DW_QueryFactory.get('Order')
        .setCondition(
            DW_QueryCondition.newInstance(
                'Id', new List<String>{id.get(0)}))
        .withParent('Account')
        .run();
        (new DwOrderIntegrableBatch()).execute(new DwOrderIntegrableBatch.BatchContext(), sObjectList);
    }
 
 
    List<String> statusList = new List<String>();
    public DwOrderIntegrableBatch(){
        
    }
    public DwOrderIntegrableBatch(String[] statusList){
        this.statusList = statusList;
    }
    
    public void execute(SchedulableContext param1) {
        Database.executeBatch(new DwOrderIntegrableBatch(), 1);
    }
    
    global static void scheduleThisClass(String cron){
        cron = cron == null ? '0 0 * * * ?' : cron;
        System.schedule('DwOrderIntegrableBatch ' + cron, cron , new DwOrderIntegrableBatch());
    }
    
    global static void cancelThisSchedule() {
        CronTrigger[] asyncApexJob = [
            SELECT Id, CronJobDetail.name
            FROM CronTrigger
            WHERE CronJobDetail.name LIKE '%DwOrderIntegrableBatch%'
        ];
        for (CronTrigger job : asyncApexJob){
            System.abortJob(job.Id);
            
        }
    }
     
    public Iterable<SObject> start(Database.BatchableContext param1) {
        List<SObject> sObjectList = DW_QueryFactory.get('Order')
            .setCondition(
                DW_QueryCondition.newInstance(
                    'StatusIntegracao__c', 
                    this.statusList.size() > 0 ? this.statusList : new List<String>{'Pendente', 'Executado com erro'}))
           // .setCondition(DW_QueryCondition.newInstance('TentativasIntegracao__c', '<=', 30))
            .withParent('AccountId','Account')
            .run();
            System.debug(LoggingLevel.INFO, '@@@DwOrderIntegrableBatch sObjectList' + sObjectList);

        return (List<Order>)sObjectList;
    }
    
    public void execute(Database.BatchableContext param1, List<Order> orderList) {
        List<HttpRequestLog__c> httpRequestLogList = new List<HttpRequestLog__c>();
        System.debug(LoggingLevel.INFO, '@@@DwOrderIntegrableBatch orderList' + orderList);
        Set<Id> orderSet = new Set<Id>();
        for (Order order : orderList){
            orderSet.add(order.Id);
        }
        for (Order order : orderList){
            orderSet.add(order.Id);
            HttpRequestLog__c log = new HttpRequestLog__c();
            DwOrderIntegrable orderIntegrable = new DwOrderIntegrable();

            System.debug(LoggingLevel.INFO, '@@@DwOrderIntegrableBatch DwOrderIntegrableBatch.requestFactoryInstance.getLog()' + orderIntegrable.requestFactoryInstance.getLog());
			
            try{
                orderIntegrable.callIntegration(order);
                log = DW_Helper.hasSomeContent(orderIntegrable.requestFactoryInstance.getLog()) ? orderIntegrable.requestFactoryInstance.getLog():log;
                if(orderIntegrable.isError){
                    //se a integração cair nesse IF, a conta não pode integrar, como estamos na versão de teste...
                    //descomentar quando tiver sendo desenvolvido e retirar as ultimas tres linha
                    //order.StatusIntegracao__c = 'Integrado com erro';
                    
                    //lembre-se de remover essas tres linhas
                    order.StatusIntegracao__c = 'Integrado com sucesso';
                    order.CodigoERP__c =order.Id;
                    order.TentativasIntegracao__c = 0;
                    log.ResponseBody__c = orderIntegrable.errorMessage +'-'+orderIntegrable.requestFactoryInstance.getResponse().getBody() ;
                }
                /*
                 * aqui será necessario descomentar quando for desenvolver
                 
                else if ((orderIntegrable.requestFactoryInstance.getResponse().getStatusCode() == 201 || orderIntegrable.requestFactoryInstance.getResponse().getStatusCode() == 200) ) {
                    DWOrderIntegrableResponseTemplate responseTemplate = (DWOrderIntegrableResponseTemplate)orderIntegrable.deserializedResponseObject;
                    order.StatusIntegracao__c = 'Executado com sucesso';
                    if( String.isBlank(order.CodigoERP__c))order.CodigoERP__c = responseTemplate.codigoERP;
                    order.TentativasIntegracao__c = 0;
                    
                }else{
                    order.StatusIntegracao__c = 'Integrado com erro';
                    log.ResponseBody__c = orderIntegrable.errorMessage;
                }
				*/
                
            }catch (Exception e){
                System.debug(LoggingLevel.ERROR, '@@@AccountIntegrableBatch e.getMessage()' + e.getMessage());
                System.debug(LoggingLevel.ERROR, '@@@AccountIntegrableBatch e.getStackTraceString()' + e.getStackTraceString());
                log.ResponseBody__c = e.getMessage();
                order.StatusIntegracao__c = 'Integrado com erro';
            }finally {
                if (orderIntegrable.requestFactoryInstance.getLog() != null) {
                    log = orderIntegrable.requestFactoryInstance.getLog();
                }
                log.Order__c = order.Id;
                log.Name = order.Name == null ? 'Integração de pedido : ': 'Integração de pedido : ' + order.Name;
                httpRequestLogList.add(log);
                order.TentativasIntegracao__c = order.TentativasIntegracao__c == null
                    ? 1
                    : order.TentativasIntegracao__c+1;
                    
            }
        }
        
        
        if (httpRequestLogList.size() > 0) {
            System.debug(LoggingLevel.ERROR, '@@@AccountIntegrableBatch httpRequestLogList' + httpRequestLogList);

            insert httpRequestLogList;
        }
        
        Map<Id, String> orderToPostErrorMessageMap = new Map<Id, String>();
        List<Database.UpsertResult> upsertResultList = Database.upsert(orderList, false);
        for (Integer i = 0; i < orderList.size(); i++) {
            Database.UpsertResult upsertResult = upsertResultList[i];
            Order origRecord = orderList[i];
            if (!upsertResult.isSuccess()) {
                orderToPostErrorMessageMap.put(origRecord.Id, upsertResult.getErrors().get(0).getMessage());
            } 
        }
        
        List<FeedItem> feedItemListToInsert = new List<FeedItem>();
        for(Id id : orderToPostErrorMessageMap.keySet()){
            FeedItem feed = new FeedItem();
            feed.ParentId =  id;
            feed.Body = 'Erro ao tentar enviar o pedido para o ERP. ' + orderToPostErrorMessageMap.get(id);
            feedItemListToInsert.add(feed);
        }
        List<List<SObject>> searchList = [
            FIND 'Erro ao tentar enviar conta para o ERP.*' IN ALL FIELDS 
            RETURNING FeedItem (Id, Body WHERE id in :orderSet)];
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