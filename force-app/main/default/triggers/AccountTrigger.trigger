/*
 	Trigger on Account / Case
	1. If Active field on the Account is updated to False.
		a. Validation - 
			i. Account should not be updated to Active if it has any Case that is in Escalated Status.
			ii. Error Message for Validation - There are some escalated cases for this account. Please close them first.
*/


/*
 *  2. When Account is Deactivated by updating its Active field to False
    a. All of the Cases for this Account should be closed by updating their Status field to Closed if 
       those are not in the Escalated Status.
*/

/*
  Description : Trigger on Account Object.
  Author : Sajan Jambhulkar
  Created Date : 17-10-2022
  Last Modified Date : 17-10-2022
*/



trigger AccountTrigger on Account (before update, after update) {
    if(trigger.isBefore && trigger.isUpdate){
            AccountTriggerHandler.validateAccount(trigger.new, trigger.oldMap);
    }
    else if(trigger.isAfter && trigger.isUpdate){
            AccountTriggerHandler.closeCases(trigger.new, trigger.oldMap);
    }
}