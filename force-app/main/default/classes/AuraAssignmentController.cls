public class AuraAssignmentController {
    
    @AuraEnabled(cacheable=true)
    public static List<String> getObjectName(){
        List<String> myObjects = new List<String>();
        Map<String, Schema.SObjectType> mp = new Map<String, Schema.SObjectType>();
        mp = Schema.getGlobalDescribe();    // Returns a map of all sObject names
        System.debug('map getGlobalDescribe '+mp);
        
        for(String str : mp.keySet()){
            myObjects.add(mp.get(str).getDescribe().getName());
            // getDescribe() is used to to get the details of the field like the name of the field
        }
        myObjects.sort();
        return myObjects;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getFieldName(String ObjName){
        List<String> myFields = new List<String>();
        Map<String, Schema.SObjectType> mp = new Map<String, Schema.SObjectType>();
        mp = Schema.getGlobalDescribe();
        
        Schema.SObjectType obj = mp.get(ObjName);
        Schema.DescribeSObjectResult res = obj.getDescribe();
        Map<String, Schema.SObjectField> fieldmap = res.fields.getMap();
        
        
        
        
        for(String str : fieldmap.keySet()){
            Schema.SObjectField field = fieldmap.get(str);
            myfields.add(String.valueOf(field));
        }
        myFields.sort();
        return myFields;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> getRecords(String field, String myobject){
        System.debug(field);
        System.debug(myObject);
        List<sObject> allrecords = new List<sObject>();
        allrecords = Database.query('SELECT '+field+' FROM '+myobject+' ');
        System.debug(allrecords);
        return allrecords;
    }
}