trigger ContactTrigger on Contact (before insert,before update) {
    
    for(Contact c : Trigger.new){
        if( c.EnviarEmailRecuperacao__c && c.Email != ''){  
           
            
        }
    }
    
}