global class DWBatchDeleteObjHttpLog implements Database.Batchable<SObject>, Database.AllowsCallouts, Schedulable{
   
    List<String> statusList = new List<String>();
    public DWBatchDeleteObjHttpLog(){
        
    }
    public void execute(SchedulableContext param1) {
        Database.executeBatch(new DWBatchDeleteObjHttpLog(), 1);
    }
    
    global static void scheduleThisClass(String cron){
        cron = cron == null ? '0 0 * * * ?' : cron;
        System.schedule('DWBatchDeleteObjHttpLog ' + cron, cron , new DWBatchDeleteObjHttpLog());
    }
    
    global static void runEveryNMinutes(Integer each) {
        for (Integer i = 0; i < 60; i += each){
            String cron = '0 ' + i + ' * * * ?';
            System.schedule('DWBatchDeleteObjHttpLog ' + cron, cron, new DWBatchDeleteObjHttpLog());
        }
    }
    
    global static void cancelThisSchedule() {
        CronTrigger[] asyncApexJob = [
            SELECT Id, CronJobDetail.name
            FROM CronTrigger
            WHERE CronJobDetail.name LIKE '%DWBatchDeleteObjHttpLog%'
        ];
        for (CronTrigger job : asyncApexJob){
            System.abortJob(job.Id);
            
        }
    }
    
    public Iterable<SObject> start(Database.BatchableContext param1) {
        List<HttpRequestLog__c> sObjectList = [SELECT ID, NAME, createddate FROM HttpRequestLog__c where ( createddate < LAST_N_MONTHS:3) ORDER BY  createddate DESC limit 1000 ];
        System.debug(LoggingLevel.INFO, '@@@DWBatchDeleteObjHttpLog sObjectList' + sObjectList);
        return (List<HttpRequestLog__c>)sObjectList;
    }
    
    public void execute(Database.BatchableContext param1, List<HttpRequestLog__c> filaList) {
        Database.deleteResult[] srList = Database.delete(filaList, true);
        Set<Id> httpSet = new Set<Id>();
        for(HttpRequestLog__c http : filaList ){
            httpSet.add(http.id);
        }
        Map<Id, String> httpToPostErrorMessageMap = new Map<Id, String>();
        
        for (Integer i = 0; i < filaList.size(); i++) {
            Database.deleteResult deleteResult = srList[i];
            HttpRequestLog__c origRecord = filaList[i];
            if (!deleteResult.isSuccess()) {
                httpToPostErrorMessageMap.put(origRecord.Id, deleteResult.getErrors().get(0).getMessage());
            } 
        }
        
        List<FeedItem> feedItemListToInsert = new List<FeedItem>();
        for(Id id : httpToPostErrorMessageMap.keySet()){
            FeedItem feed = new FeedItem();
            feed.ParentId =  id;
            feed.Body = 'Erro ao tentar deletar http. ' + httpToPostErrorMessageMap.get(id);
            feedItemListToInsert.add(feed);
        }
        List<List<SObject>> searchList = [
            FIND 'Erro ao tentar deletar http.*' IN ALL FIELDS 
            RETURNING FeedItem (Id, Body WHERE id in :httpSet)];
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