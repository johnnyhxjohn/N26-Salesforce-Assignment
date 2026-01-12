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

    public CustomerDetailsDTO toApiResponse(Contact contact) {
        // Since we are using UUID in the API, products could also return ExternalId as UUID instead Salesforce Id
        CustomerDetailsDTO customerDetails = getCustomerPlanDetailsDTO(contact.Product__r.Name, contact.Home_Country__c);
        customerDetails.firstName = contact.FirstName;
        customerDetails.lastName = contact.LastName;
        customerDetails.email = contact.Email;
        customerDetails.uuid = contact.ExternalId__c;
        return customerDetails;
    }

    public CustomerDetailsDTO getCustomerPlanDetailsDTO(String planType, String country) {
        CustomerDetailsDTO customerDetails = new CustomerDetailsDTO();
        customerDetails.planServices = populatePlanServices();
        customerDetails.planType = planType;
        customerDetails.country = country;
        return customerDetails;
    }
    
    private List<CustomerDetailsDTO.PlanService> populatePlanServices() {
        List<CustomerDetailsDTO.PlanService> planServices = new List<CustomerDetailsDTO.PlanService>();
        for(PricebookEntry pbEntry : this.pricebookEntries) {
            CustomerDetailsDTO.PlanService planService = new CustomerDetailsDTO.PlanService();
            planService.productId = pbEntry.Product2Id;
            planService.name = pbEntry.Product2.Name;
            planService.price = pbEntry.UnitPrice;
            planService.priceFormatted = String.valueOf(pbEntry.UnitPrice) + ' ' + pbEntry.CurrencyIsoCode;
            if(pbEntry.Fee__c != null) {
                planService.fee = (pbEntry.Fee__c != 0) 
                    ? String.valueOf(pbEntry.Fee__c) + '%'
                    : 'Free';
                planService.priceFormatted = '-';
            }
            planServices.add(planService);
        }

        return planServices;
    }
}