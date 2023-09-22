@isTest
public class DW_IntegrableHelperTest {
	@isTest
    public static void testSuccess(){
        Product2 product2 = new Product2();
        product2.Name = 'Teste';
        insert product2;
        DW_IntegrableHelper.tryToSaveRecordsOrPostOnChatter(new Set<Id>{product2.Id}, new List<Sobject>{product2}, 'Teste erro produto. ');
        
        String searchString = 'Teste erro produto';
        List<List<SObject>> searchList = [FIND :searchString IN ALL FIELDS RETURNING FeedItem (Id, Body)];
        List<FeedItem> feedItemList = (List<FeedItem>)searchList[0];
		System.debug('@@@feedItemList: '+ feedItemList);        
        System.assertEquals(0, feedItemList.size());
    }
    @isTest
    public static void testError(){
        Product2 product2 = new Product2();
        product2.Name = 'Teste';
        insert product2;
        product2.Name = null;
        DW_IntegrableHelper.tryToSaveRecordsOrPostOnChatter(new Set<Id>{product2.Id}, new List<Sobject>{product2}, 'Teste erro produto.');
        
        String searchString = 'Teste erro produto';
        List<List<SObject>> searchList = [FIND :searchString IN ALL FIELDS RETURNING FeedItem (Id, Body)];
        List<FeedItem> feedItemList = (List<FeedItem>)searchList[0];
		System.debug('@@@searchList: '+ searchList);     
        System.debug('@@@feedItemList: '+ [SELECT Body from FeedItem]);  
    }
    /*@isTest
    public static void testSuccessThenErrorThenSucesss(){
        Product2 product2 = new Product2();
        product2.Name = 'Teste';
        insert product2;
        product2.Name = null;
        update product2;
        product2.Name = 'Teste';
        update product2;
    }*/
}