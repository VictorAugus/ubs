/**
 * Created by guilhermereis on 12/04/21.
 */
@IsTest
public with sharing class DW_HelperTest {
    @IsTest
    public static void main(){
        Opportunity opp = new Opportunity();
        opp.Name = '';
        opp.Amount = 1000;
        Opportunity opp2 = new Opportunity();

        DW_Helper.isNullOrBlank(opp.Name);
        DW_Helper.isNullOrBlank(opp2.Name);
        DW_Helper.isNullOrBlank(opp.Amount);
        DW_Helper.isNullOrBlank(opp2.Amount);
        DW_Helper.isNullOrBlank(opp2);


        DW_Helper.hasSomeContent(opp.Name);
        DW_Helper.hasSomeContent(opp2.Name);
        DW_Helper.hasSomeContent(opp.Amount);
        DW_Helper.hasSomeContent(opp2.Amount);
        DW_Helper.hasSomeContent(opp2);
    }
}