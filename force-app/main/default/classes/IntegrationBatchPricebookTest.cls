@isTest
private with sharing class IntegrationBatchPricebookTest {
    @isTest static void test() {

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:MediaAssociatesAPI/token', 'StaticToken');
        multimock.setStaticResource('callout:MediaAssociatesAPI/listas', 'StaticPricebook');
        multimock.setStaticResource('callout:MediaAssociatesAPI/precios', 'StaticPrice');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);

        Test.startTest();
        IntegrationBatchPricebook upsertPricebook = new IntegrationBatchPricebook();
        Id batchId = Database.executeBatch(upsertPricebook);
        Test.stopTest();

        List<Pricebook2> createdPriceBooks = [
            SELECT ExternalId__c, Name 
            FROM Pricebook2 
        ];

        System.assertEquals(4, createdPriceBooks.size(), 'The pricebooks were not created');
        System.assertEquals(1, createdPriceBooks[0].ExternalId__c, 'ExternalId is not the expected');
        System.assertEquals('Valores Argentina', createdPriceBooks[0].Name, 'Name is not the expected');
    }
}