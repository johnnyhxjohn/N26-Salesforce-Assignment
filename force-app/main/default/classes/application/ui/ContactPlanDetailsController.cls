public class ContactPlanDetailsController {
    @AuraEnabled(cacheable=true)
    public static CustomerDetailsDTO getPlanServices(Id recordId) {
        Case caseObject = CaseSelector.getById(recordId);
        // To reduce amount of queries in a potential increase of scope, the pricebookEntries can be retrieve in a subquery in Pricebook query
        Pricebook2 countryPricebook = PricebookSelector.getByCountry(caseObject.Contact.Home_Country__c);
        List<PricebookEntry> pricebookEntries = PricebookEntrySelector.getPlanPricebookEntriesByPricebook(caseObject.Contact.Product__c, countryPricebook.Id);

        return new CustomerDetailMapper(pricebookEntries)
                    .getCustomerPlanDetailsDTO(caseObject.Contact.Product__r.Name, caseObject.Contact.Home_Country__c);
    }
}