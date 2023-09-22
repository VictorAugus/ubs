/**
 * Created by guilhermereis on 17/12/2020.
 */

public with sharing class DW_QueryFactory {
    private List<String> queryFieldList;
    private List<DW_Relationship> relationshipList = new List<DW_Relationship>();
    private List<DW_ParentRelationship> parentRelationshipList = new List<DW_ParentRelationship>();
    Integer limitedTo = 50000;
    DW_QueryConditionComposition queryComposition  = new DW_QueryConditionComposition();

    private String sobj;

    public DW_QueryFactory(String sobj, List<String> fieldList){
        this.queryFieldList = fieldList;
        this.sobj = sobj;
    }

    public DW_QueryFactory setGroupedCondition(DW_QueryConditionComposition queryConditionComposition){
        this.queryComposition.children.add(queryConditionComposition);
        return this;
    }

    public DW_QueryFactory setCondition(DW_QueryCondition queryCondition){
        queryCondition.operator = DW_OperatorOptions.AND_OPERATOR;
        this.queryComposition.queryConditionList.add(queryCondition);
        return this;
    }

    public DW_QueryFactory setOrCondition(DW_QueryCondition queryCondition){
        queryCondition.operator = DW_OperatorOptions.OR_OPERATOR;
        this.queryComposition.queryConditionList.add(queryCondition);
        return this;
    }

    public List<SObject> run(){
        String fields = String.join(this.queryFieldList, ',');
        String conditionStr = '';
        Integer counter = 0;
        for(DW_QueryCondition queryCondition : queryComposition.queryConditionList){
            if (counter == 0) {
                conditionStr = ' WHERE ';
            }
            conditionStr += queryCondition.render(counter == 0);
            counter++;
        }
        for(DW_QueryConditionComposition queryConditionComposition : queryComposition.children){
            Integer counter2 = 0;
            conditionStr += (conditionStr == ''
                ? ' WHERE '
                :  queryConditionComposition.childrenOperator == DW_OperatorOptions.AND_OPERATOR ? ' AND ' : ' OR ');
            conditionStr += '(';
            for (DW_QueryCondition queryCondition : queryConditionComposition.queryConditionList){
                conditionStr += queryCondition.renderChild(queryCondition.operator, counter2 == 0);
                counter2++;
            }
            conditionStr += ')';
        }
        String relationshipQuery = '';
        for (DW_Relationship relationship : relationshipList){
            relationshipQuery += relationship.render();
        }

        List<String> parentRelationshipFieldList = new List<String>();
        for (DW_ParentRelationship parentRelationship : this.parentRelationshipList){
            parentRelationshipFieldList.add(parentRelationship.render());
        }
        String parentRelationshipFieldStr = String.join(parentRelationshipFieldList, '');


        String query = 'SELECT ' + fields + parentRelationshipFieldStr + relationshipQuery + ' FROM ' + this.sobj +conditionStr + ' LIMIT ' +this.limitedTo;
        System.debug(LoggingLevel.INFO, '@@@@DW_QueryFactory -> query on ' + this.sobj + ': ' + query);
        List<SObject> sObjectList = Database.query(query);
        return sObjectList;
    }
    public static DW_QueryFactory get(String sobj){
        return new DW_QueryFactory(sobj, DW_FieldCollector.collect(sobj));
    }
    public DW_QueryFactory with(String relationshipName, String sobj){
        this.relationshipList.add(DW_Relationship.newInstance(relationshipName, sobj));
        return this;
    }
    public DW_QueryFactory with(String relationshipName){
        String objName = '';
        if (relationshipName.endsWith('s')) {
            objName = relationshipName.removeEnd('s');
        }
        if (relationshipName.endsWith('__r')) {
            objName = relationshipName.replaceAll('__r', '__c');
        }
        this.relationshipList.add(DW_Relationship.newInstance(relationshipName, objName));
        return this;
    }
    public DW_QueryFactory withParent(String relationshipName, String sobj){
        this.parentRelationshipList.add(DW_ParentRelationship.newInstance(relationshipName, sobj));
        return this;
    }
    public DW_QueryFactory withParent(String relationshipName){
        String objName = relationshipName;
        if (relationshipName.endsWith('s')) {
            objName = relationshipName.removeEnd('s');
        }else if (relationshipName.endsWith('__r')) {
            objName = relationshipName.replaceAll('__r', '__c');
        }

        this.parentRelationshipList.add(DW_ParentRelationship.newInstance(relationshipName, objName));
        return this;
    }

    public DW_QueryFactory limitedTo(Integer limitedTo){
        this.limitedTo = limitedTo;
        return this;
    }

    public static void test(){
//        DW_QueryFactory.get('Opportunity')
//            .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho'))
//            .run();
//
//        DW_QueryFactory.get('Opportunity')
//            .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho'))
//            .setOrCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Perdido'))
//            .run();
//
//        DW_QueryFactory.get('Opportunity')
//                .setCondition(DW_QueryCondition.newInstance('StageName', new List<String>{'Fechado/Ganho', 'Fechado/Perdido'}))
//                .run();
//
//        DW_QueryFactory.get('Opportunity')
//                .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho'))
//                .setCondition(DW_QueryCondition.newInstance('Amount', '>', 50000))
//                .run();
//
//
//        DW_QueryFactory.get('Opportunity')
//                .setCondition(DW_QueryCondition.newInstance('CloseDate', '>', System.today().addDays(-300)))
//                .run();
//
//        DW_QueryFactory.get('Opportunity')
//        .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho'))
//        .setGroupedCondition(DW_QueryConditionComposition.setConditionList(
//                new List<DW_QueryCondition>{
//                    DW_QueryCondition.newInstance('Amount', '<', 5000),
//                    DW_QueryCondition.newInstance('Amount', '>', 50000, DW_OperatorOptions.OR_OPERATOR)
//                }, null
//        ))
//        .setGroupedCondition(DW_QueryConditionComposition.setConditionList(
//                new List<DW_QueryCondition>{
//                        DW_QueryCondition.newInstance('Amount', '>', 20000),
//                        DW_QueryCondition.newInstance('Amount', '<', 30000, DW_OperatorOptions.AND_OPERATOR)
//                }, null
//        )).run();
//
//
//        DW_QueryFactory.get('Opportunity')
//            .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho'))
//            .with('OpportunityLineItems', 'OpportunityLineItem')
//            .limitedTo(10)
//            .run();


//        System.debug(JSON.serialize(
//            DW_QueryFactory.get('Opportunity').setCondition(DW_QueryCondition.newInstance('Id', '=', '0062F00000BMC9GQAX'))
//                .with('OpportunityLineItems', 'OpportunityLineItem')
//                .limitedTo(1)
//                .run()
//        ));

//        System.debug(LoggingLevel.DEBUG, '@@System.Limits.getQueries() : ' + System.Limits.getQueries());
    }
}