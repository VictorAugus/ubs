/**
 * Created by guilhermereis on 12/04/21.
 */

public with sharing class DW_Helper {
    public static Boolean isNullOrBlank(String str){
        if (str == '' || str == null) {
            return true;
        }
        return false;
    }
    public static Boolean isNullOrBlank(Object obj){
        if (obj == null) {
            return true;
        }
        return false;
    }

    public static Boolean hasSomeContent(String str){
        if (str != '' && str != null) {
            return true;
        }
        return false;
    }

    public static Boolean hasSomeContent(Object obj){
        if ( obj != null) {
            return true;
        }
        return false;
    }
    
    public static Integer valueOf(String str){
        if(str!= null && str != '' && str.isNumeric()){
            return Integer.valueOf(str);
        }
        return 0;
    }
    
    public static String removeNullValues(List<Object> listBase){
        Set<Object> setBase = new Set<Object>(listBase);
        setBase.remove(null);
        setBase.remove('');
        return JSON.serialize(new List<Object>(setBase));
    }

}