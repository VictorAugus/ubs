@IsTest
public class DWBatchDeleteObjHttpLogTest {
    private static String CLASS_NAME = 'DWBatchDeleteObjHttpLog';
    
    @testSetup static void setup() {
        DateTime now = System.now();
        Datetime before4month = now.addMonths(-4);
        
        String METHOD_NAME = 'setup';
        
        List<HttpRequestLog__c> httpList = new List<HttpRequestLog__c>();
        for(Integer i = 0; i<10; i++){
            HttpRequestLog__c http = new HttpRequestLog__c();
            http.Name = 'teste'+1;
            httpList.add(http);
            
        }
        
        insert httpList;
        for(HttpRequestLog__c testObj :httpList){
            Test.setCreatedDate(testObj.Id, before4month);
        }
        HttpRequestLog__c http = new HttpRequestLog__c();
        http.Name = 'testeHOJE';
        insert http;
        
        
    }
    @IsTest static void executeBatch() {
        Test.startTest();
        DWBatchDeleteObjHttpLog obj = new DWBatchDeleteObjHttpLog();
        DataBase.executeBatch(obj);         
        Test.stopTest();
        List<HttpRequestLog__c> filas = [SELECT ID FROM HttpRequestLog__c ];
        System.assertEquals(1, filas.SIZE());
    }
    @IsTest static void cancelThisSchedule() {
        
        Test.startTest();
        DWBatchDeleteObjHttpLog.cancelThisSchedule();       
        Test.stopTest();
        
    }
    @IsTest static void scheduleThisClass() {
        
        DWBatchDeleteObjHttpLog.scheduleThisClass(null);
        
    }
    @IsTest static void runEveryNMinutes() {
        
        
        DWBatchDeleteObjHttpLog.runEveryNMinutes(3);
        
    }

}