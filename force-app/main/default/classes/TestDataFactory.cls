@isTest
public class TestDataFactory {
   
      public static Account getAccount(String name, String externalId, Boolean doInsert){
        Account a = new Account();
            name = a.name;
            externalId = a.ExternalId__c;
          
        if(doInsert){
          insert a;
        }
        return a;
      }
      public static Contact getContact(Id accountId, String fname, String lname, Boolean doInsert){
        Contact c = new Contact(firstName = fname, lastName = lname, accountId = accountId);
        if(doInsert){
          insert c;
        }
        return c;
      }
      public static void generateAccountWithContacts(Integer numContacts){
         Account a = getAccount('default account ltd', 'id',true);
         List<Contact> contacts = new List<Contact>();
         for(Integer i = 0; i < numContacts; i++){
           String contactName = 'contact' + i;
           contacts.add(getContact(a.id, contactName, contactName, false));
        }
         insert contacts;
       }
      public static Opportunity[] generateOppsForAccount(id accountId, Decimal amount, Integer numOpps){
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i = 0; i < numOpps; i++){
          Opportunity o = new Opportunity();
          o.name = 'Account ' + i;
          o.accountId = accountid;
          o.amount = amount;
          o.closeDate = Date.today().addDays(5);
          o.stageName = 'Prospecting';
          opps.add(o);
        }
        return opps;
      }
      public static User generateUser(String profileName){
        UserRole userRole = new UserRole(DeveloperName = 'TestingTeam', Name = 'Testing Team');
        insert userRole;
        User u = new User(
          ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id,
          LastName = 'last',
          Email = 'Cpt.Awesome@awesomesauce.com',
          Username = 'Cpt.Awesome@awesomesauce.com',
          CompanyName = 'Testing Co',
          Title = 'Captian',
          Alias = 'alias',
          TimeZoneSidKey = 'America/Los_Angeles',
          EmailEncodingKey = 'UTF-8',
          LanguageLocaleKey = 'en_US',
          LocaleSidKey = 'en_US',
          UserRoleId = userRole.Id
        );
        insert u;
        return u;
      }
      public static void getProduct(){
      Product2 prod = new Product2();
      prod.IsActive = true;
      prod.Name = 'Test';
      insert prod;
      }

      public static void getNewPricebook(){
      Pricebook2 pb = new Pricebook2();
      pb.Name = 'Test';
      pb.IsActive = true;
      insert pb;
      }

      public static void getPricebookEntry(){
        Product2 prod = [
          SELECT Id, Name 
          FROM Product2 
          WHERE Name = 'Test'
          LIMIT 1
          ];
        //La query no devuelve nada
      // Pricebook2 standardpb = [
      //   SELECT Id, Name, IsActive 
      //   FROM Pricebook2 
      //   WHERE Id = :Test.getStandardPricebookId()
      //   LIMIT 1
      //   ];  

      Pricebook2 pb = [
        SELECT Id, Name 
        FROM Pricebook2 
        WHERE Name= 'Test' 
        LIMIT 1
        ];


      PricebookEntry standardpbe = new PricebookEntry();
      standardpbe.Pricebook2Id = Test.getStandardPricebookId();
      standardpbe.Product2Id = prod.Id;
      standardpbe.UnitPrice = 10000;
      standardpbe.IsActive = true;
      standardpbe.UseStandardPrice = false;
      insert standardpbe;
      
      PricebookEntry pbe = new PricebookEntry();
      pbe.Pricebook2Id = pb.Id;
      pbe.Product2Id = prod.Id;
      pbe.UnitPrice = 10000;
      pbe.IsActive = true;
      pbe.UseStandardPrice = false;
      insert pbe;
      }
}