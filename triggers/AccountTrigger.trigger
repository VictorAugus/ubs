trigger AccountTrigger on Account (before insert,after delete ) {
 List<Resposta__c> respostasToDelete = new List<Resposta__c>();
    if(Trigger.isDelete){
       for (Account deletedAccount : Trigger.old) {
        // Consulta as respostas relacionadas à conta excluída com unidade__c e ambiente__c nulos
        List<Resposta__c> matchingRespostas = [SELECT Id FROM Resposta__c WHERE Unidade__c = NULL AND Ambiente__c = NULL ];
        
        // Adiciona as respostas à lista de respostas a serem excluídas
        respostasToDelete.addAll(matchingRespostas);
    }

    // Exclui as respostas encontradas
    if (!respostasToDelete.isEmpty()) {
        delete respostasToDelete;
    } 
    }
    
}