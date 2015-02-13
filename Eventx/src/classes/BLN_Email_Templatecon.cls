public with sharing class BLN_Email_Templatecon {

    public LIST<EmailCampaign__c> ecamps {get ; set ;}
    public LIST<Emailtemplate> Etemplates {get ; set ;}
    public string selectedeventid {get ; set ;}
    public BLN_UtillDisplayLinks myemaildashboards {get;set;} 
    public BLN_Event__c eventslist {get;set;}
    public boolean editbool {get ; set ;} 
    
    public BLN_Email_Templatecon (){
    
     Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){
     selectedeventid = k.getValue();
     }
     
      myemaildashboards = new BLN_UtillDisplayLinks();
         myemaildashboards .isemailsPage='active';
         myemaildashboards .isregistrationPageExpand='expand';
         myemaildashboards .tablabel='Email Dashboard';
         try{
         myemaildashboards .eventName = eventslist.Name;
         }catch(exception e){}
         myemaildashboards .EventId= selectedeventid;
         myemaildashboards .userPermissions(userInfo.getUserId(),selectedeventid);
       
         
         alltemplates();
   }
   
   
    public void alltemplates(){
    
    ecamps = new LIST<EmailCampaign__c> ();
    Etemplates = new LIST<Emailtemplate> ();
    ecamps = [SELECT id,name,CampEmailTemplate__c from EmailCampaign__c where Event__c =: selectedeventid];
    Set<string> tempset = new set<string>();
        for(EmailCampaign__c ecam : ecamps){        
            tempset.add(ecam.CampEmailTemplate__c);        
        }
    
    Etemplates = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true and id IN :tempset];

    }
    
    public void edittemp(){
    
    
    
    
    
    }


}