/**
 * Created by guilhermereis on 22/02/21.
 */
@IsTest
public with sharing class DW_IntegrableTest {
    @IsTest
    public static void main(){
        Test.setMock(HttpCalloutMock.class, new DW_IntegrableTestMock());
        Account acc = new Account();
        DW_IntegrableTest.instanceSuccessPost instanceSuccessPost = new DW_IntegrableTest.instanceSuccessPost();
        instanceSuccessPost.callIntegration(acc);
        DW_IntegrableTest.instanceSuccessGet instanceSuccessGet = new DW_IntegrableTest.instanceSuccessGet();
        instanceSuccessGet.callIntegration(acc);
        DW_IntegrableTest.instanceSuccessPut instanceSuccessPut = new DW_IntegrableTest.instanceSuccessPut();
        instanceSuccessPut.callIntegration(acc);
        DW_IntegrableTest.instanceSuccessPatch instanceSuccessPatch = new DW_IntegrableTest.instanceSuccessPatch();
        instanceSuccessPatch.callIntegration(acc);
    }
    public class instanceSuccessPost extends DW_Integrable{
        public override void callIntegration(Object obj) {
            this.sendRequest();
        }

        public override String constructEndpoint() {
            return 'http://teste.com';
        }

        public override String setMethod() {
            return 'POST';
        }

        public override Map<String, String> constructHeaders() {
            return new Map<String, String>{
                'teste' => 'teste'
            };
        }

        public override Map<String, String> constructQueryParameters() {
            return new Map<String, String>{
                'teste' => 'teste'
            };
        }

        public override String getSerializedRequest() {
            return '';
        }

        public override void setDeserializedResponseObject() {
        }

        public override void finish() {
        }
    }
    public class instanceSuccessGet extends DW_Integrable{
        public override void callIntegration(Object obj) {
            this.sendRequest();
        }

        public override String constructEndpoint() {
            return 'http://teste.com';
        }

        public override String setMethod() {
            return 'GET';
        }

        public override Map<String, String> constructHeaders() {
            return new Map<String, String>{
                    'teste' => 'teste'
            };
        }

        public override Map<String, String> constructQueryParameters() {
            return new Map<String, String>{
                    'teste' => 'teste'
            };
        }

        public override String getSerializedRequest() {
            return '';
        }

        public override void setDeserializedResponseObject() {
        }

        public override void finish() {
        }
    }
    public class instanceSuccessPUT extends DW_Integrable{
        public override void callIntegration(Object obj) {
            this.sendRequest();
        }

        public override String constructEndpoint() {
            return 'http://teste.com';
        }

        public override String setMethod() {
            return 'PUT';
        }

        public override Map<String, String> constructHeaders() {
            return new Map<String, String>{
                    'teste' => 'teste'
            };
        }

        public override Map<String, String> constructQueryParameters() {
            return new Map<String, String>{
                    'teste' => 'teste'
            };
        }

        public override String getSerializedRequest() {
            return '';
        }

        public override void setDeserializedResponseObject() {
        }

        public override void finish() {
        }
    }
    public class instanceSuccessPatch extends DW_Integrable{
        public override void callIntegration(Object obj) {
            this.sendRequest();
        }

        public override String constructEndpoint() {
            return 'http://teste.com';
        }

        public override String setMethod() {
            return 'PATCH';
        }

        public override Map<String, String> constructHeaders() {
            return new Map<String, String>{
                    'teste' => 'teste'
            };
        }

        public override Map<String, String> constructQueryParameters() {
            return new Map<String, String>{
                    'teste' => 'teste'
            };
        }

        public override String getSerializedRequest() {
            return '';
        }

        public override void setDeserializedResponseObject() {
        }

        public override void finish() {
        }
    }
}