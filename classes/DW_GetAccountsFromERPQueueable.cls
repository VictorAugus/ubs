public without sharing class DW_GetAccountsFromERPQueueable implements Queueable, Database.AllowsCallouts {
    Integer offset;
    
    public DW_GetAccountsFromERPQueueable(
        Integer offset
    ) {
        this.offset = offset;
    }
    
    public static void run(Integer offset) {
        System.enqueueJob(
            new DW_GetAccountsFromERPQueueable(offset)
        );
    }
     
    public void execute(QueueableContext context) {
        List<HttpRequestLog__c> httpRequestLogList = new List<HttpRequestLog__c>();
        HttpRequestLog__c log = new HttpRequestLog__c();
        List<Account> accountsToUpsert = new List<Account>();
        System.debug('PAGINA: ' + this.offset);
        
        try {
            DW_GetAccountsFromERPIntegrable integrable = new DW_GetAccountsFromERPIntegrable();
            integrable.page = this.offset;
            integrable.callIntegration(null);
            
            if (
                DW_Helper.hasSomeContent(integrable.requestFactoryInstance) &&
                DW_Helper.hasSomeContent(
                    integrable.requestFactoryInstance.getLog()
                )
            ) {
                log = integrable.requestFactoryInstance.getLog();
            } 
              if(integrable.isError){
                
                log.ResponseBody__c = integrable.errorMessage;
            }
            DW_GetAccountsFromERPResponseTemplate responseTemplate = (DW_GetAccountsFromERPResponseTemplate) integrable.deserializedResponseObject;
            for (DW_GetAccountsFromERPResponseTemplate.DW_ClienteIntegrable clienteResponse : responseTemplate.clientes) {
                Account account = new Account();
                account.name = clienteResponse.Name;
                account.CodigoERP__C = String.valueOf(clienteResponse.codigoERP);
                accountsToUpsert.add(account);
            }
            
       } catch (Exception e) {
            System.debug(
                LoggingLevel.ERROR,
                '@@@DW_GetAccountsFromERPQueueable e.getMessage()' + e.getMessage()
            );
            System.debug(
                LoggingLevel.ERROR,
                '@@@DW_GetAccountsFromERPQueueable e.getStackTraceString()' +
                e.getStackTraceString()
            );
        }finally {
            if(log.ResponseBody__c != null){
                if (log.ResponseBody__c.length() > 32762)          log.ResponseBody__c = log.ResponseBody__c.substring(0, 32762);
            }
            
            log.Name = 'Integração de busca clientes';
            httpRequestLogList.add(log);
        }
        if (httpRequestLogList.size() > 0) {
            insert httpRequestLogList;
        } 
        System.debug('accountsToUpsert:'+accountsToUpsert);
        List<Database.UpsertResult> upsertResultAccount = Database.upsert(
            accountsToUpsert,
            Account.fields.CodigoERP__c,
            true
        );
        if (accountsToUpsert.size() > 0 && !Test.isRunningTest() ) {
            //descomentar essa linha quando for desenvolver
           /*System.enqueueJob(
                new DW_GetAccountsFromERPQueueable(
                    this.offset + 1
                    
                )
            );*/
        } 
      
    }
    
}