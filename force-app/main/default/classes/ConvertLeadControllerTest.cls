@isTest
private class ConvertLeadControllerTest 
{
	@TestSetup
	static void makeData(){
		Lead testLead = new Lead(
			FirstName='123213213100800',
			LastName = '100800',
			Status='Qualified',
			company='Lacosta',
            Paises_Admitidos__c= 'Argentina',
            Public_or_Private__c= 'public',
			street='1211 E I-40 Service Rd',
			city=' Oklahoma City',
			state='OK'
  	    );
		insert testLead;
		

        Lead testLead2 = new Lead(
			FirstName='10082131231020',
			LastName = 'UnitTest',
			Status='New',
			company='Lacostaa',
            Paises_Admitidos__c= 'Argentina',
            Public_or_Private__c= 'private',
			street='1211 E I-40 Service Rd',
			city=' Oklahoma City',
			state='OK'
  	    );
		insert testLead2;
	}
	static TestMethod void AutoConvert()
	{
		test.StartTest();
			List<Id> listLeadId = new List<Id>();
            List<Lead> lista = [SELECT Id FROM Lead LIMIT 2];
			for (Lead aLead : lista) {
				listLeadId.add(aLead.Id);
			}
            ConvertLeadController.LeadAssign(listLeadId);
	    	test.stopTest();
			List<Contact> listContact = [SELECT Id FROM Contact LIMIT 1];
			List<Account> listAccount = [SELECT Id FROM Account LIMIT 1];
			List<Opportunity> listOpportunity = [SELECT Id FROM Opportunity LIMIT 1];
			System.assertEquals(1, listContact.size(), 'Error');
			System.assertEquals(1, listAccount.size(), 'Error');
			System.assertEquals(1, listOpportunity.size(), 'Error');
        	
    }
}