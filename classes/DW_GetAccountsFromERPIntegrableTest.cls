@IsTest
public class DW_GetAccountsFromERPIntegrableTest {
	private static String CLASS_NAME = 'DwAccountIntegrableBatchTest';
    
    @testSetup static void setup() {
        String METHOD_NAME = 'setup';
        
        Test.setMock(HttpCalloutMock.class, new DWAccIntegrableMock());
       
        Account acc = new Account(name = 'teste',
                                  Description='107'
                                  );
        
        insert acc;
        Account acc2 = new Account(name = 'teste',
                                   Description='107',
                                   CodigoERP__c='idERP'
                                   
                                  );
        insert acc2;
    
    }
    @IsTest
    public static void schedulle(){
        Test.setMock(HttpCalloutMock.class, new DW_GetAccountsFromERPIntegrableTestMock());
         Account acc = new Account(name = 'teste',
                                  Description='107'
                                  );
        insert acc;
        Test.startTest();        
        String CRON_EXP = '0 0 * * * ?';
        String jobId = System.schedule('ScheduledProcessGetAc', CRON_EXP, new DWScheduledProcessGetAc());
		Test.stopTest();
    }
}