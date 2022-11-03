/*
Description : This is a handler for trigger on Case object to show the count of related cases on account object.
Author : Sajan Jambhulkar
Created Date : 17-10-2022
Last Modified Date : 20-10-2022
Last Modified By : Sajan Jambhulkar
*/

public class CaseTriggerHandler {
    
    // Method to count related new and escalated case on Account.
    public static void countCases(List<Case> caseNewList, List<Case> caseOldList){
        Set<Id> accIdSet = new Set<Id>();
        if(caseNewList != null){
            for(Case cas : caseNewList){
                if(cas.AccountId != null){
                    accIdSet.add(cas.AccountId);
                }
            }
        }
        if(caseOldList != null){
            for(Case cas : caseOldList){
                if(cas.AccountId != null){
                    accIdSet.add(cas.AccountId);
                }
            }
        }
        
        List<Account> accList = new List<Account>();
        
        Map<Id, Account> accWithNewCasesMap = new Map<Id, Account>([SELECT Id, (SELECT Id, Status FROM Cases
                                                                                WHERE Status = 'New') 
                                                                    FROM Account WHERE Id IN: accIdSet]);
        Map<Id, Account> accWithEscalatedCasesMap = new Map<Id, Account>([SELECT Id, (SELECT Id, Status FROM Cases
                                                                                      WHERE Status = 'Escalated')
                                                                          FROM Account WHERE Id IN: accIdSet]);
        
        for(Account acc : [SELECT Id, Escalated_Cases_Count__c, New_Cases_Count__c FROM Account WHERE Id IN: accIdSet]){
            acc.New_Cases_Count__c = accWithNewCasesMap.get(acc.Id).Cases.size();
            acc.Escalated_Cases_Count__c = accWithEscalatedCasesMap.get(acc.Id).Cases.size();
            accList.add(acc);
        }
        try{
            if(!accList.isEmpty()){
                update accList;
            }
        }
        catch(Exception e){
            System.debug('Exception Message '+e.getMessage() + ' Line No. >> '+e.getLineNumber());
        }
    }
}