/**
 * Created by guilhermereis on 18/01/21.
 */
@IsTest
public with sharing class DW_QueryFactoryTest {
    @IsTest
    public static void main(){
        DW_QueryFactory.get('Opportunity')
            .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho'))
            .withParent('Account')
            .run();


        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('StageName', new List<String>{'Fechado/Ganho'}))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('StageName', new Set<String>{'Fechado/Ganho'}))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('Amount', '=', 0))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('HasOpportunityLineItem', '=', true))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('LastActivityDate', '=', System.today()))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('LastReferencedDate', '=', System.now()))
                .run();



        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho', DW_OperatorOptions.OR_OPERATOR))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('StageName', new List<String>{'Fechado/Ganho'}, DW_OperatorOptions.OR_OPERATOR))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('StageName', new Set<String>{'Fechado/Ganho'}, DW_OperatorOptions.OR_OPERATOR))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('Amount', '=', 0, DW_OperatorOptions.OR_OPERATOR))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('HasOpportunityLineItem', '=', true, DW_OperatorOptions.OR_OPERATOR))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('LastActivityDate', '=', System.today(), DW_OperatorOptions.OR_OPERATOR))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('LastReferencedDate', '=', System.now(), DW_OperatorOptions.OR_OPERATOR))
                .run();


        DW_QueryFactory.get('Opportunity')
            .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho'))
            .setOrCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Perdido'))
            .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('StageName', new List<String>{'Fechado/Ganho', 'Fechado/Perdido'}))
                .run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho'))
                .setCondition(DW_QueryCondition.newInstance('Amount', '>', 50000))
                .run();


        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('CloseDate', '>', System.today().addDays(-300)))
                .run();

        DW_QueryFactory.get('Opportunity')
        .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho'))
        .setGroupedCondition(DW_QueryConditionComposition.setConditionList(
                new List<DW_QueryCondition>{
                    DW_QueryCondition.newInstance('Amount', '<', 5000),
                    DW_QueryCondition.newInstance('Amount', '>', 50000, DW_OperatorOptions.OR_OPERATOR)
                }, null
        ))
        .setGroupedCondition(DW_QueryConditionComposition.setConditionList(
                new List<DW_QueryCondition>{
                        DW_QueryCondition.newInstance('Amount', '>', 20000),
                        DW_QueryCondition.newInstance('Amount', '<', 30000, DW_OperatorOptions.AND_OPERATOR)
                }, null
        )).run();

        DW_QueryFactory.get('Opportunity')
                .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho'))
                .setGroupedCondition(DW_QueryConditionComposition.setOrConditionList(
                new List<DW_QueryCondition>{
                        DW_QueryCondition.newInstance('Amount', '<', 5000),
                        DW_QueryCondition.newInstance('Amount', '>', 50000, DW_OperatorOptions.OR_OPERATOR)
                }, null
        )).run();


        DW_QueryFactory.get('Opportunity')
            .setCondition(DW_QueryCondition.newInstance('StageName', '=', 'Fechado/Ganho'))
            .with('OpportunityLineItems', 'OpportunityLineItem')
            .limitedTo(10)
            .run();

    }
}