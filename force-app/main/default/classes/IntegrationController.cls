public with sharing class IntegrationController {
    @testVisible private static boolean finalizado = false;

   @AuraEnabled(cacheable=true)
    public static List<Product2> getProducts() {

        return IntegrationCallout.makeGetCalloutProducts();        
    }

    @AuraEnabled(cacheable=true)
    public static List<PricebookEntry> getPrecios() {

        return IntegrationCallout.makeGetCalloutPrice();        
    }

    @AuraEnabled(cacheable=true)
    public static List<Pricebook2> getListas() {
        return IntegrationCallout.makeGetCalloutPricebook();        
    }
   
}