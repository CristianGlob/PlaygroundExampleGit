@IsTest
private class AccountExposeTest {

    @isTest static void testGetAccountById() {
        Id recordId = createTestRecord();
        
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://mediaassociatescompany-dev-ed.lightning.force.com/services/apexrest/Account/'
            + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        Account thisAccount = AccountExpose.doGet();
        
        System.assert(thisAccount != null,'the account is null');
        System.assertEquals('Test Account', thisAccount.Name, 'the name of account is not correct');
    }
    @isTest static void testCreateAccount() {
        
        Id thisAccountId = AccountExpose.doPost('Test Account', '121212', 'com.friendfeed.Job', 'public', '123123');
        
        System.assert(thisAccountId != null,'the account id is null');
        Account thisAccount = [SELECT Id, Name, Phone, Website, Public_or_Private__c, ExternalId__c FROM Account WHERE Id=:thisAccountId];
        System.assert(thisAccount != null,'the account is null');
        System.assertEquals(thisAccount.Name, 'Test Account','the name of account is not correct');
    }
      
    static Id createTestRecord() {
        Account accTest = new Account(
            Name= 'Test Account',
            Phone= '121212',
            Website= 'com.friendfeed.Job',
            Public_or_Private__c = 'public',
            ExternalId__c = '123123'
            );
        insert accTest;
        return accTest.Id;
    }          
}