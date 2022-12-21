@isTest
private with sharing class IntegrationPricebookEntryBatchTest {

    @isTest static void itShouldCreateAllThePricesAndFieldsShouldBeEqualAsTheExpected() {

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:MediaAssociatesAPI/token', 'StaticToken');
        multimock.setStaticResource('callout:MediaAssociatesAPI/productos', 'StaticProduct');
        multimock.setStaticResource('callout:MediaAssociatesAPI/listas', 'StaticPricebook');
        multimock.setStaticResource('callout:MediaAssociatesAPI/precios', 'StaticPrice');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);

        Test.startTest();
        IntegrationBatch upsertProducts = new IntegrationBatch();
        Id batchId = Database.executeBatch(upsertProducts);
        Test.stopTest();

        List<PricebookEntry> createdPrices = [
            SELECT ExternalId__c, Price_Book_Code__c, UnitPrice, Product_Code_New__c, Pricebook2Id, Product2Id, IsActive, UseStandardPrice
            FROM PricebookEntry
            WHERE IsActive = true
            ORDER BY ExternalId__c ASC
            LIMIT 1000
        ];

        System.assertEquals(100, createdPrices.size(), 'The prices were not created or there are more than expected');
        System.assertEquals('1', createdPrices[0].ExternalId__c, 'The external Id is not the expected.');
        System.assertEquals('2', createdPrices[0].Price_Book_Code__c, 'The pricebook code is not the expected.');
        System.assertEquals(115377.00, createdPrices[0].UnitPrice, 'The unit price Id is not the expected.');
        System.assertEquals('2', createdPrices[0].Product_Code_New__c, 'The product code Id is not the expected.');
        System.assertEquals(true, createdPrices[0].IsActive, 'The value is Active is not the expected.');
        System.assertEquals(false, createdPrices[0].UseStandardPrice, 'The value of UseStandardPrice is not the expected.');
    } 
}