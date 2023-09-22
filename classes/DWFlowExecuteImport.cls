public class DWFlowExecuteImport {
	@InvocableMethod
    public static List<FlowOutput> runBatch(List<FlowInput> flowInputList){
        
        List<ApexClass> apexClassList = new List<ApexClass>();
        List<FlowOutput> flowOutputList = new List<FlowOutput>();
        for (FlowInput flowInput : flowInputList){
            if (flowInput.execute == 'getClass'){
                apexClassList = [Select Name,id from ApexClass where Name like '%ImportQueueable'];
            }
            //descomentar e fazer a tratativa quando for desenvolver
            //if(flowInput.execute == 'DWScheduledProcessGetAc'){String jobId = System.schedule('DWScheduledProcessGetAc', '0 0 * * * ?', new DWScheduledProcessGetAc());}
            //remover a linha abaixo quando for desenvolver
            //
            //String jobId = System.schedule('DWScheduledProcessGetAc', '0 0 * * * ?', new DWScheduledProcessGetAc());   

            System.enqueueJob(
            new DW_GetAccountsFromERPQueueable(1)
        );
        }
        FlowOutput output = new FlowOutput();
        output.apexClassList = apexClassList;
        return new List<FlowOutput>{output};
    }
    public class FlowInput{
        @InvocableVariable
        public String execute;
       
        
        public FlowInput(){
        }
        public FlowInput(String batch){
            this.execute = execute;
        }
    }
    public class FlowOutput{
        @InvocableVariable
        public List<ApexClass> apexClassList;
        
    }

}