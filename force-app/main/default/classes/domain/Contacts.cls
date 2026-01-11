public with sharing class Contacts {
    public Contacts() {}

    public static String setUUID(){
        System.UUID randomUuid = System.UUID.randomUUID();
        return randomUuid.toString();
    }
}