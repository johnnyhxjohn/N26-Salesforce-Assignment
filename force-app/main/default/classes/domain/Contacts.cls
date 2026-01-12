// TODO: Create a proper TriggerHandler to extend domain into it
public with sharing class Contacts {
    public Contacts() {}

    public static void handle() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) beforeInsert(Trigger.new);
        }
    }

    private static void beforeInsert(List<Contact> newContacts) {
        for (Contact contact : newContacts) {
            setUUID(contact);
        }
    }

    public static void setUUID(Contact contact) {
        contact.ExternalId__c = (System.UUID.randomUUID()).toString();
    }
}