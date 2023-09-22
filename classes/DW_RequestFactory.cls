/**
 * Created by guilhermereis on 08/12/2020.
 */

/**
 * Created by guilh on 19/05/2020.
 */

public with sharing class DW_RequestFactory {
    String baseEndPoint;
    String fullEndPoint;
    public HttpRequest httpRequest = new HttpRequest();
    Map<String, String> queryParameterMap = new Map<String, String>();
    Map<String, String> headerMap = new Map<String, String>();
    public HttpResponse httpResponse = new HttpResponse();
    private HttpRequestLog__c log = new HttpRequestLog__c();

    @future
    public static void saveLogAsync(String jsonLog){
        //insert (HttpRequestLog__c)JSON.deserialize(jsonLog, HttpRequestLog__c.class);
    }

    public HttpResponse getResponse(){
        return this.httpResponse;
    }

    public HttpRequest getRequest(){
        return this.httpRequest;
    }

    public HttpRequestLog__c getLog(){
        return this.log;
    }

    public DW_RequestFactory saveLogAsync(){
        //DW_RequestFactory.saveLogAsync(JSON.serialize(this.getLog()));
        return this;
    }

    private void constructEndpoint(){
        List<String> keyPlusValueList = new List<String>();
        for(String key : this.queryParameterMap.keySet()){
            keyPlusValueList.add(key + '=' + EncodingUtil.urlEncode(this.queryParameterMap.get(key), 'UTF-8') );
        }
        Integer queryAdded = 0;
        String allQueryParameterAlreadyFormed = '';
        for(String keyPlusValue : keyPlusValueList){
            allQueryParameterAlreadyFormed += queryAdded == 0
                    ? '?'+keyPlusValue
                    : '&'+keyPlusValue;
            queryAdded++;
        }

        this.httpRequest.setEndpoint(baseEndPoint + allQueryParameterAlreadyFormed);
    }
    private void constructHeaders(){
        for (String key : this.headerMap.keySet()){
            this.httpRequest.setHeader(key, this.headerMap.get(key));
        }
    }
    private void constructLogBeforeSend(){
        //alimentar dados do log antes de enviar a requisição
        this.log = new HttpRequestLog__c(
            Endpoint__c = this.httpRequest.getEndpoint(),
            Headers__c = JSON.serialize(this.headerMap),
            Method__c = this.httpRequest.getMethod(),
            RequestBody__c = this.httpRequest.getBody()
            //ResponseBody__c
            //StatusCode__c
        );
    }
    private void constructLogAfterSend(){
        //alimentar dados do log antes de enviar a requisição
        this.log.ResponseBody__c = this.httpResponse.getBody();
        this.log.StatusCode__c = this.httpResponse.getStatusCode();
    }


    public DW_RequestFactory send(){
        try{
            Http http = new Http();
            this.constructEndpoint();
            this.constructHeaders();
            this.constructLogBeforeSend();
            this.httpRequest.setTimeout(120000);
            if (this.baseEndPoint == '' || this.baseEndPoint == null) {
                throw new DW_Exception('Endpoint inválido.');
            }

            System.debug(LoggingLevel.INFO, 'sending...' + this.httpRequest.getEndpoint());

            this.httpResponse = http.send(this.httpRequest);
            System.debug(LoggingLevel.INFO, 'returning...' + this.httpRequest.getEndpoint());
            System.debug(LoggingLevel.INFO, 'returning...' +  this.httpResponse.getBody());

        }catch(Exception e){
            System.debug(LoggingLevel.ERROR, '@@DW_RequestFactory.send() e.getMessage: ' + e.getMessage());
            System.debug(LoggingLevel.ERROR, '@@DW_RequestFactory.send() e.getCause: ' + e.getCause());
            System.debug(LoggingLevel.ERROR, '@@DW_RequestFactory.send() e.getLineNumber: ' + e.getLineNumber());
            System.debug(LoggingLevel.ERROR, '@@DW_RequestFactory.send() e.getStackTraceString: ' + String.valueOf(e.getStackTraceString()));
            this.httpResponse = new HttpResponse();
            this.httpResponse.setBody(e.getMessage() + '\n' + e.getStackTraceString());
        }finally {
            this.constructLogAfterSend();
        }
        return this;
    }

    public static DW_RequestFactory makeGet(String baseEndPoint){
        DW_RequestFactory requestFactory = new DW_RequestFactory();
        requestFactory.httpRequest.setMethod('GET');
        requestFactory.baseEndPoint = baseEndPoint;
        return requestFactory;
    }

    public static DW_RequestFactory makePost(String baseEndPoint){
        DW_RequestFactory requestFactory = new DW_RequestFactory();
        requestFactory.httpRequest.setMethod('POST');
        requestFactory.baseEndPoint = baseEndPoint;
        return requestFactory;
    }
    public static DW_RequestFactory makePut(String baseEndPoint){
        DW_RequestFactory requestFactory = new DW_RequestFactory();
        requestFactory.httpRequest.setMethod('PUT');
        requestFactory.baseEndPoint = baseEndPoint;
        return requestFactory;
    }
    public static DW_RequestFactory makPatch(String baseEndPoint){
        DW_RequestFactory requestFactory = new DW_RequestFactory();
        requestFactory.httpRequest.setMethod('PATCH');
        requestFactory.baseEndPoint = baseEndPoint;
        return requestFactory;
    }

    public DW_RequestFactory setQueryParameters(Map<String, String> queryParameterMap){
        for (String key : queryParameterMap.keySet()){
            this.queryParameterMap.put(key, queryParameterMap.get(key));
        }
        return this;
    }

    public DW_RequestFactory addQueryParameter(String key, String value){
        queryParameterMap.put(key, value);
        return this;
    }

    public DW_RequestFactory setHeaders(Map<String, String> headerMap){
        for (String key : headerMap.keySet()){
            this.headerMap.put(key, headerMap.get(key));
        }
        return this;
    }

    public DW_RequestFactory addHeader(String key, String value){
        headerMap.put(key, value);
        return this;
    }
    
    public DW_RequestFactory setBody(String body){
        this.httpRequest.setBody(body);
        return this;
    }
}