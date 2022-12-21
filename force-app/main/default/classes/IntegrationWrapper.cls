public with sharing class IntegrationWrapper {

    public class Producto {
        @AuraEnabled public String id  {get;set;}
        @AuraEnabled public String Nombre  {get;set;}
        @AuraEnabled public String Codigo {get;set;}
        @AuraEnabled public String Descripcion  {get;set;}
    }

    public class Precio {
        @AuraEnabled public String id  {get;set;}
        @AuraEnabled public String Precio  {get;set;}
        @AuraEnabled public String ListaDePrecios  {get;set;}
        @AuraEnabled public String Producto {get;set;}
    }

    public class Lista {
        @AuraEnabled public Integer Id  {get;set;}
        @AuraEnabled public String Name  {get;set;}
    }

    public static List<Producto> parseProducto(String json) {
        return (List<Producto>) System.JSON.deserialize(json, List<Producto>.class);}
        
    public static List<Precio> parsePrecio(String json) {
        System.debug('prueba: ' + json);
        return (List<Precio>) System.JSON.deserialize(json, List<Precio>.class);}
    
    public static List<Lista> parseLista(String json) {
        return (List<Lista>) System.JSON.deserialize(json, List<Lista>.class);}


}