@isTest
private with sharing class IntegrationBatchTest {
    @TestSetup
    static void makeData() {

        Pricebook2 standardPriceBook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
    }

    @isTest static void itShouldCreateAllTheProductsAndFieldsShouldBeEqualAsTheExpected() {

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:MediaAssociatesAPI/token', 'StaticToken');
        multimock.setStaticResource('callout:MediaAssociatesAPI/productos', 'StaticProduct');
        multimock.setStaticResource('callout:MediaAssociatesAPI/precios', 'StaticPrice');
        multimock.setStaticResource('callout:MediaAssociatesAPI/listas', 'StaticPricebook');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);

        Test.startTest();
        IntegrationBatch upsertProducts = new IntegrationBatch();
        Id batchId = Database.executeBatch(upsertProducts);
        Test.stopTest();

        List<Product2> createdProducts = [
            SELECT ProductCode, Description, Name, External_ID__c
            FROM Product2 
            LIMIT 100
        ];

        System.assertEquals(50, createdProducts.size(), 'The products were not created');
        System.assertEquals('Truffle Paste', createdProducts[0].Name, 'Name is not the expected');
        System.assertEquals('Disp fx of distal phalanx of unsp lesser toe(s), init', createdProducts[0].Description, 'Description is not the expected');
        System.assertEquals('0268-0863', createdProducts[0].ProductCode, 'ProductCode is not the expected');
        System.assertEquals('1', createdProducts[0].External_ID__c, 'ExternalId is not the expected');
    } 

    @isTest static void itShouldInsertAllTheProductsInTheStandardPricebookList() {

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:MediaAssociatesAPI/token', 'StaticToken');
        multimock.setStaticResource('callout:MediaAssociatesAPI/productos', 'StaticProduct');
        multimock.setStaticResource('callout:MediaAssociatesAPI/precios', 'StaticPrice');
        multimock.setStaticResource('callout:MediaAssociatesAPI/listas', 'StaticPricebook');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);

        Test.startTest();
        IntegrationBatch upsertProducts = new IntegrationBatch();
        Id batchId = Database.executeBatch(upsertProducts);
        Test.stopTest();

        List<PricebookEntry> productInStandardList = [
                SELECT Id, Pricebook2Id, Product2.External_ID__c 
                FROM PricebookEntry 
                WHERE Pricebook2Id =: Test.getStandardPricebookId()
                LIMIT 5000
        ];

        System.assertEquals(50, productInStandardList.size(), 'It did not insert all the products on the standard pricebook.');
    }
}