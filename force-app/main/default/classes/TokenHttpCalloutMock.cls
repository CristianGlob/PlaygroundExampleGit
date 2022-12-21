global class TokenHttpCalloutMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        request.setEndpoint('callout:MediaAssociatesAPI/token');
        response.setBody('{'+'\"token\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NjQ4ODgyNTksImV4cCI6MTY2NDg5MTg1OX0.jZpd8_ySqxWrZFaYtmHs5DXro3tzxfr1lcG9WdR0nps\"'+'}');
        response.setStatusCode(200);
        return response;
    }
}