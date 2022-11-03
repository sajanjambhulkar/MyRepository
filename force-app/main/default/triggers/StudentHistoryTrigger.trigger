trigger StudentHistoryTrigger on Student__c (after update) {
    
    // Added a comment to test repository from vs code

    List<Student_History__c> studentHistoryData = new List<Student_History__c>();
    for(Student__c student : trigger.new){
        Map<String, Object> fieldsInfo = student.getPopulatedFieldsAsMap();
        for(String fieldName : fieldsInfo.keySet()){
            // using key set we get set of keys i.e. field name in string type
            if(fieldName == 'LastModifiedDate' || fieldName=='SystemModstamp'){
                continue;
            }
            else{
                if(trigger.oldMap.get(student.Id).get(fieldName) != trigger.newMap.get(student.Id).get(fieldName)){
                    studentHistoryData.add(new Student_History__c(
                    Name = fieldName,
                    Record_Id__c = student.Id,
                    Old_Value__c = String.valueOf(trigger.oldMap.get(student.Id).get(fieldName)),
                    New_Value__c = String.valueOf(trigger.newMap.get(student.Id).get(fieldName))));
                }
            }
        }
    }
    insert studentHistoryData;
}