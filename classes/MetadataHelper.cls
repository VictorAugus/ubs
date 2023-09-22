public without sharing class MetadataHelper {
    Map<String, String> stringMap = new Map<String, String>();
    private static final MetadataHelper instance = new MetadataHelper();
    public IntegracaoERP__mdt integracaoERP;


    public static MetadataHelper getInstance(){
       
        if (instance.integracaoERP == null) {
            instance.integracaoERP = (IntegracaoERP__mdt)DW_QueryFactory.get('IntegracaoERP__mdt')
                .setCondition(DW_QueryCondition.newInstance('Ativo__c', '=',true))
                .run()
                .get(0);
        }
        return instance;
    }
}