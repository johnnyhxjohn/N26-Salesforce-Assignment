@IsTest
private class ApiResponseFactoryTest {
    
    @IsTest
    public static void writeBadRequest() {

        Test.setMock(HttpCalloutMock.class, new HttpSuccessApiCalloutMock());
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/api/v1/customer/valid-uuid';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        ApiResponseFactory.writeSuccess(new PlanDetailsDTO());
        System.assertEquals(RestContext.response.statusCode, 200);
    }

    @IsTest
    public static void whenWriteNotFound() {

        Test.setMock(HttpCalloutMock.class, new HttpErrorApiCalloutMock());
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/api/v1/customer/invalid-uuid';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        ApiResponseFactory.writeNotFound(ErrorCodes.CONTACT_NOT_FOUND);
        System.assertEquals(RestContext.response.statusCode, 404);
    }
    
    @IsTest
    public static void whenWriteServerError() {

        Test.setMock(HttpCalloutMock.class, new HttpInternalErrorApiCalloutMock());
        Test.startTest();
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/api/v1/customer/xxxxxx';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        ApiResponseFactory.writeServerError(new AuraHandledException('error'));
        System.assertEquals(RestContext.response.statusCode, 500);
    }

    class HttpSuccessApiCalloutMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"error": null,"data": {"uuid": "valid-uuid","planType": "Black Plan","planServices": [{"productId": "01tdxxx","priceFormatted": "0.00 EUR","price": 0,"name": "ATM Fee","fee": "Free"}],"lastName": "Doe","firstName": "Joe","email": null,"country": "DE"}}');
            return res;
        }
    }

    class HttpErrorApiCalloutMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            
            res.setStatusCode(404);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"error": {"message": "No contact found for the provided UUID.","errorCode": "CONTACT_NOT_FOUND","details": []},"data": null}');
            return res;
        }
    }

    class HttpInternalErrorApiCalloutMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            
            res.setStatusCode(500);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"error": {"message": "Internal error.","errorCode": "INTERNAL_ERROR","details": []},"data": null}');
            return res;
        }
    }
}