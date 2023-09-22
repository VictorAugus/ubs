public without sharing class DW_ResponseHTTP {
    public Boolean success;
    public Boolean error;
    public List<String> errorList = new List<String>();
    public Object dataMap = new Map<String, Object>();

    public static String success(Object dataMap){
        DW_ResponseHTTP response = new DW_ResponseHTTP();
        response.success = true;
        response.error = false;
        response.dataMap = dataMap;
        return JSON.serialize(response);
    }

    public static DW_ResponseHTTP successObj(Object dataMap){
        DW_ResponseHTTP response = new DW_ResponseHTTP();
        response.success = true;
        response.error = false;
        response.dataMap = dataMap;
        return response;
    }

    public static String error(List<String> errorList){
        DW_ResponseHTTP response = new DW_ResponseHTTP();
        response.success = false;
        response.error = true;
        response.errorList = errorList;
        return JSON.serialize(response);
    }
    public static DW_ResponseHTTP errorObj(List<String> errorList){
        DW_ResponseHTTP response = new DW_ResponseHTTP();
        response.success = false;
        response.error = true;
        response.errorList = errorList;
        return response;
    }

    public static String error(List<String> errorList, Object dataMap){
        DW_ResponseHTTP response = new DW_ResponseHTTP();
        response.success = false;
        response.error = true;
        response.errorList = errorList;
        response.dataMap = dataMap;
        return JSON.serialize(response);
    }
    public static DW_ResponseHTTP errorObj(List<String> errorList, Object dataMap){
        DW_ResponseHTTP response = new DW_ResponseHTTP();
        response.success = false;
        response.error = true;
        response.errorList = errorList;
        response.dataMap = dataMap;
        return response;
    }

    public static String generateByException(Exception e){
        return DW_ResponseHTTP.error(new List<String>{
            e.getMessage(),
            // e.getCause(),
            String.valueOf(e.getLineNumber()),
            e.getStackTraceString()
        });
    }
    
}