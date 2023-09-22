/**
 * Created by guilhermereis on 22/02/21.
 */

@IsTest
public with sharing class DW_ExceptionTest {
    @IsTest
    public static void main(){
        try {
            throw new DW_Exception('okok');
        }catch (Exception e){

        }
    }
}