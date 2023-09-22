@IsTest
public class DWOpportunityIntegrableBatchTest {
 private static String CLASS_NAME = 'DWOpportunityIntegrableBatchTest';
    
    @testSetup static void setup() {
        ByPass__c setting = new ByPass__c();
        setting.DesativarRegrasValidacao__c = true;
        
        insert setting;
        String METHOD_NAME = 'setup';
        
        Test.setMock(HttpCalloutMock.class, new DWOpportunityIntegrableMock());
        
        
        Account acc = new Account(name = 'teste',CodigoERP__c = '1242');
        insert acc;
        
        Product2 objProduct = new Product2(CodigoERP__c= '4000.0500.002150',Name = 'Test product1',Family= '103');                                            
        insert objProduct;
        PriceBookEntry objPBE = new PriceBookEntry(UnitPrice = 300, PriceBook2Id = Test.getStandardPricebookId(),
                                                   Product2Id = objProduct.Id, IsActive = true);
        insert objPBE;
        Opportunity opp = new Opportunity(name = 'test', AccountId = acc.Id, StageName = 'Prospecting', closedate = system.today(),Pricebook2Id=Test.getStandardPricebookId());
        insert opp;
       
        OpportunityLineItem olli = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id, TotalPrice=10, PriceBookEntryId=objPBE.Id); 
        insert olli; 
     
        
    }
    
    static testMethod void runInSyncMode(){
        Test.setMock(HttpCalloutMock.class, new DWOpportunityIntegrableMock());
        String METHOD_NAME = 'runInSyncMode';
        
        List<Opportunity> listQuote = [
            SELECT
            Id
            FROM Opportunity
        ];
        List<String> idQuoteList = new List<String>();
        
        idQuoteList.add(listQuote[0].id);
        //System.assertEquals(1, listAcct.size(), 'Conta não encontrada');
        
        Test.startTest();
        DWOpportunityIntegrableBatch.testQA(idQuoteList);
        Test.stopTest();
        
        Opportunity qtCheck = [
            SELECT StatusIntegracao__c
            FROM Opportunity
            WHERE Id =: listQuote[0].Id
        ];
       // System.assertEquals('Integrado com Sucesso', qtCheck.StatusIntegracao__c, 'Status da Integração atualizado corretamente');
    }
    static testMethod void cancelThisSchedule(){
        String METHOD_NAME = 'cancelThisSchedule';
        
        List<Opportunity> listQT = [
            SELECT
            Id
            FROM Opportunity
        ];
        
        Test.startTest();
        DWOpportunityIntegrableBatch.cancelThisSchedule();
        Test.stopTest();
        
    }
    static testMethod void runEveryNMinutes(){
        String METHOD_NAME = 'runEveryNMinutes';
        
        List<Opportunity> listQT = [
            SELECT
            Id
            FROM Opportunity
        ];
        
        Test.startTest();
        DWOpportunityIntegrableBatch.runEveryNMinutes(4);
        Test.stopTest();
        
    }
}