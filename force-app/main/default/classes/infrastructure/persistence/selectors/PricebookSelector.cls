public with sharing class PricebookSelector {

    public static Pricebook2 getByCountry(String country) {
        List<Pricebook2> countryPricebook = [SELECT Id, Name, CurrencyIsoCode, Country__c FROM Pricebook2 where Country__c =: country AND isActive = true LIMIT 1];
        return (!countryPricebook.isEmpty()) ? countryPricebook[0] : null;
    }
}