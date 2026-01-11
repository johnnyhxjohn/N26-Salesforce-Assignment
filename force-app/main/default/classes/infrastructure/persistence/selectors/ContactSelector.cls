public with sharing class ContactSelector {

    public static List<Contact> getByIds(Set<Id> contactIds) {
        List<Contact> contacts = [SELECT Id, Home_Country__c, Product__c FROM Contact WHERE Id IN:contactIds];
        return contacts;
    }

    public static Contact getById(Id contactId) {
        List<Contact> contacts = getByIds(new Set<Id>{contactId});
        return (!contacts.isEmpty()) ? contacts.get(0) : null;
    }

    public static Contact getByUUID(String uuid) {
        List<Contact> contacts = [SELECT Id, ExternalId__c, Product__r.Name, Email, FirstName, LastName, AccountId, Home_Country__c, Product__c FROM Contact WHERE ExternalId__c =:uuid LIMIT 1];
        return (!contacts.isEmpty()) ? contacts.get(0) : null;
    }
}