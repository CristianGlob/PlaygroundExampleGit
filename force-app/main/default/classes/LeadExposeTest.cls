@IsTest
private class LeadExposeTest {
    @isTest static void testGetLeadById() {
        Id recordId = createTestRecord();
        
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://mediaassociatescompany-dev-ed.lightning.force.com/services/apexrest/Lead/'
            + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        Lead thisLead = LeadExpose.doGet();
        
        System.assert(thisLead != null,'the lead is null');
        System.assertEquals('Test Lead Last Lead', thisLead.Name, 'the name of Lead is not correct');
    }
    @isTest static void testCreateLead() {
        
        Id thisLeadId = LeadExpose.doPost('Test Lead', 'Last Lead', 'Argentina','Argentina', 'Cold', 'public', '123123', 'Argentina', 'New');
        
        System.assert(thisLeadId != null,'the lead id is null');
        Lead thisLead = [SELECT Id, Name,FirstName, LastName, Public_or_Private__c, Company,Paises_Admitidos__c, Status, Country, Rating FROM Lead WHERE Id=:thisLeadId];
        System.assert(thisLead != null,'the lead is null');
        System.assertEquals(thisLead.Name, 'Test Lead Last Lead','the name of lead is not correct');
    }
      
    static Id createTestRecord() {
        Lead aLead = new Lead(
            FirstName = 'Test Lead',
            LastName= 'Last Lead',
            Company = 'asd123',
            Paises_Admitidos__c= 'Argentina',
            rating = 'Cold',
            Public_or_Private__c = 'public',
            ExternalId__c = '123123',
            country = 'Argentina',
            status = 'New'
            );
        insert aLead;
        return aLead.Id;
    }          
}