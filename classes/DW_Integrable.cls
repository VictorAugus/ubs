/**
 * Created by guilhermereis on 09/12/2020.
 */

public abstract class DW_Integrable {
    public DW_RequestFactory requestFactoryInstance = new DW_RequestFactory();
    public Object deserializedResponseObject;
    public Object deserializedRequestObject;
    public String method;
    public String errorMessage;
    public String successMessage;
    public Boolean isError = false;
    public Boolean isSuccess = false;

    public abstract void callIntegration(Object obj);
    public abstract String constructEndpoint();
    public abstract String setMethod();
    public abstract Map<String, String> constructHeaders();
    public abstract Map<String, String> constructQueryParameters();
    public abstract String getSerializedRequest();
    public abstract void setDeserializedResponseObject();
    public abstract void finish();

    public DW_Integrable sendRequest() {
        try{
            this.constructFullRequest();
            this.requestFactoryInstance.send();
            if (this.requestFactoryInstance.getResponse().getStatusCode() != 200) {
                this.isError = true;
                this.errorMessage = this.requestFactoryInstance.getResponse().getBody();
            }else{
                this.setDeserializedResponseObject();
                this.isSuccess = true;
                this.errorMessage = 'Integração realizada com sucesso';
            }
        }catch (Exception e){
            System.debug(LoggingLevel.ERROR, '@@DW_Integrable.sendRequest() e.getMessage: ' + e.getMessage());
            System.debug(LoggingLevel.ERROR, '@@DW_Integrable.sendRequest() e.getCause: ' + e.getCause());
            System.debug(LoggingLevel.ERROR, '@@DW_Integrable.sendRequest() e.getLineNumber: ' + e.getLineNumber());
            System.debug(LoggingLevel.ERROR, '@@DW_Integrable.sendRequest() e.getStackTraceString: ' + String.valueOf(e.getStackTraceString()));

            this.isError = true;
            this.errorMessage = e.getMessage();
        }finally {
            this.finish();
        }
        return this;
    }

    public void constructFullRequest() {
        this.method = this.setMethod();
        if (this.method == 'GET') {
            this.requestFactoryInstance = DW_RequestFactory.makeGet(
                    constructEndpoint()
            );
        }else if (this.method == 'POST') {
            this.requestFactoryInstance = DW_RequestFactory.makePost(
                    constructEndpoint()
            ).setBody(getSerializedRequest());
        }else if (this.method == 'PUT') {
            this.requestFactoryInstance = DW_RequestFactory.makePut(
                    constructEndpoint()
            ).setBody(getSerializedRequest());
        }else if (this.method == 'PATCH') {
            this.requestFactoryInstance = DW_RequestFactory.makPatch(
                    constructEndpoint()
            ).setBody(getSerializedRequest());
        }else{
            throw new StringException('Método não informado ou inválido. Valores possíveis: GET, POST.');
        }
        this.requestFactoryInstance.setHeaders(constructHeaders());
        this.requestFactoryInstance.setQueryParameters(constructQueryParameters());
    }

}