/**
 * Created by guilhermereis on 04/01/21.
 */

    global with sharing class DW_QueryCondition {
    
        DW_ConditionOptions conditionType;
        String field;
        String criteria;
    
        String valueToFilterString;
        List<String> valueToFilterStringList;
        Decimal valueToFilterDecimal;
        Date valueToFilterDate;
        Datetime valueToFilterDatetime;
        Boolean valueToFilterBoolean;
    
    
        public Boolean hasPreviousCondition = false;//TO USE AND OR OR INSTEAD OF WHERE
        public DW_OperatorOptions operator = null;
    
        public static DW_QueryCondition newInstance(String field, String criteria, String valueToFilter){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, criteria, valueToFilter);
            queryCondition.operator = DW_OperatorOptions.AND_OPERATOR;
            return queryCondition;
        }
    
        public static DW_QueryCondition newInstance(String field, String criteria, Boolean valueToFilter){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, criteria, valueToFilter);
            queryCondition.operator = DW_OperatorOptions.AND_OPERATOR;
            return queryCondition;
        }
    
        public static DW_QueryCondition newInstance(String field, List<String> valueToFilter){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, valueToFilter);
            queryCondition.operator = DW_OperatorOptions.AND_OPERATOR;
            return queryCondition;
        }
    
        public static DW_QueryCondition newInstance(String field, Set<String> valueToFilter){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, new List<String>(valueToFilter));
            queryCondition.operator = DW_OperatorOptions.AND_OPERATOR;
            return queryCondition;
        }
    
        public static DW_QueryCondition newInstance(String field, Set<Id> valueToFilter){
            List<String> listAux = new List<String>();
            for (Id key : valueToFilter){
                listAux.add(key);
            }
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, listAux);
            queryCondition.operator = DW_OperatorOptions.AND_OPERATOR;
            return queryCondition;
        }
    
        public static DW_QueryCondition newInstance(String field, List<SObject> valueToFilter){
            List<String> listAux = new List<String>();
            for (SObject sobj : valueToFilter){
                listAux.add(sobj.Id);
            }
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, listAux);
            queryCondition.operator = DW_OperatorOptions.AND_OPERATOR;
            return queryCondition;
        }
    
        public static DW_QueryCondition newInstance(String field, String criteria, Decimal valueToFilter){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, criteria, valueToFilter);
            queryCondition.operator = DW_OperatorOptions.AND_OPERATOR;
            return queryCondition;
        }
        public static DW_QueryCondition newInstance(String field, String criteria, Date valueToFilter){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, criteria, valueToFilter);
            queryCondition.operator = DW_OperatorOptions.AND_OPERATOR;
            return queryCondition;
        }
        public static DW_QueryCondition newInstance(String field, String criteria, Datetime valueToFilter){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, criteria, valueToFilter);
            queryCondition.operator = DW_OperatorOptions.AND_OPERATOR;
            return queryCondition;
        }
    
    
    
    
        public static DW_QueryCondition newInstance(String field, String criteria, String valueToFilter, DW_OperatorOptions operator){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, criteria, valueToFilter);
            queryCondition.operator = operator;
            return queryCondition;
        }
        public static DW_QueryCondition newInstance(String field, String criteria, Boolean valueToFilter, DW_OperatorOptions operator){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, criteria, valueToFilter);
            queryCondition.operator = operator;
            return queryCondition;
        }
    
        public static DW_QueryCondition newInstance(String field, List<String> valueToFilter, DW_OperatorOptions operator){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, valueToFilter);
            queryCondition.operator = operator;
            return queryCondition;
        }
    
        public static DW_QueryCondition newInstance(String field, Set<Id> valueToFilter, DW_OperatorOptions operator){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, valueToFilter);
            queryCondition.operator = operator;
            return queryCondition;
        }
    
        public static DW_QueryCondition newInstance(String field, Set<String> valueToFilter, DW_OperatorOptions operator){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, valueToFilter);
            queryCondition.operator = operator;
            return queryCondition;
        }
    
        public static DW_QueryCondition newInstance(String field, List<SObject> valueToFilter, DW_OperatorOptions operator){
            List<String> listAux = new List<String>();
            for (SObject sobj : valueToFilter){
                listAux.add(sobj.Id);
            }
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, listAux);
            queryCondition.operator = operator;
            return queryCondition;
        }
    
        public static DW_QueryCondition newInstance(String field, String criteria, Decimal valueToFilter, DW_OperatorOptions operator){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, criteria, valueToFilter);
            queryCondition.operator = operator;
            return queryCondition;
        }
        public static DW_QueryCondition newInstance(String field, String criteria, Date valueToFilter, DW_OperatorOptions operator){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, criteria, valueToFilter);
            queryCondition.operator = operator;
            return queryCondition;
        }
        public static DW_QueryCondition newInstance(String field, String criteria, Datetime valueToFilter, DW_OperatorOptions operator){
            DW_QueryCondition queryCondition = new DW_QueryCondition(field, criteria, valueToFilter);
            queryCondition.operator = operator;
            return queryCondition;
        }
    
        public DW_QueryCondition(String field, String criteria, String valueToFilter){
            this.conditionType = DW_ConditionOptions.STR;
            this.field = field;
            this.criteria = criteria;
            this.valueToFilterString = valueToFilter;
        }
    
        public DW_QueryCondition(String field, String criteria, Boolean valueToFilter){
            this.conditionType = DW_ConditionOptions.BOOL;
            this.field = field;
            this.criteria = criteria;
            this.valueToFilterBoolean = valueToFilter;
        }
    
        public DW_QueryCondition(String field, List<String> valueToFilter){
            this.conditionType = DW_ConditionOptions.STR_IN;
            this.field = field;
            this.criteria = 'IN';
            this.valueToFilterStringList = valueToFilter;
        }
        public DW_QueryCondition(String field, Set<String> valueToFilter){
            List<String> listAux = new List<String>();
            for (String key : valueToFilter) listAux.add(key);
            this.conditionType = DW_ConditionOptions.STR_IN;
            this.field = field;
            this.criteria = 'IN';
            this.valueToFilterStringList = listAux;
        }
        public DW_QueryCondition(String field, Set<Id> valueToFilter){
            List<String> listAux = new List<String>();
            for (Id key : valueToFilter) listAux.add(key);
            this.conditionType = DW_ConditionOptions.STR_IN;
            this.field = field;
            this.criteria = 'IN';
            this.valueToFilterStringList = listAux;
        }
        public DW_QueryCondition(String field, String criteria, Decimal valueToFilter){
            this.conditionType = DW_ConditionOptions.DEC;
            this.field = field;
            this.criteria = criteria;
            this.valueToFilterDecimal = valueToFilter;
        }
        public DW_QueryCondition(String field, String criteria, Date valueToFilter){
            this.conditionType = DW_ConditionOptions.DT;
            this.field = field;
            this.criteria = criteria;
            this.valueToFilterDate = valueToFilter;
        }
        public DW_QueryCondition(String field, String criteria, Datetime valueToFilter){
            this.conditionType = DW_ConditionOptions.DTTIME;
            this.field = field;
            this.criteria = criteria;
            this.valueToFilterDatetime = valueToFilter;
        }
    
        public String renderChild(DW_OperatorOptions operatorOption, Boolean isFirstNodeOfChildren){//todo arrumar parametro
            String operator = '';
            if (operatorOption == DW_OperatorOptions.AND_OPERATOR && !isFirstNodeOfChildren) {
                operator = ' AND ';
            }else if (operatorOption == DW_OperatorOptions.OR_OPERATOR && !isFirstNodeOfChildren) {
                operator = ' OR ';
            }
            String query = '';
            if (this.conditionType == DW_ConditionOptions.STR) {
                query = renderStr();
            }else if(this.conditionType == DW_ConditionOptions.STR_IN){
                query = renderStrIn();
            }else if(this.conditionType == DW_ConditionOptions.DEC){
                query = renderDec();
            }else if(this.conditionType == DW_ConditionOptions.DT){
                query = renderDt();
            }else if(this.conditionType == DW_ConditionOptions.DTTIME){
                query = renderDttime();
            }else if(this.conditionType == DW_ConditionOptions.BOOL){
                query = renderBoolean();
            }else{
                throw new InvalidParameterValueException('Não foi possível renderizar a query porque nenhum renderizador válido foi encontrado.', '');
            }
            return operator + query;
        }
    
        public String render(Boolean isFirst){
            String operator = '';
            if (this.operator == DW_OperatorOptions.AND_OPERATOR && !isFirst) {
                operator = ' AND ';
            }else if (this.operator == DW_OperatorOptions.OR_OPERATOR && !isFirst) {
                operator = ' OR ';
            }
            String query = '';
            if (this.conditionType == DW_ConditionOptions.STR) {
                query = renderStr();
            }else if(this.conditionType == DW_ConditionOptions.STR_IN){
                query = renderStrIn();
            }else if(this.conditionType == DW_ConditionOptions.DEC){
                query = renderDec();
            }else if(this.conditionType == DW_ConditionOptions.DT){
                query = renderDt();
            }else if(this.conditionType == DW_ConditionOptions.DTTIME){
                query = renderDttime();
            }else if(this.conditionType == DW_ConditionOptions.BOOL){
                query = renderBoolean();
            }else{
                throw new QueryConditionException('Não foi possível renderizar a query porque nenhum renderizador válido foi encontrado.');
            }
            return operator + query;
        }
    
        private String renderStr(){
            return this.field + this.criteria + '\'' + this.valueToFilterString + '\'';
        }
    
        private String renderStrIn(){
            return this.field + ' IN (\'' + String.join(this.valueToFilterStringList, '\',\'')+'\')';
        }
    
        private String renderDec(){
            return this.field + this.criteria + this.valueToFilterDecimal;
        }
    
        private String renderDt(){
            Datetime dttime = Datetime.newInstance(this.valueToFilterDate.year(), this.valueToFilterDate.month(), this.valueToFilterDate.day(), 0, 0, 0);
            return this.field + this.criteria + dttime.format('yyyy-MM-dd');
        }
    
        private String renderDttime(){
            return this.field + this.criteria + this.valueToFilterDatetime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        }
    
        private String renderBoolean(){
            return this.field + this.criteria + this.valueToFilterBoolean;
        }
    
        public class QueryConditionException extends Exception{}
    
    }