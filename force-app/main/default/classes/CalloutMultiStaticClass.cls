public class CalloutMultiStaticClass {
    public static HttpResponse getInfoFromExternalService(String endpoint) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        if(endpoint == 'callout:MediaAssociatesAPI/token'){
            req.setMethod('POST');
        } else {
            req.setMethod('GET');
        }
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
}