@RestResource(urlMapping='/Account/*')
global with sharing class AccountExpose {

@HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id, Name, Phone, Website,Public_or_Private__c,ExternalId__c FROM Account WHERE Id = :accountId];
        return result;
    }

    @HttpPost
    global static String doPost(String name,
        String phone, String website, String publicOrPrivate, String externalId) {
        Account account = new Account();
        account.name = name;
        account.phone = phone;
        account.website = website;
        account.Public_or_Private__c = publicOrPrivate;
        account.ExternalId__c = externalId;
        insert account;
        return account.Id;
    }
}