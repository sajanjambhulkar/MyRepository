/*
Description : This is a handler for trigger on Account Object.
Author : Sajan Jambhulkar
Created Date : 17-10-2022
Last Modified Date : 20-10-2022
Last Modified By : Sajan Jambhulkar
*/

public class AccountTriggerHandler {
    
    // Account should not be updated to Active if it has any Case that is in Escalated Status.
    public static void validateAccount(List<Account> accList, Map<Id, Account> oldAccMap){
        Map<Id, Account> acctsWithCasesMap = new Map<Id, Account>([SELECT Id,
                                                                   (SELECT Id, Status FROM Cases WHERE Status = 'Escalated')
                                                                   FROM Account WHERE Id IN: accList]);
        for(Account acc : accList){
            if((oldAccMap.get(acc.Id).Active__c != acc.Active__c) && (acc.Active__c == 'Yes')
               && (!acctsWithCasesMap.get(acc.Id).Cases.isEmpty())){
                   acc.Active__c.addError('There are some escalated cases for this account. Please close them first.');
               }
        }
    }
    
    // Close related cases if they are not in Escalated state when Account is deactivated.
    public static void closeCases(List<Account> accList, Map<Id, Account> oldAccMap){
        Set<Id> accIdSet = new Set<Id>();
        for(Account acc : accList){
            if((oldAccMap.get(acc.Id).Active__c != acc.Active__c) && acc.Active__c == 'No'){
                accIdSet.add(acc.Id);
            }
        }
        List<Case> updateCaseList = [SELECT Id, AccountId, Status FROM Case 
                                     WHERE AccountId IN: accIdSet AND Status != 'Escalated'];
        if(updateCaseList != null){
            for(Case cas : updateCaseList){
                cas.Status = 'Closed';
            }
        }
        try{
            if(!updateCaseList.isEmpty()){
                update updateCaseList;
            }
        }
        catch(Exception e){
            System.debug('Exception Message '+e.getMessage() + ' Line No. >> '+e.getLineNumber());
            System.debug('added this comment');
        }
    }
}