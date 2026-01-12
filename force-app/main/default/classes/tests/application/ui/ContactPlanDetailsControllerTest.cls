@IsTest
private class ContactPlanDetailsControllerTest {

    @TestSetup
    public static void setup() {
        Product2 product = new Product2(Name='Metal Plan');
        insert product;

        List<Product2> serviceProducts = new List<Product2>();
        serviceProducts.add(new Product2(Name='ATM Fee', Plan__c=product.Id));
        serviceProducts.add(new Product2(Name='Card replacement', Plan__c=product.Id));
        insert serviceProducts;
        
        Pricebook2 pricebook = new Pricebook2(Name = 'DE Pricebook', Country__c='DE', isActive=true);
        insert pricebook;

        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        pricebookEntries.add(new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id = serviceProducts[0].Id, UnitPrice=0,Fee__c=0));
        pricebookEntries.add(new PricebookEntry(Pricebook2Id=Test.getStandardPricebookId(), Product2Id = serviceProducts[1].Id, UnitPrice=0,Fee__c=0));
        pricebookEntries.add(new PricebookEntry(Pricebook2Id=pricebook.Id, Product2Id = serviceProducts[0].Id, UnitPrice=0,Fee__c=0, isActive=true));
        pricebookEntries.add(new PricebookEntry(Pricebook2Id=pricebook.Id, Product2Id = serviceProducts[1].Id, UnitPrice=5, isActive=true));
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


        Case caseRecord = new Case(ContactId=contacts[0].id);
        insert caseRecord;
    }

    @IsTest
    public static void whenLwcRetrieveCustomerDetail(){
        Case caseRecord = [SELECT Id, ContactId FROM Case LIMIT 1];

        Test.startTest();
        PlanDetailsDTO planDetails = ContactPlanDetailsController.getPlanServices(caseRecord.Id);
        Assert.areEqual(planDetails.planServices.size(), 2);
        Assert.areEqual(planDetails.planServices.get(0).priceFormatted, '-');
        Assert.areEqual(planDetails.planServices.get(0).fee, 'Free');

        Assert.areEqual(planDetails.planServices.get(1).price, 5);
        Assert.areEqual(planDetails.planServices.get(1).fee, '-');

        Assert.areEqual(planDetails.planType, 'Metal Plan');
        Test.stopTest();
    }
}