public without sharing class BLN_Company_Ext_DAO{
  /**
* @author :Manasa Gandham
* @date 10/31/2014
* @ This class is used for DML operations on Company Ext object
*/ 

    public LIST<Company_Ext__c> companyExtsForCompanyIds(SET<Id> CompanyIds){
        LIST<Company_Ext__c> companyExtsList= new LIST<Company_Ext__c>();
        companyExtsList= [SELECT Blog_URL__c, Business_Address1__c, Business_Address2__c, Business_City__c, BLN_Business_Country__r.Long_Name__c, BLN_Business_State__r.Long_Name__c, Business_Zipcode__c, Company__c, Duns_Number__c, Established_Date__c, Keywords__c, Number_Of_Employees__c, Primary_Business_Category__c, Primary_NAICS_Code__r.Description__c, Secondary_NAICS_Code__r.Description__c, Revenue__c, Secondary_Business_Category__c, Tax_Id__c, Work_Phone__c  FROM Company_Ext__c WHERE Company__c IN : CompanyIds];
        return companyExtsList;
    }
    
    
    
    public BLN_StatusMessage insertingComexts(List<Company_Ext__c> comext){
    	system.debug('QQQQQQQQQQQQQQQQQQQQQQQ '+comext);
        dataBase.saveresult[] sav = dataBase.insert(comext,false);
       
        return new BLN_StatusMessage(sav);
    }
    
}