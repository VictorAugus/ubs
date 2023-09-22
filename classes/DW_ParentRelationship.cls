/**
 * Created by guilhermereis on 01/02/21.
 */

public with sharing class DW_ParentRelationship {
    private List<String> queryFieldsList;
    private String relationshipName;
    private String objectName;

    public static DW_ParentRelationship newInstance(String relationshipName, String objectName){
        DW_ParentRelationship relationship = new DW_ParentRelationship();
        relationship.relationshipName = relationshipName;
        relationship.objectName = relationshipName;
        relationship.queryFieldsList = DW_FieldCollector.collect(objectName);
        return relationship;
    }
    public String render(){
        List<String> relationshipAndField = new List<String>();
        for (String field : this.queryFieldsList){
            relationshipAndField.add(this.relationshipName + '.' + field);
        }
        return ',' + String.join(relationshipAndField, ',');
    }
}