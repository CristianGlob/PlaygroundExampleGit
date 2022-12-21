public with sharing class IntegrationBatch implements Database.Batchable<SObject>, Database.AllowsCallouts{

    public List<sObject> start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        List<Product2> productos = IntegrationController.getProducts();
        System.debug('Busca productos');
        return productos;
    }
    public void execute(Database.BatchableContext bc, List<Product2> records){
        // process each batch of records
        System.debug('products: ' + records);
        if(records.size()>0){
            Database.UpsertResult[] srList = Database.upsert(records, Product2.External_ID__c, false);
            // insertar en la lista standard
            Id standardPricebookID = Test.isRunningTest() ? Test.getStandardPricebookId() : [SELECT id, IsStandard FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1].Id;
            List<PricebookEntry> priceStandardNew = new List<PricebookEntry>();
            //verificar si esta el producto ya en lista standard
            List<PricebookEntry> productInStandardList = [
                SELECT Id, Pricebook2Id, Product2.External_ID__c 
                FROM PricebookEntry 
                WHERE Pricebook2Id =: standardPricebookID
                LIMIT 5000
            ];
            Map<Id,PricebookEntry> productInStandardMap = new Map<Id,PricebookEntry>();
            productInStandardMap.putAll(productInStandardList);

            // va record o srList? La condición es continuar si no está en la lista standard
            for(Database.UpsertResult aSr : srList){
                if(!productInStandardMap.containsKey(aSr.Id)){
                    PricebookEntry priceStandard = new PricebookEntry();
                    priceStandard.Product2Id = aSr.Id;
                    priceStandard.Pricebook2Id = standardPricebookID;
                    priceStandard.IsActive = false;
                    priceStandard.UseStandardPrice = false;
                    priceStandard.UnitPrice = 100;
                    //teoricamente inserta un pricebookEntry con lista standard y el producto nuevo, 
                    //el precio es cualquiera porque no se usa, sino lo podemos buscar
                    priceStandardNew.add(priceStandard);
            }
            
            Database.UpsertResult[] dbStandardList = Database.upsert(priceStandardNew, false);

            System.debug('Crea los productos');
        
            for (Database.UpsertResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Product2 fields that affected this error: ' + err.getFields());
                    }
                }
            }
            for (Database.UpsertResult dbsl : dbStandardList) {
                if (dbsl.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted: ' + dbsl.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : dbsl.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Product2 fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }
        
    }
    public void finish(Database.BatchableContext bc){
        IntegrationBatchPricebook ibpb = new IntegrationBatchPricebook();
        Database.executeBatch(ibpb);
        System.debug('Llama al otro batch');
    }
}