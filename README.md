# N26 Salesforce Assignment
 Assignment for salesforce engineer position on N26

 Setup : 
- Setting up the data : Product2 has two record types "Plan", "Service"
- Product2 is designed to handle the Customer Plan and the service regarding the Plan
- When creating a Product and Record Type "Service" the user is able to select a "Plan" which is a lookup for a product
- Prices and Fee's are handle on Pricebooks per Country "DE Pricebook", "ES Pricebook", etc...
- Currencies are handle by the system setting up multiple currency in org level
- Contact has Home_Country__c field and Product__c
- Product__c on product must be a plan record type
- Services related to "X Plan" product have their prices handle in pricebooks
- LWC contactPlanDetails is set in Case flexipage to display customer plan details
- Custom Labels handles API responses to avoid strings and changes in the code for responses
- Trigger logic on contact on before insert to generate UUID