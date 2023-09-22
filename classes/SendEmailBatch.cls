global class  SendEmailBatch  implements Database.Batchable<SObject>, Database.AllowsCallouts, Schedulable{
   
    List<String> statusList = new List<String>();
    public SendEmailBatch(){
        
    }
    public void execute(SchedulableContext param1) {
        Database.executeBatch(new SendEmailBatch(),1);
    }
    
    global static void scheduleThisClass(String cron){
        cron = cron == null ? '0 0 * * * ?' : cron;
        System.schedule('SendEmailBatch ' + cron, cron , new SendEmailBatch());
    }
    
    global static void runEveryNMinutes(Integer each) {
        for (Integer i = 0; i < 60; i += each){
            String cron = '0 ' + i + ' * * * ?';
            System.schedule('SendEmailBatch ' + cron, cron, new SendEmailBatch());
        }
    }
    
    global static void cancelThisSchedule() {
        CronTrigger[] asyncApexJob = [
            SELECT Id, CronJobDetail.name
            FROM CronTrigger
            WHERE CronJobDetail.name LIKE '%SendEmailBatch%'
        ];
        for (CronTrigger job : asyncApexJob){
            System.abortJob(job.Id);
            
        }
    }
    
    public Iterable<SObject> start(Database.BatchableContext param1) { 
        
         List<Contact> lstcon = [select id,EnviarEmailRecuperacao__c,EMAIL FROM Contact WHERE EnviarEmailRecuperacao__c =true];
        System.debug(LoggingLevel.INFO, '@@@SendEmailBatch sObjectList' + lstcon);
        return (List<Contact>)lstcon;
    }
    
    public void execute(Database.BatchableContext param1, List<Contact> contactList) {
        List<Id> lstids= new List<Id>();
        for(Contact c:contactList)
        {
            c.EnviarEmailRecuperacao__c = FALSE;
            lstids.add(c.id);
        }
        update contactList;
        
        EmailTemplate et=[Select id from EmailTemplate where name = 'ForgotPassword' limit 1];
        
        Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
        mail.setTargetObjectIds(lstids);
        mail.setSaveAsActivity(false);
        mail.setSenderDisplayName('Solicitação de recuperação de senha');
        mail.setTemplateId(et.id);
        Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
    }
    
    public void finish(Database.BatchableContext param1) {
    }    
    public class BatchContext implements Database.BatchableContext {
        
        public Id getChildJobId() {
            return null;
        }
        
        public Id getJobId() {
            return null;
        }
    }
}