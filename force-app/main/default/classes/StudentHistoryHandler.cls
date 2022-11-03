/*
Description : This is a handler for trigger on Student__c Object.
Author : Sajan Jambhulkar
Created Date : 02-11-2022
Last Modified Date : 02-11-2022
Last Modified By : Sajan Jambhulkar
*/

public class StudentHistoryHandler {
    public static void saveHistory(Map<Id, Student__c> stuOldMap, Map<Id, Student__c> stuNewMap){
        List<Student_History__c> studentHistoryList = new List<Student_History__c>();
        
        
        for(Student__c student : stuNewMap.values()){
            Map<String, Object> fieldsInfo = student.getPopulatedFieldsAsMap();
            
            // Sobject class
            // Returns a map of populated field names and their corresponding values
            
            for(String fieldName : fieldsInfo.keySet()){
                // by keySet we get the field name in the string form
                
               // if(fieldName == 'LastModifiedDate' || fieldName=='SystemModstamp'){
                    // SystemModstamp is the date and time when a record was last modified by a user 
                    // or by an automated process
                    //continue;
                    // continue keyword skips to the next iteration of the loop.
                    // DO NOTHING.
               // }
                //else{
                    if((stuOldMap.get(student.Id).get(fieldName) != stuNewMap.get(student.Id).get(fieldName))
                      && (fieldName != 'LastModifiedDate') && (fieldName != 'SystemModstamp')){
                        Student_History__c stuHistory = new Student_History__c();
                        stuHistory.Name = fieldName;
                        
                        //stuHistory.Old_Value__c = stuOldMap.get(student.Id).get(fieldName);
                        // Illegal assignment from Object to String
                        
                        stuHistory.Old_Value__c = String.valueOf(stuOldMap.get(student.Id).get(fieldName));
                        stuHistory.New_Value__c = String.valueOf(stuNewMap.get(student.Id).get(fieldName));
                        stuHistory.Record_Id__c = student.Id;
                        
                        studentHistoryList.add(stuHistory);
                    }
               // }
            }
        }
        if(!studentHistoryList.isEmpty()){
            insert studentHistoryList;
        }
    }
}