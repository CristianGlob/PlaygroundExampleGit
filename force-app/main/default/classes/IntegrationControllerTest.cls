@isTest
private class IntegrationControllerTest {
    
    @IsTest
    static void checkSizeproducts(){
        
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:MediaAssociatesAPI/token', 'StaticToken');
        multimock.setStaticResource('callout:MediaAssociatesAPI/productos', 'StaticProduct');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);
        
        Test.startTest();
        List<Product2> productos = IntegrationController.getProducts();
        Test.stopTest();
        
        System.assertEquals(50, productos.size(),'the size is not the expected');

    }

    @IsTest
    static void checkSizepricebook(){
        
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:MediaAssociatesAPI/token', 'StaticToken');
        multimock.setStaticResource('callout:MediaAssociatesAPI/listas', 'StaticPriceBook');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);
        
        Test.startTest();
        List<Pricebook2> listas = IntegrationController.getListas();
        Test.stopTest();
        
        System.assertEquals(4, listas.size(),'the size is not the expected');

    }

    @IsTest
    static void checkSizeprices(){
        
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource('callout:MediaAssociatesAPI/token', 'StaticToken');
        multimock.setStaticResource('callout:MediaAssociatesAPI/precios', 'StaticPrice');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);
        
        Test.startTest();
        List<PricebookEntry> precios = IntegrationController.getPrecios();
        Test.stopTest();
        
        System.assertEquals(100, precios.size(), 'The size is not the expected');
        System.assertEquals(115377, precios[0].UnitPrice, 'The name is not the expected');

    }
}