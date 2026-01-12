@IsTest
public class PricebookSelectorTest {

    @TestSetup
    public static void setup(){
        Pricebook2 pricebook = new Pricebook2(Name = 'DE Pricebook', Country__c='DE', isActive=true);
        insert pricebook;
    }

    @IsTest
    public static void whenSelectPricebookByCountry() {

        Test.startTest();
        Pricebook2 pricebook = PricebookSelector.getByCountry('DE');
        Test.stopTest();

        Assert.areEqual(pricebook.Country__c, 'DE');
        Assert.areEqual(pricebook.Name, 'DE Pricebook');
    }

    @IsTest
    public static void whenSelectPricebookByCountryNotFound() {

        Test.startTest();
        Pricebook2 pricebook = PricebookSelector.getByCountry('FR');
        Test.stopTest();

        Assert.areEqual(pricebook, null);
    }
}