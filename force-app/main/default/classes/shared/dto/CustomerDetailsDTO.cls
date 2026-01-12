global with sharing class CustomerDetailsDTO {
    global String firstName;
    global String lastName;
    global String email;
    @AuraEnabled global String uuid;
    @AuraEnabled global String planType;
    @AuraEnabled global String country;
    @AuraEnabled global List<PlanService> planServices;

    public class PlanService {
        @AuraEnabled public Id productId;
        @AuraEnabled public String name;
        @AuraEnabled public String priceFormatted;
        @AuraEnabled public Decimal price;
        @AuraEnabled public String fee = '-';
    }
}