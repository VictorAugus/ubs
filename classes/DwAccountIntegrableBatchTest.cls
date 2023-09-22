@IsTest
public class DwAccountIntegrableBatchTest {
	private static String CLASS_NAME = 'DwAccountIntegrableBatchTest';
    
    @testSetup static void setup() {
         
        ByPass__c setting = new ByPass__c();
        setting.DesativarRegrasValidacao__c = true;
        
        insert setting;
        
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
    
    static testMethod void runInSyncMode(){
        Test.setMock(HttpCalloutMock.class, new DWAccIntegrableMock());
        String METHOD_NAME = 'runInSyncMode';
        
        List<Account> listAcc = [
            SELECT
            Id
            FROM Account WHERE CodigoERP__C = ''
        ];
        List<String> listAccInsert = new List<String>();
        
        listAccInsert.add(listAcc[0].id);
        
        Test.startTest();
        DwAccountIntegrableBatch.testQA(listAccInsert);
        Test.stopTest();
       	
        //descomentar quando for alterar a classe teste, é importante teste esse validação
        //System.assertEquals('Integrado com Sucesso', qtCheck.StatusIntegracao__c, 'Status da Integração atualizado corretamente');
    }
    static testMethod void runInSyncModeTwo(){
        Test.setMock(HttpCalloutMock.class, new DWAccIntegrableMock());
        String METHOD_NAME = 'runInSyncMode';
        
       List<Account> listAcc = [
            SELECT
            Id
            FROM Account WHERE CodigoERP__C != ''
        ];
        List<String> listAccInsert = new List<String>();
        
        listAccInsert.add(listAcc[0].id);
        
        Test.startTest();
        DwAccountIntegrableBatch.testQA(listAccInsert);
        Test.stopTest();
       //descomentar quando for alterar a classe teste, é importante teste esse validação
        //System.assertEquals('Integrado com Sucesso', qtCheck.StatusIntegracao__c, 'Status da Integração atualizado corretamente');
    }
    static testMethod void cancelThisSchedule(){
        String METHOD_NAME = 'cancelThisSchedule';
        
        List<Account> listQT = [
            SELECT
            Id
            FROM Account
        ];
        
        Test.startTest();
        DwAccountIntegrableBatch.cancelThisSchedule();
        Test.stopTest();
         
    }
    static testMethod void batchclass(){
        String METHOD_NAME = 'batchAcc';
        
        List<Account> listQT = [
            SELECT
            Id
            FROM Account
        ];
        
        Test.startTest();
        DwAccountIntegrableBatch obj = new DwAccountIntegrableBatch();
        DataBase.executeBatch(obj);  
        Test.stopTest();
        
    }
    static testMethod void assynclass(){
        String METHOD_NAME = 'batchAcc';
        
        List<Account> listQT = [
            SELECT
            Id
            FROM Account
        ];
        
        Test.startTest();
        DwAccountIntegrableBatch.scheduleThisClass(null);
        Test.stopTest();
        
    }
     
    
}