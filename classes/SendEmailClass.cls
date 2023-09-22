public without sharing class SendEmailClass {
    @future (callout=true)
    public static void SendEmail()
    {
        List<Contact> lstcon = [select id,EnviarEmailRecuperacao__c,EMAIL FROM Contact WHERE EnviarEmailRecuperacao__c =true];
        update lstcon;
        List<Id> lstids= new List<Id>();
        for(Contact c:lstcon)
        {
            c.EnviarEmailRecuperacao__c = FALSE;
            lstids.add(c.id);
        }
        update lstcon;
        
        EmailTemplate et=[Select id from EmailTemplate where name = 'ForgotPassword' limit 1];
        
        Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
        mail.setTargetObjectIds(lstIds);
        mail.setSaveAsActivity(false);
        mail.setSenderDisplayName('Solicitação de recuperação de senha');
        mail.setTemplateId(et.id);
        Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
    }
    
}