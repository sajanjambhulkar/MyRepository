/*
Description : Test class for trigger on Case Object
Author : Sajan Jambhulkar
Created Date : 18-10-2022
Last Modified Date : 18-10-2022
*/

@isTest
private class CaseTriggerTest {
    @testSetup
    // testSetup method to create a data on class level.
    static void createTestData(){
        List<Account> accList = new List<Account>();
        accList.add(new Account(Name = 'Test 1'));
        accList.add(new Account(Name = 'Test 2'));
        accList.add(new Account(Name = 'Test 3'));
        insert accList;
        
        List<Case> caseList = new List<Case>();
        caseList.add(new Case(AccountId = accList[0].Id, Status = 'New', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[0].Id, Status = 'New', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[0].Id, Status = 'Escalated', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[0].Id, Status = 'Working', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[1].Id, Status = 'Escalated', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[1].Id, Status = 'Escalated', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[1].Id, Status = 'Working', Origin = 'Phone'));
        caseList.add(new Case(AccountId = accList[1].Id, Status = 'New', Origin = 'Web'));
        insert caseList;
    }
    
    @isTest
    // test method for insert DML operation
    static void insertTest(){
        List<Account> accList = [SELECT Id, New_Cases_Count__c, Escalated_Cases_Count__c FROM Account];
        List<Case> caseList = [SELECT Id FROM Case];
        
        System.assertEquals(2, accList[0].New_Cases_Count__c, 'New Case Count does not match.');
        System.assertEquals(1, accList[0].Escalated_Cases_Count__c, 'Escalated Case Count does not match.');
        System.assertEquals(1, accList[1].New_Cases_Count__c, 'New Case Count does not match.');
        System.assertEquals(2, accList[1].Escalated_Cases_Count__c, 'Escalated Case Count does not match.');
        System.assertEquals(Null, accList[2].New_Cases_Count__c, 'New Case Count does not match.');
        System.assertEquals(Null, accList[2].Escalated_Cases_Count__c, 'Escalated Case Count does not match.');
        System.assertEquals(8, caseList.size(), 'Number of cases created do not match.');
    }
    
    @isTest
    // test method for bulk insert
    static void insertBulkTest(){
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'Test 1' LIMIT 1];
        List<Case> caseList = new List<Case>();
        for(Integer i=0; i<200; i++){
            if(i<100){
                caseList.add(new Case(AccountId = acc.Id, Status = 'New', Origin = 'Phone'));
            }
            else{
                caseList.add(new Case(AccountId = acc.Id, Status = 'Escalated', Origin = 'Phone'));
            }
        }
        Test.startTest();
        insert caseList;
        Test.stopTest();
        
        List<Case> cases = [SELECT Id FROM Case];
        Account acc1 = [SELECT Id, Name, New_Cases_Count__c, Escalated_Cases_Count__c FROM Account 
                        WHERE Name = 'Test 1' LIMIT 1];
        
        System.assertEquals(208, Cases.size());
        System.assertEquals(102, acc1.New_Cases_Count__c);
        System.assertEquals(101, acc1.Escalated_Cases_Count__c);
        
    }
    
    @isTest
    // test method for update DML Operation.
    static void updateTest(){
        List<Case> caseList = [SELECT Id, Status FROM Case WHERE Status = 'Escalated'];
        for(Case cas : caseList){
            cas.Status = 'Closed';
        }
        Test.startTest();
        update caseList;
        Test.stopTest();
        
        List<Account> accList = [SELECT Id, New_Cases_Count__c, Escalated_Cases_Count__c FROM Account];
        System.assertEquals(2, accList[0].New_Cases_Count__c, 'New Case Count does not match.');
        System.assertEquals(0, accList[0].Escalated_Cases_Count__c, 'Escalated Case Count does not match.');
        System.assertEquals(1, accList[1].New_Cases_Count__c, 'New Case Count does not match.');
        System.assertEquals(0, accList[1].Escalated_Cases_Count__c, 'Escalated Case Count does not match.');
    }
    @isTest
    // test method for updatation of parent.
    static void updateTestChangingParent(){
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test 1'];
        List<Case> caseList = [SELECT Id FROM Case WHERE Origin = 'Web'];
        for(Case ca : caseList){
            ca.AccountId = acc.Id;
        }
        
        Test.startTest();
        update caseList;
        Test.stopTest();
        
        List<Account> accList2 = [SELECT Id, New_Cases_Count__c, Escalated_Cases_Count__c FROM Account];
        
        System.assertEquals(3, accList2[0].New_Cases_Count__c, 'New Case Count does not match.');
        System.assertEquals(1, accList2[0].Escalated_Cases_Count__c, 'Escalated Case Count does not match.');
        System.assertEquals(0, accList2[1].New_Cases_Count__c, 'New Case Count does not match.');
        System.assertEquals(2, accList2[1].Escalated_Cases_Count__c, 'Escalated Case Count does not match.');
    }
    
    @isTest
    // test method for delete DML Operation
    static void deleteTest(){
        List<Case> caseList = [SELECT Id FROM Case WHERE Origin = 'Web'];
        Test.startTest();
        delete caseList;
        Test.stopTest();
        
        Account acc = [SELECT Id, New_Cases_Count__c, Escalated_Cases_Count__c FROM Account WHERE Name = 'Test 2'
                       LIMIT 1];
        System.assertEquals(0, acc.New_Cases_Count__c, 'New Case Count does not match.');
        System.assertEquals(2, acc.Escalated_Cases_Count__c, 'Escalated case count does not match.');
    }
    
    @isTest
    // test method for undelete DML Operation
    static void undeleteTest(){
        List<Case> caseList = [SELECT Id FROM Case];
        delete caseList;
        
        List<Account> accList = [SELECT Id, New_Cases_Count__c, Escalated_Cases_Count__c FROM Account];
        System.assertEquals(0, accList[0].New_Cases_Count__c, 'New cases count does not match.');
        System.assertEquals(0, accList[0].Escalated_Cases_Count__c, 'Escalated cases count does not match.');
        System.assertEquals(0, accList[1].New_Cases_Count__c, 'New cases count does not match.');
        System.assertEquals(0, accList[1].Escalated_Cases_Count__c, 'Escalated cases count does not match.');
        
        List<Case> undeleteCase = [SELECT Id, isDeleted FROM Case WHERE isDeleted = true ALL ROWS];
        
        Test.startTest();
        undelete undeleteCase;
        Test.stopTest();
        
        List<Account> accList1 = [SELECT Id, New_Cases_Count__c, Escalated_Cases_Count__c FROM Account];
        System.assertEquals(2, accList1[0].New_Cases_Count__c, 'New cases count does not match.');
        System.assertEquals(1, accList1[0].Escalated_Cases_Count__c, 'Escalated cases count does not match.');
        System.assertEquals(1, accList1[1].New_Cases_Count__c, 'New cases count does not match.');
        System.assertEquals(2, accList1[1].Escalated_Cases_Count__c, 'Escalated cases count does not match.');
    }
    
    @isTest
    static void exceptionTest(){
        List<Account> accList = [SELECT Id, Rating FROM Account];
        for(Account acc : accList){
            acc.Name = '';
        }
        try{
            update accList;
        }
        catch(Exception e){
            System.debug('Exception Message '+e.getMessage() + ' Line No. >> '+e.getLineNumber());
        }
    }
}