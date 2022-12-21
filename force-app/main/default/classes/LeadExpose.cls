@RestResource(urlMapping='/Lead/*')
global with sharing class LeadExpose {

@HttpGet
    global static Lead doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String leadId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Lead result = [SELECT Id, Name, FirstName, LastName, Public_or_Private__c, Company, Status, Country, Rating  FROM Lead WHERE Id = :leadId];
        return result;
    }

    @HttpPost
    global static String doPost(String name,String lastname, String paisesAdmitidos,
        String company, String rating, String publicOrPrivate, String externalId, String country, String status) {
        Lead aLead = new Lead();
        aLead.FirstName = name;
        aLead.LastName = lastname;
        aLead.Company = company;
        aLead.Paises_Admitidos__c = paisesAdmitidos;
        aLead.rating = rating;
        aLead.Public_or_Private__c = publicOrPrivate;
        aLead.ExternalId__c = externalId;
        aLead.status = status;
        aLead.country = country;

        insert aLead;
        return aLead.Id;
    }
}