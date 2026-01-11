/*
*   @desc
*   Layer responsible to map pricebook entries and customer details 
*   to PlanDetailsDTO providing informations for UI and API response
*/
public with sharing class CustomerDetailMapper {
    private List<PricebookEntry> pricebookEntries;
    
    public CustomerDetailMapper(List<PricebookEntry> pricebookEntries) {
        this.pricebookEntries = pricebookEntries;
    }

    public PlanDetailsDTO toApiResponse(Contact contact) {
        planDetails.firstName = contact.FirstName;
        planDetails.lastName = contact.LastName;
        planDetails.email = contact.Email;
        planDetails.uuid = contact.ExternalId__c;
        // Since we are using UUID in the API, products could also return ExternalId as UUID instead Salesforce Id
        PlanDetailsDTO planDetails = getCustomerPlanDetailsDTO(contact.Product__r.Name, contact.Home_Country__c);
        return planDetails;
    }

    public PlanDetailsDTO getCustomerPlanDetailsDTO(String planType, String country) {
        PlanDetailsDTO planDetails = new PlanDetailsDTO();
        planDetails.planServices = populatePlanServices();
        planDetails.planType = planType;
        planDetails.country = country;
        return planDetails;
    }
    
    private List<PlanDetailsDTO.PlanService> populatePlanServices() {
        List<PlanDetailsDTO.PlanService> planServices = new List<PlanDetailsDTO.PlanService>();
        for(PricebookEntry pbEntry : this.pricebookEntries) {
            PlanDetailsDTO.PlanService planService = new PlanDetailsDTO.PlanService();
            planService.productId = pbEntry.Product2Id;
            planService.name = pbEntry.Product2.Name;
            planService.price = pbEntry.UnitPrice;
            planService.priceFormatted = String.valueOf(pbEntry.UnitPrice) + ' ' + pbEntry.CurrencyIsoCode;
            if(pbEntry.Fee__c != null) {
                planService.fee = (pbEntry.Fee__c != 0) 
                    ? String.valueOf(pbEntry.Fee__c) + '%'
                    : 'Free';
            }
            planServices.add(planService);
        }

        return planServices;
    }
}