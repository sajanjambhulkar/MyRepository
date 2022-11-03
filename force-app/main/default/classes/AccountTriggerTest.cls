/*
Description : Test class for trigger on Account Object
Author : Sajan Jambhulkar
Created Date : 18-10-2022
Last Modified Date : 18-10-2022
*/

@isTest
private class AccountTriggerTest {
    @testSetup
    static void createTestData(){
        List<Account> accList = new List<Account>();
        accList.add(new Account(Name = 'Test 1', Active__c = 'No'));
        accList.add(new Account(Name = 'Test 2', Active__c = 'No'));
        accList.add(new Account(Name = 'Test 3', Active__c = 'No'));
        accList.add(new Account(Name = 'Test 4', Active__c = 'No'));
        accList.add(new Account(Name = 'Test 5', Active__c = 'Yes'));
        accList.add(new Account(Name = 'Test 6', Active__c = 'Yes'));
        
        insert accList;
        
        List<Case> caseList = new List<Case>();
        caseList.add(new Case(AccountId = accList[0].Id, Status = 'Escalated', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[0].Id, Status = 'New', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[1].Id, Status = 'New', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[1].Id, Status = 'Working', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[1].Id, Status = 'Escalated', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[3].Id, Status = 'New', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[3].Id, Status = 'Working', Origin = 'Phone'));
        
        caseList.add(new Case(AccountId = accList[4].Id, Status = 'Working', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[4].Id, Status = 'Working', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[4].Id, Status = 'Escalated', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[5].Id, Status = 'Working', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[5].Id, Status = 'Working', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[5].Id, Status = 'Escalated', Origin = 'Phone'));
        insert caseList;
    } 
    
    @isTest
    // activate account which has cases in escalated state, it should not be updated.
    static void activateAccWithEscCase(){
        List<Account> accList = [SELECT Id, Active__c FROM Account WHERE Name IN('Test 1', 'Test 2')];
        for(Account acc : accList){
            acc.Active__c = 'Yes';
        }
        Test.startTest();
        Database.update(accList, False);
        Test.stopTest();
        
        List<Account> accList2 = [SELECT Id, Active__c FROM Account WHERE Name IN('Test 1', 'Test 2')];
        
        System.assertEquals('No', accList2[0].Active__c, 'Active field value of account does no match');
        System.assertEquals('No', accList2[1].Active__c, 'Active field value of account does no match');
    }
    
    @isTest
    //activate account which does not have cases in escalated state
    static void activateAccWithoutEscCase(){
        List<Account> accList = [SELECT Id, Active__c FROM Account WHERE Name IN('Test 3', 'Test 4')];
        for(Account acc : accList){
            acc.Active__c = 'Yes';
        }
        Test.startTest();
        Database.update(accList, False);
        Test.stopTest();
        
        List<Account> accounts = [SELECT Id, Active__c FROM Account WHERE Name IN('Test 3', 'Test 4')];
        
        System.assertEquals('Yes', accounts[0].Active__c, 'Active field value of account does no match');
        System.assertEquals('Yes', accounts[1].Active__c, 'Active field value of account does no match');
    }
    
    @isTest
    // deactivate account and check if realated case got closed or not
    static void deactivateAccount(){
        List<Account> accList = [SELECT Id, Name, Active__c FROM Account WHERE Name IN('Test 5', 'Test 6')];
        for(Account acc : accList){
            acc.Active__c = 'No';
        }
        Test.startTest();
        Database.update(accList);
        Test.stopTest();
        
        List<Case> caseList = [SELECT Id, Status, Account.Name FROM Case WHERE Account.Name IN('Test 5', 'Test 6')];
        system.assertEquals(6, caseList.size(), 'Case size does not match');
        System.assertEquals('Closed', caseList[0].Status, 'Status of case do not match.');
        System.assertEquals('Closed', caseList[1].Status, 'Status of case do not match.');
        System.assertEquals('Escalated', caseList[2].Status, 'Status of case do not match.');
        System.assertEquals('Closed', caseList[3].Status, 'Status of case do not match.');
        System.assertEquals('Closed', caseList[4].Status, 'Status of case do not match.');
        System.assertEquals('Escalated', caseList[5].Status, 'Status of case do not match.');
    }
}