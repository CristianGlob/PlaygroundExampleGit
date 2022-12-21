@isTest
private with sharing class IntegrationCalloutTest {
    @IsTest static void itShouldReturnAllTheProducts() {

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:MediaAssociatesAPI/token', 'StaticToken');
        multimock.setStaticResource('callout:MediaAssociatesAPI/productos', 'StaticProduct');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);
        
        Test.startTest();
        List<Product2> productos = IntegrationCallout.makeGetCalloutProducts();
        Test.stopTest();

        System.assertEquals(50, productos.size(), 'The size is not the expected');
        System.assertEquals('Truffle Paste', productos[0].Name, 'The name is not the expected');
    }

    @IsTest static void itShouldReturnAllThePricebook() {

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:MediaAssociatesAPI/token', 'StaticToken');
        multimock.setStaticResource('callout:MediaAssociatesAPI/listas', 'StaticPriceBook');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);
        
        Test.startTest();
        List<Pricebook2> listas = IntegrationCallout.makeGetCalloutPricebook();
        Test.stopTest();

        System.assertEquals(4, listas.size(), 'The size is not the expected');
        System.assertEquals('Valores Argentina', listas[0].Name, 'The name is not the expected');
    }

    @IsTest static void itShouldReturnAllThePrices() {

        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:MediaAssociatesAPI/token', 'StaticToken');
        multimock.setStaticResource('callout:MediaAssociatesAPI/precios', 'StaticPrice');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);
        
        Test.startTest();
        List<PricebookEntry> precios = IntegrationCallout.makeGetCalloutPrice();
        Test.stopTest();

        System.assertEquals(100, precios.size(), 'The size is not the expected');
        System.assertEquals(115377, precios[0].UnitPrice, 'The name is not the expected');
    }
}