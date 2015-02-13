/**
 Author : By Phani 
 Purpose : Test class for registration page
 Date : 28/01/2015 
 */
 
@isTest
private class Test_BLN_RegistrationLinks  {

    static testMethod void myUnitTest() {
      //  BLN_ReUse_EventsEditCon  tocreateEvent = new BLN_ReUse_EventsEditCon(); 
        Test_BLN_ReUse_EventsEditCon tcon = new Test_BLN_ReUse_EventsEditCon();
        Test_BLN_ReUse_EventsEditCon.Testmethod_BLN_ReUse_EventsEditCon();
        system.debug('AAAAAAAAAAAAAAAAAAAAa '+Test_BLN_ReUse_EventsEditCon.eventid);
        pageReference pageRef = page.BLN_RegistrationLinks ;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', Test_BLN_ReUse_EventsEditCon.eventid);
        
        BLN_RegistrationLinks.isTest  = true; 
        BLN_RegistrationLinks regcon = new BLN_RegistrationLinks ();
       
    }
}