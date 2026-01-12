@IsTest
private class ContactsTest {

    @IsTest
    public static void whenInsertContact() {

        Contact contact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Home_Country__c = 'DE'
        );

        insert contact;
        Test.startTest();
        Contact insertedContact = ContactSelector.getById(contact.Id);

        Assert.isNotNull(insertedContact.ExternalId__c);
        String uuid = insertedContact.ExternalId__c;

        Contact contactByUUID = ContactSelector.getByUUID(uuid);
        Assert.areEqual(insertedContact.Id, contactByUUID.Id);
        Test.stopTest();
    }
}