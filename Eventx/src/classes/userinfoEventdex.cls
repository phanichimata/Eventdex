@RestResource(urlMapping='/userinfoEventdex/*')

global without Sharing class userinfoEventdex{


 @httpPost
 global static gnuserscls doPost(){
    
         RestRequest req = RestContext.request;
         RestResponse res = RestContext.response;
         string userid;     
         userid=req.params.get('userid');
         gnuserscls gnuserDetails= new gnuserscls();
         
          GN_User__c userDetails = new GN_User__c ();
          try{
             userDetails =  [select id,First_Name__c,Last_Name__c,User__c,Address1__c,Address2__c,Age__c,City__c,Country__c,DOB__c,Eff_Date__c,Email__c,Gender__c,Home_Phone__c,Is_Active__c,Mobile__c,Zip_Code__c,User_Pic__c,State__c,Suffix__c,Prefix__c,Phone__c from GN_User__c where user__c=:userid];
             gnuserDetails.gnuser =  userDetails ;
             return gnuserDetails;
            
          }catch(exception e){
             gnuserDetails.error =  e.getMessage();
             return gnuserDetails;
          } 
           
       }
       
       
       
    global class gnuserscls{
      GN_User__c  gnuser{get;set;}
      string error{get;set;}
     }   
       
 }