public with sharing class BLN_GNUser_BAL {



    public GN_User__c upsertGNUser(string companyName){
        
        GN_User__c gu = new GN_User__c();
        
        //gu.Company_Name__c = companyName;
        gu.Email__c = userinfo.getUserName();
        gu.First_Name__c =  userinfo.getFirstName();
        gu.Last_Name__c = userinfo.getLastName();
        gu.User__c = userinfo.getUserId();
        
        return gu;
    }
    
    
    


}