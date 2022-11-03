/*
  Description : Trigger on Student__c Object to store history of changes made.
  Author : Sajan Jambhulkar
  Created Date : 02-11-2022
  Last Modified Date : 02-11-2022
  Last Modified By : Sajan Jambhulkar
*/

trigger StudentHistory on Student__c (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        StudentHistoryHandler.saveHistory(trigger.oldMap, trigger.newMap);
    }
}