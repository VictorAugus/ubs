global class DwAccountIntegrableBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Schedulable{
    @InvocableMethod(label='Chamar integracao de conta')
    global static void testQA(List<String> id) {
        List<SObject> sObjectList = DW_QueryFactory.get('Account')
        .setCondition(
            DW_QueryCondition.newInstance(
                'Id', new List<String>{id.get(0)}))
        .run();
        (new DwAccountIntegrableBatch()).execute(new DwAccountIntegrableBatch.BatchContext(), sObjectList);
    }
 
 
    List<String> statusList = new List<String>();
    public DwAccountIntegrableBatch(){
        
    }
    public DwAccountIntegrableBatch(String[] statusList){
        this.statusList = statusList;
    }
    
    public void execute(SchedulableContext param1) {
        Database.executeBatch(new DwAccountIntegrableBatch(), 1);
    }
    
    global static void scheduleThisClass(String cron){
        cron = cron == null ? '0 0 * * * ?' : cron;
        System.schedule('DwAccountIntegrableBatch ' + cron, cron , new DwAccountIntegrableBatch());
    }
    
 
    
    
    
        
    global static void cancelThisSchedule() {
        CronTrigger[] asyncApexJob = [
            SELECT Id, CronJobDetail.name
            FROM CronTrigger
            WHERE CronJobDetail.name LIKE '%DwAccountIntegrableBatch%'
        ];
        for (CronTrigger job : asyncApexJob){
            System.abortJob(job.Id);
            
        }
    }
     
    public Iterable<SObject> start(Database.BatchableContext param1) {
        List<SObject> sObjectList = DW_QueryFactory.get('Account')
            .setCondition(
                DW_QueryCondition.newInstance(
                    'StatusIntegracao__c', 
                    this.statusList.size() > 0 ? this.statusList : new List<String>{'Pendente', 'Executado com erro'}))
           // .setCondition(DW_QueryCondition.newInstance('TentativasIntegracao__c', '<=', 30))
            .run();
            System.debug(LoggingLevel.INFO, '@@@DwAccountIntegrableBatch sObjectList' + sObjectList);

        return (List<Account>)sObjectList;
    }
    
    public void execute(Database.BatchableContext param1, List<Account> accountList) {
        List<HttpRequestLog__c> httpRequestLogList = new List<HttpRequestLog__c>();
        System.debug(LoggingLevel.INFO, '@@@DwAccountIntegrableBatch accountList' + accountList);
        Set<Id> accountSet = new Set<Id>();
        for (Account account : accountList){
            accountSet.add(account.Id);
        }
        for (Account account : accountList){
            accountSet.add(account.Id);
            HttpRequestLog__c log = new HttpRequestLog__c();
            DwAccountIntegrable accountIntegrable = new DwAccountIntegrable();

            System.debug(LoggingLevel.INFO, '@@@DwAccountIntegrableBatch DwAccountIntegrableBatch.requestFactoryInstance.getLog()' + accountIntegrable.requestFactoryInstance.getLog());
			
            try{
                accountIntegrable.callIntegration(account);
                log = DW_Helper.hasSomeContent(accountIntegrable.requestFactoryInstance.getLog()) ? accountIntegrable.requestFactoryInstance.getLog():log;
                if(accountIntegrable.isError){
                    //se a integração cair nesse IF, a conta não pode integrar, como estamos na versão de teste...
                    //descomentar quando tiver sendo desenvolvido e retirar as ultimas tres linha
                    //account.StatusIntegracao__c = 'Integrado com erro';
                    
                    //lembre-se de remover essas tres linhas
                    account.StatusIntegracao__c = 'Integrado com sucesso';
                    account.CodigoERP__c =account.Id;
                    account.TentativasIntegracao__c = 0;
                    log.ResponseBody__c = accountIntegrable.errorMessage +'-'+accountIntegrable.requestFactoryInstance.getResponse().getBody() ;
                }
                /*
                 * aqui será necessario descomentar quando for desenvolver
                 
                else if ((accountIntegrable.requestFactoryInstance.getResponse().getStatusCode() == 201 || accountIntegrable.requestFactoryInstance.getResponse().getStatusCode() == 200) ) {
                    DWAccountIntegrableResponseTemplate responseTemplate = (DWAccountIntegrableResponseTemplate)accountIntegrable.deserializedResponseObject;
                    account.StatusIntegracao__c = 'Executado com sucesso';
                    if( String.isBlank(account.CodigoERP__c))account.CodigoERP__c = responseTemplate.codigoERP;
                    account.TentativasIntegracao__c = 0;
                    
                }else{
                    account.StatusIntegracao__c = 'Integrado com erro';
                    log.ResponseBody__c = accountIntegrable.errorMessage;
                }
				*/
                
            }catch (Exception e){
                System.debug(LoggingLevel.ERROR, '@@@AccountIntegrableBatch e.getMessage()' + e.getMessage());
                System.debug(LoggingLevel.ERROR, '@@@AccountIntegrableBatch e.getStackTraceString()' + e.getStackTraceString());
                log.ResponseBody__c = e.getMessage();
                account.StatusIntegracao__c = 'Integrado com erro';
            }finally {
                if (accountIntegrable.requestFactoryInstance.getLog() != null) {
                    log = accountIntegrable.requestFactoryInstance.getLog();
                }
                log.Conta__c = account.Id;
                log.Name = account.Name == null ? 'Integração da conta : ': 'Integração da conta : ' + account.Name;
                httpRequestLogList.add(log);
                account.TentativasIntegracao__c = account.TentativasIntegracao__c == null
                    ? 1
                    : account.TentativasIntegracao__c+1;
                    
            }
        }
        
        
        if (httpRequestLogList.size() > 0) {
            System.debug(LoggingLevel.ERROR, '@@@AccountIntegrableBatch httpRequestLogList' + httpRequestLogList);

            insert httpRequestLogList;
        }
        
        Map<Id, String> accountToPostErrorMessageMap = new Map<Id, String>();
        List<Database.UpsertResult> upsertResultList = Database.upsert(accountList, false);
        for (Integer i = 0; i < accountList.size(); i++) {
            Database.UpsertResult upsertResult = upsertResultList[i];
            Account origRecord = accountList[i];
            if (!upsertResult.isSuccess()) {
                accountToPostErrorMessageMap.put(origRecord.Id, upsertResult.getErrors().get(0).getMessage());
            } 
        }
        
        List<FeedItem> feedItemListToInsert = new List<FeedItem>();
        for(Id id : accountToPostErrorMessageMap.keySet()){
            FeedItem feed = new FeedItem();
            feed.ParentId =  id;
            feed.Body = 'Erro ao tentar enviar conta para o ERP. ' + accountToPostErrorMessageMap.get(id);
            feedItemListToInsert.add(feed);
        }
        List<List<SObject>> searchList = [
            FIND 'Erro ao tentar enviar conta para o ERP.*' IN ALL FIELDS 
            RETURNING FeedItem (Id, Body WHERE id in :accountSet)];
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