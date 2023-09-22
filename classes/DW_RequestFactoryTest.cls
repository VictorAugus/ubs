@IsTest
public with sharing class DW_RequestFactoryTest {
    @isTest
    public static void main(){
        Test.setMock(HttpCalloutMock.class, new DW_RequestFactoryTestMock());
        DW_RequestFactory.makePost('okok').setHeaders(new Map<String, String>{'ok'=>'ok'})
                .setQueryParameters(new Map<String, String>{'ok'=>'ok'})
                .setBody('')
                .send();

        DW_RequestFactory.makeGet('okok').setHeaders(new Map<String, String>{'ok'=>'ok'})
                .setQueryParameters(new Map<String, String>{'ok'=>'ok'})
                .setBody('')
                .send();
        
         DW_RequestFactory.makePut('okok').setHeaders(new Map<String, String>{'ok'=>'ok'})
                .setQueryParameters(new Map<String, String>{'ok'=>'ok'})
                .setBody('')
                .send();
        
         DW_RequestFactory.makPatch('okok').setHeaders(new Map<String, String>{'ok'=>'ok'})
                .setQueryParameters(new Map<String, String>{'ok'=>'ok'})
                .setBody('')
                .send();
    }
}