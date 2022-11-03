/*
3. There should be 2 count fields on the Account, and those should be updated for case updates if case status changes
a. New Cases Count
b. Escalated Cases Count

*/
/*
Description : Trigger on Case Object to Count number of cases on Account
Author : Sajan Jambhulkar
Created Date : 17-10-2022
Last Modified Date : 17-10-2022
Last Modified By : Sajan Jambhulkar
*/

trigger CaseTrigger on Case (after insert, after update, after delete, after undelete) {
	if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate || trigger.isDelete || trigger.isUndelete){
            CaseTriggerHandler.countCases(trigger.new, trigger.old);
        }
    }
}