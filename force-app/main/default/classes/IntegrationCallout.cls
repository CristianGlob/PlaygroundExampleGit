public with sharing class IntegrationCallout {
    public static String retrieveToken() {
            Web_Service_Setting__mdt wss = [
                SELECT User__c, Token__c, Password__c 
                FROM Web_Service_Setting__mdt 
                WHERE DeveloperName = 'Service_Settings'
                LIMIT 1
            ];

            String user = wss.User__c;
            String password = wss.Password__c;

            HttpRequest request = new HttpRequest();
            String postBody = '{"user":"' + user + '","pass":"' + password + '"}';
            request.setBody(postBody);
            request.setHeader('Content-Type', 'application/json');
            request.setEndpoint('callout:MediaAssociatesAPI/token');
            request.setMethod('POST');
            HttpResponse response = new Http().send(request);
            wrapperToken tokenfilter = (wrapperToken)System.JSON.deserialize(response.getBody(), wrapperToken.class);
            System.debug('token pruebaaa :  '+ tokenfilter.token);
            return tokenfilter.token;
    }

    public class wrapperToken{
        public String token{get;set;}
    }

    public static List<Product2> makeGetCalloutProducts() {
        String token = retrieveToken();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setEndPoint('callout:MediaAssociatesAPI/productos');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        List<IntegrationWrapper.Producto> productos = IntegrationWrapper.parseProducto(response.getBody());
        System.debug('cantidad =' + productos.size());

        List<Product2> products = new List<Product2>();
        

        for (IntegrationWrapper.Producto aproducto :productos){
            Product2 product = new Product2();
            product.ProductCode = aproducto.Codigo;
            product.Description = aproducto.Descripcion;
            product.Name = aproducto.Nombre;
            product.External_ID__c = aproducto.id;
            product.IsActive = true;
            products.add(product);
        }
        System.debug('productos: ' + products);
        return products;
    }

    public static List<Pricebook2> makeGetCalloutPricebook() {
        String token = retrieveToken();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + token);
        request.setEndPoint('callout:MediaAssociatesAPI/listas');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        List<IntegrationWrapper.Lista> listas = IntegrationWrapper.parseLista(response.getBody());
        System.debug('listas'+listas);

        List<Pricebook2> priceLists = new List<Pricebook2>();
        

        for (IntegrationWrapper.Lista lista : listas) {
            Pricebook2 priceList = new Pricebook2();
            priceList.Name = lista.Name;
            priceList.ExternalId__c = lista.Id; 
            priceList.IsActive = true;
            priceLists.add(priceList);           
        }
        
        System.debug('priceLists: ' + priceLists);
        return priceLists;
    }
    
    public static List<PricebookEntry> makeGetCalloutPrice() {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer '+ retrieveToken());
        request.setEndPoint('callout:MediaAssociatesAPI/precios');
        request.setMethod('GET');
        System.debug('DEBUG'+request);
        System.debug(request.getBody());
        System.debug(request.getHeader('Authorization'));
        System.debug(request.getEndpoint());
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        List<IntegrationWrapper.Precio> precios = IntegrationWrapper.parsePrecio(response.getBody());
        System.debug('precios'+precios.size());
        List<PricebookEntry> prices = new List<PricebookEntry>();
        for (IntegrationWrapper.Precio aprecio :precios){
            PricebookEntry price = new PricebookEntry();
            price.ExternalId__c = String.valueOf(aprecio.id);
            price.UnitPrice = Decimal.valueof(aprecio.Precio);
            price.Price_Book_Code__c = String.valueOf(aprecio.ListaDePrecios);
            price.Product_Code_New__c = String.valueOf(aprecio.Producto);
            price.IsActive = true;
            prices.add(price);
        }

        System.debug('prices: ' + prices);
        return prices;
    }
}