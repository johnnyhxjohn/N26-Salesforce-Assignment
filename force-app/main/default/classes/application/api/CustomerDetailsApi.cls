@RestResource(urlMapping='/api/v1/customer/*')
global with sharing class CustomerDetailsApi {
    
    @HttpGet
    global static void getContactByUUID() {
        try{
            String uuid = extractUUID();

            if(String.isBlank(uuid)) {
                RestContext.response.statusCode = 400;
                ApiResponseFactory.writeBadRequest(ErrorCodes.UUID_MISSING);
                return;
            }

            Contact contact = ContactSelector.getByUUID(uuid);

            if (contact == null) {
                ApiResponseFactory.writeNotFound(ErrorCodes.CONTACT_NOT_FOUND);
                return;
            }

            Pricebook2 countryPricebook = (contact.Home_Country__c != null)
                ? PricebookSelector.getByCountry(contact.Home_Country__c)
                : null;
                
            List<PricebookEntry> pricebookEntries = (countryPricebook != null)
                ? PricebookEntrySelector.getPlanPricebookEntriesByPricebook(contact.Product__c, countryPricebook.Id)
                : new List<PricebookEntry>();
            
            ApiResponseFactory.writeSuccess(
                new CustomerDetailMapper(pricebookEntries).toApiResponse(contact)
            );

        } catch (Exception ex) {
            ApiResponseFactory.writeServerError(ex);
        }
    }

    // For more API's move this to an util class to be reusable
    private static String extractUUID() {
        String uri = RestContext.request.requestURI;
        return uri.substring(uri.lastIndexOf('/') + 1);
    }
}