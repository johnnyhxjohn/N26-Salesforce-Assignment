@IsTest
public class ContactSelectorTest {

    @IsTest
    public static void whenSelectContactById() {
        Contact contact = new Contact(LastName='Doe', FirstName='Joe', Home_Country__c='DE', MailingCity='Seattle', MailingPostalCode='98101', MailingCountry='US', MailingState='WA');
        insert contact;

        Test.startTest();
        Contact retrievedContact = ContactSelector.getById(contact.Id);
        Test.stopTest();

        Assert.areEqual(retrievedContact.Id, contact.Id);
        Assert.areEqual(retrievedContact.Home_Country__c, contact.Home_Country__c);
    }

    @IsTest
    public static void whenSelectMultipleContactsById() {
        List<Contact> contacts = new List<Contact>{
            new Contact(LastName='Doe', FirstName='Joe', Home_Country__c='DE'),
            new Contact(LastName='Will', FirstName='John', Home_Country__c='FR'),
            new Contact(LastName='Carlsen', FirstName='Magnus', Home_Country__c='UK'),
            new Contact(LastName='John', FirstName='Joe', Home_Country__c='ES')
        };
        insert contacts;  
        
        Map<Id, Contact> contactsById = new Map<Id, Contact>(contacts);
        Test.startTest();
        List<Contact> retrievedContacts = ContactSelector.getByIds(contactsById.keySet());
        Test.stopTest();

        Assert.areEqual(retrievedContacts.size(), contacts.size());
    }
}