public with sharing class PricebookEntrySelector {
    
    public static List<PricebookEntry> getPlanPricebookEntriesByPricebook(Id planId, Id pricebookId) {
        return [SELECT Id, Product2Id, Product2.Name, Fee__c, UnitPrice, CurrencyIsoCode FROM PricebookEntry WHERE Product2.Plan__c =: planId AND Pricebook2Id =: pricebookId AND isActive = true];
    }
}