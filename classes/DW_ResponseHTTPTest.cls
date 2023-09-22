@isTest
public class DW_ResponseHTTPTest {
    @isTest 
    public static void main() {
        Account acc = new Account(
            Name ='Teste account'
        );
        insert acc;
        DW_ResponseHTTP.success([SELECT Id FROM Account]);
        DW_ResponseHTTP.successObj([SELECT Id FROM Account]);
        DW_ResponseHTTP.error(new List<String>{acc.Id});
        DW_ResponseHTTP.errorObj(new List<String>{acc.Id});
        DW_ResponseHTTP.error(new List<String>{acc.Id}, new Map<String, Object>());
        DW_ResponseHTTP.errorObj(new List<String>{acc.Id}, new Map<String, Object>());
    }
}