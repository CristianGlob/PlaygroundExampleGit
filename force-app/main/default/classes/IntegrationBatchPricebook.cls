public with sharing class IntegrationBatchPricebook implements Database.Batchable<SObject>, Database.AllowsCallouts{
    
    public List<sObject> start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        List<Pricebook2> listaPrecios = IntegrationController.getListas();
        System.debug('trae lista de precios');
        return listaPrecios;
    }
    public void execute(Database.BatchableContext bc, List<Pricebook2> records){
        // process each batch of records
        System.debug('Lists: ' + records);
        if(records.size()>0){
            Database.UpsertResult[] srList = Database.upsert(records, Pricebook2.ExternalId__c, false);
            System.debug('Insertó lista de precios');
            
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
        }
        
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        IntegrationBatchPricebookEntry ibpbe = new IntegrationBatchPricebookEntry();
        Database.executeBatch(ibpbe);
        System.debug('Llama a batch pricebook entry');
    }
}