@IsTest
public class DWFlowExecuteImportTest {
@IsTest
    public static void main(){
        List<DWFlowExecuteImport.FlowInput> batchInputList = new List<DWFlowExecuteImport.FlowInput>{
                new DWFlowExecuteImport.FlowInput('DWScheduledProcessGetAc')
                    
        };
        DWFlowExecuteImport.runBatch(batchInputList);
    }
}