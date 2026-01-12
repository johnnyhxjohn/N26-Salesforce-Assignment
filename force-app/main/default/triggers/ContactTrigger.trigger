trigger ContactTrigger on Contact (before insert, after insert) {
    Contacts.handle();
}