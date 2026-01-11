@IsTest
private class CustomerDetailsApiTest {

    @TestSetup
    static void setup() {
        Product2 product = new Product2(Name='Metal Plan');
        insert product;

        Product2 serviceProduct = new Product2(Name='ATM Fee', Plan__c=product.Id);
        insert serviceProduct;
        
        Pricebook2 pricebook = new Pricebook2(Name = 'DE Pricebook', Country__c='DE', isActive=true);
        insert pricebook;

        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        pricebookEntries.add(new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id = serviceProduct.Id, UnitPrice=0,Fee__c=0));
        pricebookEntries.add(new PricebookEntry(Pricebook2Id=pricebook.Id, Product2Id = serviceProduct.Id, UnitPrice=0,Fee__c=0, isActive=true));
        insert pricebookEntries;

        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Home_Country__c = 'DE',
            Product__c = product.Id,
            ExternalId__c = 'valid-uuid'
        ));

        contacts.add(new Contact(
            FirstName = 'John',
            LastName = 'No Country',
            ExternalId__c = 'no-country'
        ));

        insert contacts;
    }

    @IsTest
    static void whenContactFound() {
        Test.setMock(HttpCalloutMock.class, new ContactApiCalloutMock());

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/api/v1/customer/valid-uuid';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        CustomerDetailsApi.getContactByUUID();

        System.assertEquals(200, RestContext.response.statusCode);
        String resp = RestContext.response.responseBody.toString();
        System.assert(resp.contains('John'));
    }

    @IsTest
    static void whenContactFoundNoCountry() {
        Test.setMock(HttpCalloutMock.class, new ContactApiCalloutMock());

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/api/v1/customer/no-country';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        CustomerDetailsApi.getContactByUUID();

        System.assertEquals(200, RestContext.response.statusCode);
        String resp = RestContext.response.responseBody.toString();
        System.assert(resp.contains('No Country'));
    }

    @IsTest
    static void whenContactNotFound() {
        Test.setMock(HttpCalloutMock.class, new ContactApiCalloutMock());

        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/api/v1/customer/invalid-uuid';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        CustomerDetailsApi.getContactByUUID();

        System.assertEquals(404, RestContext.response.statusCode);
        
        String resp = RestContext.response.responseBody.toString();
        System.assert(resp.contains('CONTACT_NOT_FOUND'));
    }

    @IsTest
    static void whenMissingUUID() {
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/api/v1/customer/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        CustomerDetailsApi.getContactByUUID();

        System.assertEquals(400, RestContext.response.statusCode);

        String resp = RestContext.response.responseBody.toString();
        System.assert(resp.contains('UUID_MISSING'));
    }

    public class ContactApiCalloutMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            
            if (req.getEndpoint().contains('valid-uuid')) {
                res.setStatusCode(200);
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"id":"001xxx","firstName":"John","lastName":"Doe"}');
            } else if (req.getEndpoint().contains('no-country')) {
                res.setStatusCode(200);
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"id":"001xxx","firstName":"John","lastName":"No Country"}');
            } else {
                res.setStatusCode(404);
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"errorCode":"CONTACT_NOT_FOUND","message":"No contact found"}');
            }
            return res;
        }
    }
}
