global class ControllerPDF {
    global String stringName {get; set;}
    global Account account {get; set;}
    global List<Account> accounts {get; set;}
    global List<Contact> contacts {get; set;}
    public List<Account> accountsByAmbiente { get; set; }
        public List<AggregateResult> groupedResponses { get; set; }

    global ControllerPDF(){
        this.accounts = [SELECT ID,Name,Phone,Numero__c,BillingPostalCode,BillingCity,BillingStreet,BillingState,QuantidadeResposta__c,QuantidadeRespostasFinalizadas__c,QuantidadeRespostasNaofinalizadas__c,(select id,Name,Cobertura__c,Comprimento__c,Grupo__c,LarguraDimensao__c,PeDireito__c,QuantidadeResposta__c,QuantidadeRespostasFinalizadas__c,Tipo__c,Unidade__c,AreaEsquadrias__c,AreaAmbiente__c from Ambientes__r),(select id,Contact.Name,Contact.Email,Contact.Title,Contact.UltimoAcesso__c from AccountContactRelations) FROM ACCOUNT WHERE CriadoPeloContato__c != null];
        this.accountsByAmbiente = [SELECT ID, Name,
                                    (SELECT Id,  QuantidadeRespostasFinalizadas__c 
                                     FROM Ambientes__r)
                                    FROM Account
                                    WHERE CriadoPeloContato__c != null];
       
        
    }
}