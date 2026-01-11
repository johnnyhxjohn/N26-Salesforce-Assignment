public with sharing class CaseSelector {

    public static List<Case> getByIds(Set<Id> caseIds) {
        List<Case> cases = [SELECT ContactId, Contact.Product__c,Contact.Product__r.Name, Contact.Home_Country__c FROM Case WHERE Id IN: caseIds];
        return cases;
    }

    public static Case getById(Id caseId) {
        List<Case> cases = getByIds(new Set<Id>{caseId});
        return (!cases.isEmpty()) ? cases.get(0) : null;
    }
}