/**
 * Created by guilhermereis on 04/01/21.
 */

public with sharing class DW_QueryConditionComposition {
    public List<DW_QueryCondition> queryConditionList = new List<DW_QueryCondition>();
    public List<DW_QueryConditionComposition> children = new List<DW_QueryConditionComposition>();
    public DW_OperatorOptions childrenOperator = DW_OperatorOptions.AND_OPERATOR;

    public static DW_QueryConditionComposition setOrConditionList(List<DW_QueryCondition> queryConditionList, List<DW_QueryConditionComposition> children){
        DW_QueryConditionComposition queryConditionComposition = DW_QueryConditionComposition.setConditionList(queryConditionList, children);
        queryConditionComposition.childrenOperator = DW_OperatorOptions.OR_OPERATOR;
        return queryConditionComposition;
    }

    public static DW_QueryConditionComposition setConditionList(List<DW_QueryCondition> queryConditionList, List<DW_QueryConditionComposition> children){
        DW_QueryConditionComposition queryConditionComposition = new DW_QueryConditionComposition();
        queryConditionComposition.queryConditionList = queryConditionList;
        if (children != null) {
            queryConditionComposition.children = children;
        }
        return queryConditionComposition;
    }

}