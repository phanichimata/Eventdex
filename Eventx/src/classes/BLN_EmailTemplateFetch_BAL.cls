Public without sharing class BLN_EmailTemplateFetch_BAL{
 /***************************************************  
 Name: Mythily Nagandla
 Email Id : mythilyn@globalnest.com
 Purpose : Sending order conformation to byers and attendees
 Date : 01/09/2014 
 ****************************************************/
//VARIABLS 
    public LIST<EmailCampaign__c> EmailTempCustom {get ; set ; } // To retrieve list of custom email templates 
    public Emailtemplate EmailTempStandard {get ; set ;}// To retrieve list of standard templates
    public string TempId {get ; set ;}
//This method is used to retrieve the Email template of order conformation for a perticullar event
//Retrieve Tempate which are having event id is equal to parameter eventid from EmailCampaign__c
// And sending mails to buyer and attendees with the template
    public void fetchTemplate(String Eventid , String BuyerEmailid,LIST<MAP<string , LIST<string>>> Emailids  ){
        EmailTempCustom = new LIST<EmailCampaign__c> ();
        TempId ='';
        EmailTempCustom = [SELECT id , Name , Template_Type__c ,CampEmailTemplate__c FROM EmailCampaign__c WHERE Available_to_Use__c =: TRUE ];
            for(EmailCampaign__c EMT : EmailTempCustom ){
                IF(EMT.Name == 'Order Confirmation'){
                 TempId = EMT.CampEmailTemplate__c;                   
                }
        }
        Emailtemplate E = [SELECT id ,Name,Htmlvalue,body FROM Emailtemplate Where id =: TempId   ];
        
 }  
}