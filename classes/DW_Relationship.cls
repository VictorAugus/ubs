/**
 * Created by guilhermereis on 05/01/21.
 */

public with sharing class DW_Relationship {
    private String queryFieldsStr;
    private String relationshipName;
    private String objectName;

    public static DW_Relationship newInstance(String relationshipName, String objectName){
        DW_Relationship relationship = new DW_Relationship();
        relationship.relationshipName = relationshipName;
        relationship.objectName = relationshipName;
        relationship.queryFieldsStr = DW_FieldCollector.collectStr(objectName);
        return relationship;
    }
    public String render(){
        return ',(SELECT ' + this.queryFieldsStr + ' FROM ' + this.relationshipName + ')';
    }
}