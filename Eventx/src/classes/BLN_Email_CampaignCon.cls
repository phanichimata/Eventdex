public with sharing class BLN_Email_CampaignCon {

//VARIABLE DECLARATION
public string selectedeventid {get ; set ;}
public BLN_UtillDisplayLinks myemaildashboards {get;set;}
public BLN_Event__c eventslist {get;set;}
public boolean displaybool {get ; set ;}
public List<EmailCampaign__c> emailcamplist {get ; set ;}
public boolean Createbool {get ; set ;}

public void displayPermissions(){
    
    Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){
            selectedeventid = k.getValue();
        }
    try{
    //eventslist  = geteventdetails();
    }catch(exception e){}  
    myemaildashboards = new BLN_UtillDisplayLinks();
    myemaildashboards .isEventAdmin= true;
    myemaildashboards .isemailcampaignpage ='active';
    myemaildashboards .isregistrationPageExpand='expand';
    myemaildashboards .tablabel='Email Campaigns';
    try{
    myemaildashboards .eventName = eventslist.Name;
    }catch(exception e){}
    myemaildashboards .EventId= selectedeventid;
    myemaildashboards .userPermissions(userInfo.getUserId(),selectedeventid);
    }
//CONSTRUCTOR    
public BLN_Email_CampaignCon(){
    Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){
         selectedeventid = k.getValue();
     }
     selectedeventid = 'a0sc0000001xtXW';
    displaybool = true;
    
    emailcamplist = new  List<EmailCampaign__c>();
    emailcamplist = [SELECT NAME,CampEmailTemplate__c,CampFromEmailId__c,CampFromName__c,Template_Type__c,CreatedDate,Owner.Name,CampSubject__c,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND Event__c != NULL ORDER BY Template_Type__c];

} 

//****CreateCampaign Method*******************
public void CreateCampaign(){
    Createbool = true;



} 
 
}