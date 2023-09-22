global class DWScheduledProcessGetAc implements Schedulable, Database.AllowsCallouts {
     global void execute(SchedulableContext ctx)
    {
    System.enqueueJob(new DW_GetAccountsFromERPQueueable(1));  
        
    }

}