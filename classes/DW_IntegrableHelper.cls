public class DW_IntegrableHelper {
    public static void tryToSaveRecordsOrPostOnChatter(Set<Id> deletePreviousPostSet, List<Sobject> sobjList, String message){        
        Map<Id, String> sobjToPostErrorMessageMap = new Map<Id, String>();
        List<Database.UpsertResult> upsertResultList = Database.upsert(sobjList, false);
        
        for (Integer i = 0; i < sobjList.size(); i++) {
            Database.UpsertResult upsertResult = upsertResultList[i];
            Sobject origRecord = sobjList[i];
            if (!upsertResult.isSuccess()) {
                sobjToPostErrorMessageMap.put(origRecord.Id, upsertResult.getErrors().get(0).getMessage());
            } 
        }
        
        List<FeedItem> feedItemListToInsert = new List<FeedItem>();
        for(Id id : sobjToPostErrorMessageMap.keySet()){
            FeedItem feed = new FeedItem();
            feed.ParentId =  id;
            feed.Body = message + ' ' + sobjToPostErrorMessageMap.get(id);
            feedItemListToInsert.add(feed);
        }
        String searchString = '*' + message + '*';
        List<List<SObject>> searchList = [FIND :searchString IN ALL FIELDS RETURNING FeedItem (Id, Body WHERE ParentId in :deletePreviousPostSet)];
        
        List<FeedItem> feedItemList = (List<FeedItem>)searchList[0];
        if(feedItemList.size() > 0){
            delete feedItemList;
        }
        System.debug(LoggingLevel.ERROR, '@@feedItemListToInsert: ' + feedItemListToInsert);
        insert feedItemListToInsert;
    }
}