public with sharing class IntegrationBatchPricebookEntry implements Database.Batchable<SObject>, Database.AllowsCallouts{

    public List<sObject> start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        List<PricebookEntry> precios = IntegrationController.getPrecios();
        System.debug('start precios: ' + precios);
        return precios;
    }

    public void execute(Database.BatchableContext bc, List<PricebookEntry> records){
        
        List<Product2> actualProducts = [
            SELECT Id, IsActive, External_ID__c, Name
            FROM Product2
            WHERE IsActive = TRUE
            LIMIT 9999
        ];
        System.debug('lista productos'+actualProducts);

        Map<String,Id> actualProductsMapByExtID = new Map<String,Id>();
        for (Product2 aProduct :actualProducts){
            actualProductsMapByExtID.put(aProduct.External_ID__c, aProduct.Id);
        }
        System.debug('mapa'+actualProductsMapByExtID);

        List<Pricebook2> actualPricebooks = [
            SELECT Id, ExternalId__c, Name 
            FROM Pricebook2
            WHERE IsActive = TRUE
            LIMIT 1000
        ];
        System.debug('lista pricebook'+actualPricebooks);

        Map<Decimal,Id> actualPricebookMapByExtID = new Map<Decimal,Id>();
        for (Pricebook2 aPricebook :actualPricebooks){
                actualPricebookMapByExtID.put(aPricebook.ExternalId__c, aPricebook.Id);
            }
        System.debug('mapa listas'+actualPricebookMapByExtID);

        List<PricebookEntry> recordsToUpdateList = new List<PricebookEntry>();
        for (PricebookEntry aRecord : records) {
            PricebookEntry recordToUpdate = new PricebookEntry();
            recordToUpdate.ExternalId__c = String.valueOf(aRecord.ExternalId__c);
            recordToUpdate.UnitPrice = aRecord.UnitPrice;
            recordToUpdate.Price_Book_Code__c = String.valueOf(aRecord.Price_Book_Code__c);
            recordToUpdate.Product_Code_New__c = String.valueOf(aRecord.Product_Code_New__c);
            recordToUpdate.Pricebook2Id = actualPricebookMapByExtID.get(decimal.valueOf(aRecord.Price_Book_Code__c));
            recordToUpdate.Product2Id = actualProductsMapByExtID.get(aRecord.Product_Code_New__c);
            recordToUpdate.IsActive = true;
            recordToUpdate.UseStandardPrice = false;
            recordsToUpdateList.add(recordToUpdate);
            System.debug('precios a insertar: '+ recordToUpdate);
        }
        System.debug('lista de recordsToUpdate: ' + recordsToUpdateList);

        Database.UpsertResult[] nsrList = Database.upsert(recordsToUpdateList, PricebookEntry.ExternalId__c, false);
        System.debug('execute Insertó lista de precios');
            
        for (Database.UpsertResult nsr : nsrList) {
            if (nsr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted: ' + nsr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : nsr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('PricebookEntry fields that affected this error: ' + err.getFields());
                }
            }
        }
    }

    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
}