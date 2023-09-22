public without sharing class ControllerAuthLwc {
    
    @AuraEnabled
    public static String accountDeleteRecMethod(String recordId,String ctRelationRecordRec){
    try {
        AccountContactRelation ctRelation = [SELECT ID,AccountId FROM AccountContactRelation WHERE Id =:ctRelationRecordRec ];
        Contact contact = [SELECT ID,AccountId FROM Contact WHERE Id = :recordId];
        if(contact.AccountId == ctRelation.AccountId){
            contact.AccountId = null;
            update contact;
            delete [SELECT ID FROM ACCOUNT WHERE Id =: ctRelation.AccountId];
        }else{
            delete ctRelation;
        }
        Set<Id> setId = new Set<Id>();
        List<AccountContactRelation> unidades = [
            SELECT Id, AccountId,Account.Name, Account.Phone,IsActive,Roles
            FROM AccountContactRelation
            WHERE ContactId = :recordId      
        ];
        for(AccountContactRelation act : unidades){
            setId.add(act.AccountId);
        }
        List<Account> ambientesByAccount = [
            SELECT Id,Name,(SELECT Id,Cobertura__c,Name,Comprimento__c,Grupo__c,LarguraDimensao__c,PeDireito__c,Tipo__c,Unidade__c,AreaEsquadrias__c,AreaAmbiente__c
            FROM Ambientes__r) FROM ACCOUNT 
            WHERE Id IN :setId 
            
        ];
        //
        return DW_ResponseHTTP.success(new Map<String, Object>{
            'response' => unidades,
            'ambientes' => ambientesByAccount

        });
    } catch (Exception e) {
        return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
    }
    
    }
    @AuraEnabled
    public static String getQuestionsByAmbienteUpdateResposta(String respostaId,String valorResultado){
        try {
            Resposta__c resposta = [SELECT ID,Resposta__c,Ambiente__c from Resposta__c WHERE iD =:respostaId];
            resposta.Resposta__c = valorResultado;
            update resposta;

            List<Resposta__c> respostaAmbienteList = [Select id,Observacao__c,RespostaRealizada__c,Ambiente__c,Unidade__c,Unidade__r.Name,Ambiente__r.Name,Pergunta__c,Pergunta__r.Categoria__c,Pergunta__r.TextoAjuda__c,Pergunta__r.Pergunta__C,Pergunta__r.ItemPrincipal__c,Pergunta__r.Subcategoria__c,Pergunta__r.Secao__c,Resposta__C FROM Resposta__c
            
        WHERE  (Ambiente__c = : resposta.Ambiente__c ) ];
            Ambiente__c ambiente =[select id,QuantidadeResposta__c,QuantidadeRespostasFinalizadas__c from Ambiente__c where Id =  :resposta.Ambiente__c ];
            return DW_ResponseHTTP.success(new Map<String, Object>{
                'respostaAmbienteList'=> respostaAmbienteList,
                'qtRespostas'=>ambiente
            });
        } catch (Exception e) {
            return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
        }
    }
    @AuraEnabled
    public static String getQuestionsByUnidadeUpdateResposta(String respostaId,String valorResultado){
        try {
            Resposta__c resposta = [SELECT ID,Resposta__c,Unidade__c,Ambiente__c,Ambiente__r.Ubs__c from Resposta__c WHERE iD =:respostaId];
            resposta.Resposta__c = valorResultado;
            update resposta;

            Set<String> setIdAmbientes = new Set<String>();
            String IdUnidade;
            List<Account> unidadeList = new List<Account>();
            if(resposta.Unidade__c != null){
                IdUnidade = resposta.Unidade__c;
            } else if(resposta.Ambiente__c != null){
                IdUnidade= resposta.Ambiente__r.Ubs__c;

            }
            List<Ambiente__c> ambienteList = [SELECT ID FROM Ambiente__c WHERE UBS__c =:IdUnidade];
            for(Ambiente__c ambiente :ambienteList ){
                setIdAmbientes.add(ambiente.Id);
            }

            
            List<Resposta__c> respostaAmbienteList = [Select id,Observacao__c,RespostaRealizada__c,Ambiente__c,Pergunta__r.ItemPrincipalPai__c,Unidade__c,Unidade__r.Name,Ambiente__r.Name,Pergunta__c,Pergunta__r.Categoria__c,Pergunta__r.TextoAjuda__c,Pergunta__r.Pergunta__C,Pergunta__r.ItemPrincipal__c,Pergunta__r.Subcategoria__c,Pergunta__r.Secao__c,Resposta__C FROM Resposta__c
        WHERE  (Unidade__c = : IdUnidade ) OR (Ambiente__c IN :setIdAmbientes)  ];
            return DW_ResponseHTTP.success(new Map<String, Object>{
                'respostaAmbienteList'=> respostaAmbienteList
            });
        } catch (Exception e) {
            return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
        }
    }
    @AuraEnabled
    public static String getQuestionsByUnidadeUpdateObs(String respostaId,String valorResultado){
        try {
            Resposta__c resposta = [SELECT ID,Resposta__c,Observacao__c,Unidade__c,Ambiente__c,Ambiente__r.Ubs__c from Resposta__c WHERE iD =:respostaId];
            resposta.Observacao__c = valorResultado;
            update resposta;

            Set<String> setIdAmbientes = new Set<String>();
            String IdUnidade;
            List<Account> unidadeList = new List<Account>();
            if(resposta.Unidade__c != null){
                IdUnidade = resposta.Unidade__c;
            } else if(resposta.Ambiente__c != null){
                IdUnidade= resposta.Ambiente__r.Ubs__c;

            }
            List<Ambiente__c> ambienteList = [SELECT ID FROM Ambiente__c WHERE UBS__c =:IdUnidade];
            for(Ambiente__c ambiente :ambienteList ){
                setIdAmbientes.add(ambiente.Id);
            }

            
            List<Resposta__c> respostaAmbienteList = [Select id,Observacao__c,RespostaRealizada__c,Ambiente__c,Pergunta__r.ItemPrincipalPai__c,Unidade__c,Unidade__r.Name,Ambiente__r.Name,Pergunta__c,Pergunta__r.Categoria__c,Pergunta__r.TextoAjuda__c,Pergunta__r.Pergunta__C,Pergunta__r.ItemPrincipal__c,Pergunta__r.Subcategoria__c,Pergunta__r.Secao__c,Resposta__C FROM Resposta__c
        WHERE  (Unidade__c = : IdUnidade ) OR (Ambiente__c IN :setIdAmbientes)  ];
            return DW_ResponseHTTP.success(new Map<String, Object>{
                'respostaAmbienteList'=> respostaAmbienteList
            });
        } catch (Exception e) {
            return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
        }
    }
    @AuraEnabled
    public static String getQuestionsByAmbiente(String recordId,String ambienteId){
        try {
            List<Resposta__c> respostaAmbienteList = [Select id,RespostaRealizada__c,Ambiente__c,Unidade__c,Unidade__r.Name,Ambiente__r.Name,Pergunta__c,Pergunta__r.Categoria__c,Pergunta__r.TextoAjuda__c,Pergunta__r.ItemPrincipalPai__c,Pergunta__r.Pergunta__C,Pergunta__r.ItemPrincipal__c,Pergunta__r.Subcategoria__c,Pergunta__r.Secao__c,Resposta__C FROM Resposta__c
        WHERE  (Ambiente__c = : ambienteId ) ];
        Ambiente__c ambiente =[select id,QuantidadeResposta__c,QuantidadeRespostasFinalizadas__c from Ambiente__c where Id =  :ambienteId ];
            return DW_ResponseHTTP.success(new Map<String, Object>{
                'respostaAmbienteList'=> respostaAmbienteList,
                'qtRespostas'=>ambiente
            });
        } catch (Exception e) {
            return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
        }
    }
    @AuraEnabled
    public static String getQuestionsByUnidade(String recordId,String unidadeId){
        try {
            Set<String> setIdAmbientes = new Set<String>();

            List<Ambiente__c> ambienteList = [SELECT ID FROM Ambiente__c WHERE UBS__c =:unidadeId];
            for(Ambiente__c ambiente :ambienteList ){
                setIdAmbientes.add(ambiente.Id);
            }
            List<Resposta__c> respostaAmbienteList = [Select id,Observacao__c,RespostaRealizada__c,Ambiente__c,Pergunta__r.ItemPrincipalPai__c,Unidade__c,Unidade__r.Name,Ambiente__r.Name,Pergunta__c,Pergunta__r.Categoria__c,Pergunta__r.TextoAjuda__c,Pergunta__r.Pergunta__C,Pergunta__r.ItemPrincipal__c,Pergunta__r.Subcategoria__c,Pergunta__r.Secao__c,Resposta__C FROM Resposta__c
        WHERE  (Unidade__c = : unidadeId ) OR (Ambiente__c IN :setIdAmbientes)  ];
            return DW_ResponseHTTP.success(new Map<String, Object>{
                'respostaAmbienteList'=> respostaAmbienteList
            });
        } catch (Exception e) {
            return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
        }
    }

    

    @AuraEnabled
    public static String getAnswersVinculoRecMethod(String recordId){
    try {
        
        Set<Id> setId = new Set<Id>();
        List<AccountContactRelation> unidades = [
            SELECT Id, AccountId,Account.Name, Account.Phone,IsActive,Roles
            FROM AccountContactRelation
            WHERE ContactId = :recordId      
        ];
        for(AccountContactRelation act : unidades){
            setId.add(act.AccountId);
        }
        List<Account> ambientesByAccount = [
            SELECT Id,Name,(SELECT Id,Cobertura__c,Name,Comprimento__c,Grupo__c,LarguraDimensao__c,PeDireito__c,Tipo__c,Unidade__c,AreaEsquadrias__c,AreaAmbiente__c
            FROM Ambientes__r) FROM ACCOUNT 
            WHERE Id IN :setId 
            
        ];
        SET<Id> setIdAmbiente = new Set<Id>();

        List<Ambiente__c> ambienteList = [SELECT ID FROM Ambiente__c WHERE UBS__c IN :setId];

        FOR(Ambiente__c ambiente : ambienteList ){
            setIdAmbiente.add(ambiente.Id);
        }
        List<Resposta__c> respostaAmbienteList = [Select id,Observacao__c,RespostaRealizada__c,Ambiente__c,Unidade__c,Unidade__r.Name,Ambiente__r.Name,Pergunta__c,Pergunta__r.ItemPrincipalPai__c,Pergunta__r.Categoria__c,Pergunta__r.TextoAjuda__c,Pergunta__r.Pergunta__C,Pergunta__r.ItemPrincipal__c,Pergunta__r.Subcategoria__c,Pergunta__r.Secao__c,Resposta__C FROM Resposta__c
        WHERE  (Ambiente__c IN : setIdAmbiente ) ];

        //
        return DW_ResponseHTTP.success(new Map<String, Object>{
            'ambientes' => ambientesByAccount,
            'respostaAmbienteList'=> respostaAmbienteList
        });
    } catch (Exception e) {
        return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
    }
    
    }

    @AuraEnabled
    public static String accountVinculoRecMethod(String recordId,String accRecordRec){
    try {
        
        Contact contact = [SELECT ID,AccountId FROM Contact WHERE Id = :recordId];
        if(contact.AccountId == null){
            contact.AccountId =accRecordRec;
            update contact;
        }else{
            AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = accRecordRec;
        acr.ContactId = contact.Id;
        insert acr;
        }
        
        Set<Id> setId = new Set<Id>();
        List<AccountContactRelation> unidades = [
            SELECT Id, AccountId,Account.Name, Account.Phone,IsActive,Roles
            FROM AccountContactRelation
            WHERE ContactId = :recordId      
        ];
        for(AccountContactRelation act : unidades){
            setId.add(act.AccountId);
        }
        List<Account> ambientesByAccount = [
            SELECT Id,Name,(SELECT Id,Cobertura__c,Name,Comprimento__c,Grupo__c,LarguraDimensao__c,PeDireito__c,Tipo__c,Unidade__c,AreaEsquadrias__c,AreaAmbiente__c
            FROM Ambientes__r) FROM ACCOUNT 
            WHERE Id IN :setId 
            
        ];
        //
        return DW_ResponseHTTP.success(new Map<String, Object>{
            'response' => unidades,
            'ambientes' => ambientesByAccount
        });
    } catch (Exception e) {
        return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
    }
    
    }

    @AuraEnabled
    public static String createAmbienteRecMethod(String recordId,String accRecId,Ambiente__c ambienteRecord){
    try {
        insert ambienteRecord;
        
        Set<Id> setId = new Set<Id>();
        List<AccountContactRelation> unidades = [
            SELECT Id, AccountId,Account.Name, Account.Phone,IsActive,Roles
            FROM AccountContactRelation
            WHERE ContactId = :recordId      
        ];
        for(AccountContactRelation act : unidades){
            setId.add(act.AccountId);
        }
        List<Account> ambientesByAccount = [
            SELECT Id,Name,(SELECT Id,Cobertura__c,Name,Comprimento__c,Grupo__c,LarguraDimensao__c,PeDireito__c,Tipo__c,Unidade__c,AreaEsquadrias__c,AreaAmbiente__c
            FROM Ambientes__r) FROM ACCOUNT 
            WHERE Id IN :setId 
            
        ];
   
        return JSON.serialize(DW_ResponseHTTP.successObj(new Map<String, Object>{'ambientes' => ambientesByAccount}));
    } catch (Exception e) {
        return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
    }
    
    }

    @AuraEnabled
    public static String accountRecMethod(String recordId,Account accRec){
    try {
        accRec.CodigoExterno__c = accRec.Name;
        insert accRec;
        Contact contact = [SELECT ID,AccountId FROM Contact WHERE Id = :recordId];
        contact.AccountId =accRec.Id;
        update contact;

        List<AccountContactRelation> unidades = [
                SELECT Id, Account.Name, Account.Phone
                FROM AccountContactRelation
                WHERE ContactId = :recordId      
            ];
        //
        return DW_ResponseHTTP.success(new Map<String, Object>{
            'response' => unidades,
            'account' => accRec
        });
    } catch (Exception e) {
        return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
    }
    
    }

    @AuraEnabled(cacheable=true)
    public static String getUnidadesByContact(String recordId){
        try {
            
            List<AccountContactRelation> unidades = [
                SELECT Id, Account.Name, Account.Phone,IsActive,Roles
                FROM AccountContactRelation
                WHERE ContactId = :recordId      
            ];

            
            
            
            return JSON.serialize(DW_ResponseHTTP.successObj(new Map<String, Object>{
                'response' => unidades
            }));
        } catch (Exception e) {
            return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
        }
    }
    @AuraEnabled(cacheable=true)
    public static String getAmbientesByAccount(String accountId){
        try {
            
            List<Account> ambientesByAccount = [
                SELECT Id,Name,(SELECT Id,Cobertura__c,Name,Comprimento__c,Grupo__c,LarguraDimensao__c,PeDireito__c,Tipo__c,Unidade__c,AreaEsquadrias__c,AreaAmbiente__c
                FROM Ambientes__r) FROM ACCOUNT
                WHERE Id = :accountId 
            ];
            
            return JSON.serialize(DW_ResponseHTTP.successObj(new Map<String, Object>{'response' => ambientesByAccount}));
        } catch (Exception e) {
            return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
        }
    }
    @AuraEnabled(cacheable=true)
    public static String getAmbientesByContact(String recordId){
        try {

            List<String> optionsAmbientes = new List<String>();
            Schema.DescribeFieldResult fieldResult = Ambiente__c.Tipo__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                optionsAmbientes.add(f.getValue());
            }  

            List<String> optionsCobertura = new List<String>();
            Schema.DescribeFieldResult fieldResultCobertura = Ambiente__c.Cobertura__c.getDescribe();
            List<Schema.PicklistEntry> pleCobertura = fieldResultCobertura.getPicklistValues();
            for( Schema.PicklistEntry f : pleCobertura)
            {
                optionsCobertura.add(f.getValue());
            }

            Set<Id> setId = new Set<Id>();
            List<AccountContactRelation> unidades = [
                SELECT Id, AccountId,Account.Name, Account.Phone,IsActive,Roles
                FROM AccountContactRelation
                WHERE ContactId = :recordId      
            ];
            for(AccountContactRelation act : unidades){
                setId.add(act.AccountId);
            }
            List<Account> ambientesByAccount = [
                SELECT Id,Name,(SELECT Id,Cobertura__c,Name,Comprimento__c,Grupo__c,LarguraDimensao__c,PeDireito__c,Tipo__c,Unidade__c,AreaEsquadrias__c,AreaAmbiente__c
                FROM Ambientes__r) FROM ACCOUNT 
                WHERE Id IN :setId 
                
            ];
            
            return JSON.serialize(DW_ResponseHTTP.successObj(new Map<String, Object>{'ambientes' => ambientesByAccount,'optionsAmbientes' => optionsAmbientes,'optionsCobertura'=> optionsCobertura}));
        } catch (Exception e) {
            return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
        }
    }
    
 @AuraEnabled
    public static String accountDeleteAmbiente(String ambienteId,String recordId){
    try {
        
        
        delete [SELECT ID,Ubs__c FROM Ambiente__c WHERE Id = :ambienteId];

        Set<Id> setId = new Set<Id>();
            List<AccountContactRelation> unidades = [
                SELECT Id, AccountId,Account.Name, Account.Phone,IsActive,Roles
                FROM AccountContactRelation
                WHERE ContactId = :recordId      
            ];
            for(AccountContactRelation act : unidades){
                setId.add(act.AccountId);
            }
            List<Account> ambientesByAccount = [
                SELECT Id,Name,(SELECT Id,Cobertura__c,Name,Comprimento__c,Grupo__c,LarguraDimensao__c,PeDireito__c,Tipo__c,Unidade__c,AreaEsquadrias__c,AreaAmbiente__c
                FROM Ambientes__r) FROM ACCOUNT 
                WHERE Id IN :setId 
                
            ];
       
            return JSON.serialize(DW_ResponseHTTP.successObj(new Map<String, Object>{'ambientes' => ambientesByAccount}));
       
    } catch (Exception e) {
        return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));
    }
    
    }
    @AuraEnabled
    public static string sendEmailToController(String toSend){
        try{
            Contact[] getContact =[SELECT ID,EMAIL,senha__c,EnviarEmailRecuperacao__c FROM CONTACT WHERE EMAIL = :toSend];
            if(getContact.size()==0){
                return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{'não foi encontrado nenhum usuario com esse email', 'não foi encontrado nenhum usuario com esse email'}));
 
            }
            getContact[0].EnviarEmailRecuperacao__c = true;
            update getContact;

            return JSON.serialize(DW_ResponseHTTP.successObj(new Map<String, Object>{'enviado' => 'enviado'}));
        }catch(Exception e){
            return JSON.serialize(DW_ResponseHTTP.errorObj(new List<String>{e.getMessage(), e.getStackTraceString()}));

        }
    }
}