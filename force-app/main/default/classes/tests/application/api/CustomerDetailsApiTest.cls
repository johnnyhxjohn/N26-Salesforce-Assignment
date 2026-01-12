@IsTest
private class CustomerDetailsApiTest {

    @TestSetup
    public static void setup() {
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
            Product__c = product.Id
        ));

        contacts.add(new Contact(
            FirstName = 'John',
            LastName = 'No Country'
        ));

        insert contacts;
    }

    @IsTest
    public static void whenContactFound() {

        Contact contact = [SELECT ExternalId__c FROM Contact WHERE LastName = 'Doe' LIMIT 1];
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/api/v1/customer/' + contact.ExternalId__c;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();
    
        Test.startTest();
        CustomerDetailsApi.getContactByUUID();
        System.assertEquals(200, RestContext.response.statusCode);
        
        String resp = RestContext.response.responseBody.toString();
        
        Map<String,Object> details = (Map<String,Object>) JSON.deserializeUntyped(resp);
        PlanDetailsDTO planDetails = (PlanDetailsDTO) JSON.deserialize((JSON.serialize(details.get('data'))), PlanDetailsDTO.class);

        System.assertEquals(details.get('error'), null);
        System.assertEquals(planDetails.lastName, 'Doe');
        System.assertEquals(planDetails.planServices.size(), 1);
        Test.stopTest();
    }

    @IsTest
    public static void whenContactFoundNoCountry() {
        Contact noCountryContact = [SELECT ExternalId__c FROM Contact WHERE LastName = 'No Country' LIMIT 1];
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/api/v1/customer/' + noCountryContact.ExternalId__c;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();
        
        Test.startTest();
        CustomerDetailsApi.getContactByUUID();

        System.assertEquals(200, RestContext.response.statusCode);
        
        String resp = RestContext.response.responseBody.toString();

        Map<String,Object> details = (Map<String,Object>) JSON.deserializeUntyped(resp);
        PlanDetailsDTO planDetails = (PlanDetailsDTO) JSON.deserialize((JSON.serialize(details.get('data'))), PlanDetailsDTO.class);

        System.assertEquals(details.get('error'), null);
        System.assertEquals(planDetails.lastName, 'No Country');
        System.assertEquals(planDetails.planServices.size(), 0);
        Test.stopTest();
    }

    @IsTest
    public static void whenContactNotFound() {
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/api/v1/customer/invalid-uuid';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        CustomerDetailsApi.getContactByUUID();

        System.assertEquals(404, RestContext.response.statusCode);
        
        String resp = RestContext.response.responseBody.toString();
        ApiResponseDTO details = (ApiResponseDTO) JSON.deserialize(resp, ApiResponseDTO.class);
        
        System.assertEquals(details.error.errorCode, 'CONTACT_NOT_FOUND');
        System.assertEquals(details.data, null);
    }

    @IsTest
    public static void whenMissingUUID() {
        RestRequest req = new RestRequest();
        req.requestUri = '/services/apexrest/api/v1/customer/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        CustomerDetailsApi.getContactByUUID();

        System.assertEquals(400, RestContext.response.statusCode);

        String resp = RestContext.response.responseBody.toString();
        ApiResponseDTO details = (ApiResponseDTO) JSON.deserialize(resp, ApiResponseDTO.class);

        System.assertEquals(details.error.errorCode, 'UUID_MISSING');
        System.assertEquals(details.data, null);        
    }
}
