public with sharing class SchedulableBatch implements Schedulable{
    
    public void execute(SchedulableContext sc) {
        IntegrationBatch ib = new IntegrationBatch(); 
        Database.executebatch(ib);
     }
  }