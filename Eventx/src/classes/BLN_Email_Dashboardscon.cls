global without sharing class  BLN_Email_Dashboardscon {

  
 
  /***********************************************************************************************
    *   Controller Name         : BLN_Email_Dashboards
    *   Date                    : 08/08/2014 
    *   Author                  : Shruthi Reddy Gone
    *   Purpose                 : This class is for Creating Email Dashboards.
    **************************************************************************************************/
   public string inputValue  {get ; set ;}
   public date scheduleddate {get ; set ;}
   public string selectedeventid{get;set;}
   public string selectedtemplateval {get ; set ;}
   public string htmlbodyvalue {get;set;}
   public BLN_UtillDisplayLinks myemaildashboards {get;set;} 
   public BLN_Event__c eventslist {get;set;} 
   public List<EmailCampaign__c> emailcamplist {get;set;} 
   public List<EmailCampaign__c> anouncecmaplist{get;set;} 
   public List<EmailCampaign__c> remaindermaplist{get;set;}
   public List<EmailCampaign__c> registermaplist{get;set;}
   public List<EmailTemplate> emailtemp {get;set;}
   public List<Hash_Tag__c>  hashtagslist{get;set;} 
   public EmailCampaign__c emailcamp {get;set;} 
   public MAP<string,EmailCampaign__c> emailcampMAP {get;set;} 
   public MAP<String,EmailTemplate> emailtempMAP {get;set;} 
   public List<SelectOption> Tempnames {get;set;} 
   Public List<selectoption> viewoptionList {get;set;}
   public List<string> reciepientslist{get;set;} 
   public Boolean displaybool {get;set;} 
   public Boolean editbool{get;set;} 
   public Boolean escapebool{get;set;} 
   public string outputId {get;set;}
   public Boolean savebool {get;set;}
   public boolean scheduleBool {get ; set ;}
   public string daysbefore {get ; set ;}
   public LIST<selectoption> taglist {get ; set ;}
   public List<string> selectedtags {get ; set ;}
   public list<selectoption> fieldoptions {get;set;}
   public string selectedfield {get;set;}
   
   public void displayPermissions(){

          emailalert = false;
     Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){
     selectedeventid = k.getValue();
     }
   
     try{
     eventslist  = geteventdetails();
     }catch(exception e){}
   
    SYSTEM.DEBUG('EVENTID:' + selectedeventid );
         
         myemaildashboards = new BLN_UtillDisplayLinks();
         myemaildashboards .isemailsPage='active';
         myemaildashboards .isregistrationPageExpand='expand';
         myemaildashboards .tablabel='Email Dashboard';
         try{
         myemaildashboards .eventName = eventslist.Name;
         }catch(exception e){}
         myemaildashboards .EventId= selectedeventid;
         myemaildashboards .userPermissions(userInfo.getUserId(),selectedeventid);
            // selectedeventid = 'a0sc0000001p8Xp' ;
    }
    
    Public BLN_Email_Dashboardscon(){
    
      
     Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){
         selectedeventid = k.getValue();
     }
     
    hashtagslist  = new List<Hash_Tag__c> ();
    reciepientslist = new List<String>();
    Tempnames = new List<SelectOption>();
    viewoptionList = new List<SelectOption>();
    htmlbodyvalue = '';
    outputId = '';
    displaybool = true;
    editbool = false;
    escapebool= false;
    savebool = false;
    emailalert = false;
    allcampaigns();
 //  selectedeventid = 'a0sc0000001xuYd' ;
}

    public void allcampaigns(){
    boolean Leadretrieval = false;
    boolean Matchleads = false;
    emailcamplist = new  List<EmailCampaign__c>();
    emailcamplist = [SELECT NAME,CampEmailTemplate__c,  Product_Type__c,Available_to_Use__c,Email_Send_Date__c,CampFromEmailId__c,CampFromName__c,Template_Type__c,CreatedDate,Owner.Name,CampSubject__c,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND Event__c != NULL ORDER BY Template_Type__c];
    LIST<BLN_Item__c> items = [SELECT id,item_type__r.Name FROM BLN_Item__c Where Event__c =: selectedeventid];
        for(BLN_Item__c item : items){
            if(item.item_type__r.Name == 'Lead Retrieval'){
                Leadretrieval = true;
            }else
            if(item.item_type__r.Name == 'MatchLeads Buyer' || item.item_type__r.Name == 'MatchLeads Seller'){
                Matchleads = true;
            }
    
    
        }
     anouncecmaplist = new  List<EmailCampaign__c>();
     remaindermaplist = new  List<EmailCampaign__c>();
     registermaplist = new  List<EmailCampaign__c>();
         for(EmailCampaign__c email : emailcamplist ){
              
                 if(email.CampType__c == 'Registration email')
                {
                     
                       registermaplist.add(email); 
                     
                }
                if(email.CampType__c == 'Announcement')
                {
                  if(email.Template_Type__c == 'Standard'){
                      if((Leadretrieval == true && Matchleads == true) || email.Name == 'Invitation'){
                           anouncecmaplist.add(email);  
                          }
                          if((Leadretrieval == true && Matchleads == false) || email.Name == 'Invitation' ){
                               if(email.Product_Type__c == 'Lead Retrieval'){
                                   anouncecmaplist.add(email); 
                               }
                          }
                          if((Matchleads == true && Leadretrieval == false) || email.Name == 'Invitation' ){
                               if(email.Product_Type__c == 'MatchLeads'){
                                   anouncecmaplist.add(email); 
                               }
                          }
                      }else{
                          anouncecmaplist.add(email); 
                      }
                      
                }
                  if(email.CampType__c == 'Reminder')
                {
                  if(email.Template_Type__c == 'Standard'){
                      if((Leadretrieval == true && Matchleads == true) || email.Name == 'Reminder before the event'){
                           remaindermaplist.add(email);  
                          }
                          if((Leadretrieval == true && Matchleads == false) || email.Name == 'Reminder before the event'){
                               if(email.Product_Type__c == 'Lead Retrieval'){
                                   remaindermaplist.add(email); 
                               }
                          }
                          if((Matchleads == true && Leadretrieval == false) || email.Name == 'Reminder before the event'){
                               if(email.Product_Type__c == 'MatchLeads'){
                                  remaindermaplist.add(email); 
                               }
                          }
                    }
                else{
                    remaindermaplist.add(email);
                } 
     
             }
       }
 
     fieldoptions = new list<selectoption> {};
            fieldoptions.add(new selectoption ('--None--','--None--'));
            fieldoptions.add(new selectoption ('First Name','First Name'));
            fieldoptions.add(new selectoption ('Last Name','Last Name'));
            fieldoptions.add(new selectoption ('Company Name','Company Name'));
            fieldoptions.add(new selectoption ('Event Name','Event Name'));
            fieldoptions.add(new selectoption ('Event Logo','Event Logo'));
            
            
            
    }
    //-------------------------------------SHOW FIELDS ---------------------------------------
    public string showfied {get;set;}
    public void fetchingfieldval(){
        if(selectedfield == 'First Name'){
            showfied ='{!FirstName}';
        }
         if(selectedfield == 'Last Name'){
             showfied = '{!LastName}';
        }
         if(selectedfield == 'Company Name'){
             showfied = '{!CompanyName}';
        }
         if(selectedfield == 'Event Name'){
             showfied = '{!EventName}';
        }
        if(selectedfield == 'Event Logo'){
             showfied = '{!EventLogo}';
        }
    
    }
    
    
    // -------------------------- This method is to Retrieve Event Details.--------------------------
      
       Public BLN_Event__c geteventdetails(){
         BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
         RETURN eventslist = blneventdetailbal.eventdetails(selectedeventid);
      }
   //FOR CREATING NEW CAMPAIGN
    public List<selectoption> campaigntypelist {get ; set ;}
    public boolean newtype {get ; set ;}
    public boolean existingtype {get ; set ;}
    public string selectedcamptype {get ; set ;}
    public void createcampaign(){
    
    selectedcamptype  = '';
    campaigntypelist = new List<selectoption> ();
    campaigntypelist.add(new selectoption ('Announcement ','Announcement '));
    campaigntypelist.add(new selectoption ('Reminder','Reminder'));
    newtype = true;
    existingtype = false;
    emailcamp = new EmailCampaign__c();
      hashtagslist  = new List<Hash_Tag__c> ([SELECT ID,Name,RowId__c,Table_Name__c,Tag_Text__c,Event__c FROM Hash_Tag__c WHERE Event__c=:selectedeventid ]);
      system.debug('123222222222' +hashtagslist  );
      set<string> tagsset = new set<string>(); 
           
           for(Hash_Tag__c tags: hashtagslist  ){
                  tagsset.add(tags.Tag_Text__c); 
           }            
          system.debug('123222222222' +tagsset);
          reciepientslist = new List<String>();
          reciepientslist.addAll(tagsset);
    emailcamplist = new  List<EmailCampaign__c>();
    LIST<EmailCampaign__c> emailcampslist = [SELECT NAME,CampEmailTemplate__c,CampFromEmailId__c,Template_Body__c,CampFromName__c,Template_Type__c,Owner.Name,CampSubject__c,createdDate,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND Name != 'Order Confirmation' AND Name != 'Ticket Confirmation'];
    Tempnames = new List<SelectOption>();
            try{
            for(EmailCampaign__c EMC : emailcampslist ){
            Tempnames.add(new SelectOption(EMC.CampEmailTemplate__c,EMC.NAME));
            }
            }catch(Exception e){}
    savebool = false; 
       editbool = true;
       displaybool = true;
   
       
    }
   //EDIT CAMPAIGN
   Public Void editcamp(){
            
            emailalert = false;
            string  editcamid = Apexpages.Currentpage().getparameters().get('editcamid');
            string  selectedeventid  = Apexpages.Currentpage().getparameters().get('eventid');
              
            geteventdetails();

           System.debug('32423432 editcamid' + editcamid);
          campaigntypelist = new List<selectoption> ();
    campaigntypelist.add(new selectoption ('Announcement ','Announcement '));
    campaigntypelist.add(new selectoption ('Reminder','Reminder'));
    campaigntypelist.add(new selectoption ('Order Confirmation','Order Confirmation'));
    campaigntypelist.add(new selectoption ('Ticket Confirmation','Ticket Confirmation'));
         emailcamp = new EmailCampaign__c();
         emailcamp = [SELECT NAME,CampEmailTemplate__c,System_Template_Type__c,CampFromEmailId__c,Template_Body__c,CampFromName__c,Template_Type__c,Owner.Name,CampSubject__c,createdDate,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND id=:editcamid];
         string tempid = emailcamp.CampEmailTemplate__c;
         Emailtemplate etemp  = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND ID=: tempid ]; 
             
             if(emailcamp.CampType__c == 'Announcement ' || emailcamp.CampType__c == 'Reminder' ){
                  system.debug('dddddddddddd'+emailcamp.CampType__c);
                  selectedcamptype = emailcamp.CampType__c;
              }else{
                  system.debug('dddddddddddd'+emailcamp.CampType__c);
                  selectedcamptype = emailcamp.System_Template_Type__c;          
              }
          System.debug('32423432453' + emailcamp);
          newtype = false;
          existingtype = true;

            
            
          if(emailcamp.CampFromName__c == '' || emailcamp.CampFromName__c == NULL){
          
             emailcamp.CampFromName__c =  emailcamp.Owner.Name;
          }
          
           if(emailcamp.CampType__c == 'Registration email')
           {
             emailcamp.CampSubject__c = emailcamp.CampSubject__c.replace('{!eventname}',eventslist.Name);
           }
          

            Tempnames = new List<SelectOption>();
            try{
            Tempnames.add(new SelectOption(emailcamp.CampEmailTemplate__c,etemp.NAME));
            }catch(Exception e){}

     
      hashtagslist  = new List<Hash_Tag__c> ([SELECT ID,Name,RowId__c,Table_Name__c,Tag_Text__c,Event__c FROM Hash_Tag__c WHERE Event__c=:selectedeventid ]);
      system.debug('123222222222' +hashtagslist  );
      set<string> tagsset = new set<string>(); 
           
           for(Hash_Tag__c tags: hashtagslist  ){
                  tagsset.add(tags.Tag_Text__c); 
           }
            
          system.debug('123222222222' +tagsset);
          reciepientslist = new List<String>();
          reciepientslist.addAll(tagsset);
          system.debug('123222222222' +reciepientslist);
      
      emailcamplist = new  List<EmailCampaign__c>();
     /**emailcamplist = [SELECT NAME,CampEmailTemplate__c,Product_Type__c,Available_to_Use__c,Email_Send_Date__c,CampFromEmailId__c,CampFromName__c,Template_Type__c,CreatedDate,Owner.Name,CampSubject__c,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid ORDER BY Template_Type__c];
     boolean Leadretrieval = false;
     boolean Matchleads  = false;
     LIST<BLN_Item__c> items = [SELECT id,item_type__r.Name FROM BLN_Item__c Where Event__c =: selectedeventid];
        for(BLN_Item__c item : items){
            if(item.item_type__r.Name == 'Lead Retrieval'){
                Leadretrieval = true;
            }else
            if(item.item_type__r.Name == 'MatchLeads Buyer' || item.item_type__r.Name == 'MatchLeads Seller'){
                Matchleads = true;
            }
    
    
        }
     anouncecmaplist = new  List<EmailCampaign__c>();
     remaindermaplist = new  List<EmailCampaign__c>();
     registermaplist = new  List<EmailCampaign__c>();
         for(EmailCampaign__c email : emailcamplist ){
              
                 if(email.CampType__c == 'Registration email')
                {
                     
                       registermaplist.add(email); 
                     
                }
                if(email.CampType__c == 'Announcement')
                {
                  if(email.Template_Type__c == 'Standard'){
                      if(Leadretrieval == true && Matchleads == true){
                           anouncecmaplist.add(email);  
                          }
                          if(Leadretrieval == true && Matchleads == false){
                               if(email.Product_Type__c == 'Lead Retrieval'){
                                   anouncecmaplist.add(email); 
                               }
                          }
                          if(Matchleads == true && Leadretrieval == false){
                               if(email.Product_Type__c == 'MatchLeads'){
                                   anouncecmaplist.add(email); 
                               }
                          }
                      }else{
                          anouncecmaplist.add(email); 
                      }
                      
                }
                  if(email.CampType__c == 'Reminder')
                {
                  if(email.Template_Type__c == 'Standard'){
                      if(Leadretrieval == true && Matchleads == true){
                           remaindermaplist.add(email);  
                          }
                          if(Leadretrieval == true && Matchleads == false){
                               if(email.Product_Type__c == 'Lead Retrieval'){
                                   remaindermaplist.add(email); 
                               }
                          }
       }
       
   
       }    
      }      
     */
     allcampaigns();
       savebool = false; 
       editbool = true;
       displaybool = true;
       
       
   }
   
     Public Void cancelmethod(){
     
          editbool = false;
          displaybool = true;  
            savebool = false; 
            emailalert = false;
            scheduleBool = false;
            allcampaigns();
     }
     
    public void savecamptemp(){
    system.debug('mmmmmmmmmmmmmmmmmmmmmm');
    string  campname = Apexpages.Currentpage().getparameters().get('campname');
            string  frmname = Apexpages.Currentpage().getparameters().get('frmname');
            string  reciepients = Apexpages.Currentpage().getparameters().get('reciepients');
            string  updatetempbody = Apexpages.Currentpage().getparameters().get('updatestandardtemp');
            string  templateName = Apexpages.Currentpage().getparameters().get('tempnamenew');
             emailcamp.Name  = campname;
           emailcamp.CampFromName__c = frmname;
           emailcamp.ToList__c= reciepients ;
           System.debug('32423432453' + emailcamp);
           update emailcamp;
           //Database.update(emailcamp,false);
           
           system.debug('ssssssssssssssssssssssssssssssss'+emailcamp);
           string tempid = emailcamp.CampEmailTemplate__c;
           string sub = emailcamp.CampSubject__c;
           if(updatetempbody == ''){
           updatetempbody = null;
           }
           updtcamp(tempid,updatetempbody,sub,templateName);
            allcampaigns();
    }
    
    @future
    public static void updtcamp(string tempid,string updatetempbody,string sub,string templateName){
    EmailTemplate emailtemp1 = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND ID=: tempid];
    if(updatetempbody != null){
    emailtemp1.HtmlValue= updatetempbody; }            
    emailtemp1.Subject = sub ;
    if(templateName != null && templateName != ' '){
    emailtemp1.Name = templateName;
    
    }
    database.update(emailtemp1,false);       
    }   
     
     
     public string tempnamenew {get ; set ;}
     Public Void updatetemp(){
            
            
            system.debug('iiiiiiiiiiiiiiiiiiiiiii'+inputValue);
            system.debug('iiiiiiiiiiiiiiiiiiiiiii'+tempnamenew);
           editbool = false;
           displaybool = true;   
           savebool = true;
           emailalert = false;     
            emailcamplist = new LIST<EmailCampaign__c>();
            emailcamplist = [SELECT NAME,CampEmailTemplate__c,Available_to_Use__c,CampFromEmailId__c,CampFromName__c,Template_Type__c,CreatedDate,Owner.Name,CampSubject__c,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE  Event__c != NULL ORDER BY Template_Type__c];
            
            string  campname = Apexpages.Currentpage().getparameters().get('campname');
            string  frmname = Apexpages.Currentpage().getparameters().get('frmname');
            string  reciepients = Apexpages.Currentpage().getparameters().get('reciepients');
            string  updatetempbody = Apexpages.Currentpage().getparameters().get('updatestandardtemp');
            string  templateName = Apexpages.Currentpage().getparameters().get('tempnamenew');
            system.debug('::::::::::::::;;Temp Name::::::::::::;'+templateName );
            system.debug('232342343223 ' +updatetempbody);
                        system.debug('43546467457' +frmname);
                                    system.debug('tuytutyu43' +reciepients );
             
            
            
                                 
                                    
          if(emailcamp.Name == campname ){
          
          //if(emailcamp.Template_Type__c == 'Standard'){
          
           
            // if(updatetempbody !=''){
                     
              String devname =  emailcamp.id+selectedeventid+'_'+emailcamplist.size();         
              
               emailtemp =new List<EmailTemplate>();
            emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND ID=:emailcamp.CampEmailTemplate__c];
            System.debug('sfdasdf' + emailtemp);
              
           
             
             EmailTemplate custemailtemp =new EmailTemplate();
             custemailtemp = emailtemp[0].clone();
             //string devname2 = 'MatchLeads'+'_'+emailcamplist.size();
             custemailtemp.DeveloperName = devname.trim();
             custemailtemp.Name = templateName ;
             custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
             SET<STRING> failuremessagt = new SET<STRING>();
                system.debug('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk'+k);
                    if(!k.isSuccess()){
                        Database.Error error = k.getErrors().get(0);
                        String failedDML =Error.getMessage();             
                        failuremessagt.add(failedDML);
                  
                    }
               
                       system.debug('47687979' + failuremessagt);
             
             
               system.debug('w33453 46' + custemailtemp.Id);
               system.debug('we5r456575646' + custemailtemp.Name);
               system.debug('46556768' + reciepients);
                 
               forinsertcampaign(campname,custemailtemp.Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);   
  
             

        // } 
          
          
        /** else{
          system.debug('24235435' + emailcamp.ToList__c );
          if(emailcamp.ToList__c == null){
           emailcamp.ToList__c ='';
          }
          
          
           if(emailcamp.ToList__c == reciepients ){
           emailcamp.CampFromName__c = frmname;
           emailcamp.ToList__c= reciepients ;
           System.debug('32423432453' + emailcamp);
           Database.update(emailcamp,false);
           }
           
           else{
           
           String devname =  emailcamp.id+'_'+emailcamplist.size();         
              
               emailtemp =new List<EmailTemplate>();
               emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND ID=:emailcamp.CampEmailTemplate__c];
               System.debug('sfdasdf' + emailtemp);
              
           
             
             EmailTemplate custemailtemp =new EmailTemplate();
             custemailtemp = emailtemp[0].clone();
             custemailtemp.DeveloperName = devname.trim();
             custemailtemp.Name = templateName ;
             //custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
             SET<STRING> failuremessagt = new SET<STRING>();

                    if(!k.isSuccess()){
                        Database.Error error = k.getErrors().get(0);
                        String failedDML =Error.getMessage();             
                        failuremessagt.add(failedDML);
                  
                    }
               
                       system.debug('47687979' + failuremessagt);
             
             
               system.debug('w33453 46' + custemailtemp.Id);
               system.debug('we5r456575646' + custemailtemp.Name);
               system.debug('46556768' + reciepients);
               
               
           
               
               forinsertcampaign(custemailtemp.Name,custemailtemp.Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);   
  
             
           }
           
          
          } **/
           
           
        // }
         
         /**
         else{
        
         if(updatetempbody !=''){
         
      
         
          emailtemp =new List<EmailTemplate>();
            emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND Id =: emailcamp.CampEmailTemplate__c];
            System.debug('sfdasdf' + emailtemp);
         
             emailtemp[0].HtmlValue= updatetempbody; 
             Database.Update(emailtemp,false);
            forinsertcampaign(emailcamp.Name,emailtemp[0].Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);     
         }
         else{
          emailcamp.CampFromName__c = frmname;
           emailcamp.ToList__c= reciepients ;
           System.debug('32423432453' + emailcamp);
           if(emailcamp.CampType__c == 'Announcement ' && emailcamp.CampType__c == 'Reminder' ){
                   emailcamp.CampType__c = selectedcamptype;
               }else{
                   emailcamp.CampType__c = 'Registration email';
               }
               if(emailcamp.CampType__c == 'Registration email'){
                   system.debug('::::::::::::::::::mythily::::::;'+selectedcamptype);
                   emailcamp.System_Template_Type__c = selectedcamptype;
          
               }
           Database.update(emailcamp,false);
         
         }
         
      
         }
           
           */
           
         }
         
          else{
          
          //if(emailcamp.Template_Type__c == 'Standard')
         // {
          
          if(updatetempbody == ''){
          


             
              emailtemp =new List<EmailTemplate>();
            emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND ID=:emailcamp.CampEmailTemplate__c];
            System.debug('sfdasdf' + emailtemp);
              
             String devname =  'Leadretrival'+selectedeventid+'_'+emailcamplist.size();         
             
             EmailTemplate custemailtemp =new EmailTemplate();
             custemailtemp = emailtemp[0].clone();
             custemailtemp.DeveloperName = devname.trim();
             custemailtemp.Name = templateName ;
             custemailtemp.HtmlValue= emailtemp[0].HtmlValue;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
            system.debug('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk'+k);
                  forinsertcampaign(campname,custemailtemp.Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);   
              }
            else{
            
             emailtemp =new List<EmailTemplate>();
            emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true AND ID=:emailcamp.CampEmailTemplate__c];
            System.debug('sfdasdf' + emailtemp);
            
             String devname =  'BoothLeads'+'_'+emailcamplist.size();         
             
             
             EmailTemplate custemailtemp =new EmailTemplate();
             custemailtemp = emailtemp[0].clone();
             custemailtemp.DeveloperName = devname.trim();
             custemailtemp.Name = templateName ;
             custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
              system.debug('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk'+k);
             SET<STRING> failuremessagt = new SET<STRING>();

                    if(!k.isSuccess()){
                        Database.Error error = k.getErrors().get(0);
                        String failedDML =Error.getMessage();             
                        failuremessagt.add(failedDML);
                  
                    }
               
                       system.debug('47687979' + failuremessagt);
             
             
               system.debug('w33453 46' + custemailtemp.Id);
               system.debug('we5r456575646' + custemailtemp.Name);
               system.debug('46556768' + reciepients);
               
               
           
               
               forinsertcampaign(campname,custemailtemp.Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);   
  
            
            }  
            
            // }
          /** else{
           
           
              if(updatetempbody !=''){
              
         
                emailtemp =new List<EmailTemplate>();
                //emailcamp.CampEmailTemplate__c = emailtemp.id;
                emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE  Id =: inputvalue];
                
                System.debug('sfdasdf' + emailtemp);
         
                 emailtemp[0].HtmlValue= updatetempbody; 
                 Database.Update(emailtemp,false);
                forinsertcampaign(campname,emailtemp[0].Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);     
             }
             else{
               emailcamp.Name = campname;
               emailcamp.CampFromName__c = frmname;
               emailcamp.ToList__c= reciepients ;
               System.debug('32423432453' + emailcamp);
               Database.upsert(emailcamp,false);
             
             }
           
           }  
             **/
             
             
            SYSTEM.DEBUG('1111111111111111WSFSF' + anouncecmaplist);
           }
          
          
  
                allcampaigns();
  
               system.debug('657hgjg' + editbool);
     }
 
  public List<EmailTemplate> emailtemps {get ; set ;}
 Public Void getemailcampslist(){
     emailcamplist = new  List<EmailCampaign__c>();
     allcampaigns();
 }
   
   
   
   

      @RemoteAction
      
        global static EmailCampaign__c getcampaigninfo(String campaigntype ,string selectedeventid) {
      
          SYSTEM.DEBUG('1111111111111111WSFSF' + campaigntype);
          SYSTEM.DEBUG('rwerewrtewrt345' + selectedeventid );
          EmailCampaign__c emailcamp = new EmailCampaign__c();

          emailcamp = [SELECT NAME,CampEmailTemplate__c,CampFromEmailId__c,CampFromName__c,Owner.Name,CampSubject__c,createdDate,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND id=:campaigntype];
          System.debug('32423432453' + emailcamp);
          return emailcamp ;
      }
      
       @RemoteAction 
       global static EmailTemplate  getemailtempopts(string selectedtempid) {
        
            EmailTemplate emailtemp =new EmailTemplate();
            emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE IsActive=:true  AND ID=: selectedtempid];
            System.debug('sfdasdf' + emailtemp);
            //emailtemps.add(emailtemp);
            return emailtemp ;
               
       }
     
     
       @future 
    public static void forinsertcampaign(string campname,string custemailtemId,string EmailId,String frmname,String subject,String camptype,String event,string reciepients,string tolisttype,string selectedcamptype){
              system.debug('23436 45654' + campname);
               system.debug('32345325346456' + campname);
             
             List<EmailCampaign__c> newemailcamp = new List<EmailCampaign__c> (); 
             newemailcamp = [SELECT NAME,CampEmailTemplate__c,System_Template_Type__c,CampFromEmailId__c,CampFromName__c,Owner.Name,CampSubject__c,createdDate,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:event AND CampEmailTemplate__c=:custemailtemId];     
             if(newemailcamp .size() >0){
               newemailcamp[0].Name  = campname;
                newemailcamp[0].CampEmailTemplate__c =custemailtemId;
               newemailcamp[0].CampSubject__c = subject;
               newemailcamp[0].CampFromEmailId__c =  EmailId;
               newemailcamp[0].CampFromName__c = frmname;
               newemailcamp[0].ToList__c= reciepients ;
               newemailcamp[0].CampType__c = camptype;
              
               System.debug('32423432453' + newemailcamp );
               if(camptype == 'Registration email'){
                   system.debug('::::::::::::::::::mythily::::::;'+selectedcamptype);
                   newemailcamp[0].System_Template_Type__c = selectedcamptype;
          
               }
               Database.update(newemailcamp,false);
             }  
           else{    
            EmailCampaign__c nwemailcamp = new EmailCampaign__c (); 
             nwemailcamp.Name = campname;
             nwemailcamp.CampEmailTemplate__c =custemailtemId;
             nwemailcamp.CampFromEmailId__c =  EmailId;
             nwemailcamp.CampFromName__c = frmname;
             nwemailcamp.CampSubject__c = subject;
             nwemailcamp.CampType__c = camptype;
             nwemailcamp.Event__c = event;
             nwemailcamp.Template_Type__c = 'Custom';
             nwemailcamp.ToList__c = reciepients;
             nwemailcamp.ToListType__c = tolisttype;
              system.debug('ewr43t654365' + nwemailcamp);
                if(camptype == 'Registration email'){
                   system.debug('::::::::::::::::::mythily::::::;'+selectedcamptype);
                   nwemailcamp.System_Template_Type__c = selectedcamptype;
          
               }
               Database.SaveResult s= Database.Insert(nwemailcamp,false);
               
                SET<STRING> failuremessageset = new SET<STRING>();

                    if(!s.isSuccess()){
                        Database.Error error = s.getErrors().get(0);
                        String failedDML =Error.getMessage();             
                        failuremessageset.add(failedDML);
                  
                    }
               
                       system.debug('232434565ncb ' + failuremessageset);
     
      
            }
               
   }
   
    
   
   
   Public void campaignslist(){
               getemailcampslist();
               savebool = false;
              editbool = false;
              displaybool = true; 
              emailalert = false;
  // Pagereference pg = new Pagereference('/apex/BLN_Email_Dashboards');
   //return pg;

   }
   
   //FOR AUTO SCHEDULE
    public EmailCampaign__c ecamp {get ; set ;}
    public list<selectoption> radiooptions {get ; set ;}
    public string selectedRadio {get ; set ;}
    public void autoschedule(){
    
    savebool= false;
    taglist = new List<selectoption>();
    selectedtags = new List<string> ();
    radiooptions = new list<selectoption> ();
    
    ecamp = new EmailCampaign__c();
    scheduleBool = true;
    
    radiooptions.add(new selectoption ('Days before the event','Days before the event'));
    radiooptions.add(new selectoption ('Date','Date'));
    string  editcamid = Apexpages.Currentpage().getparameters().get('editcamid');
    string  selectedeventid  = Apexpages.Currentpage().getparameters().get('eventid');
    system.debug('::::::::::::::::::editcamid ::::::::::::::;'+editcamid );
    ecamp = [SELECT id,name, auto_schedule_Type__c,Email_Send_Date__c, ToList__c FROM EmailCampaign__c WHERE id =: editcamid];
    BLN_Event__c event = [select id,name,Start_Date__c From BLN_Event__c WHERE id =: selectedeventid ];
        if(ecamp.Email_Send_Date__c != null){ 
             Integer noOfDays = event.Start_Date__c.daysBetween(ecamp.Email_Send_Date__c);
        }
        if(ecamp.auto_schedule_Type__c != null && ecamp.auto_schedule_Type__c != ' '){
            if( ecamp.auto_schedule_Type__c == 'Days before the event'){
                selectedRadio = 'Days before the event';
                daysbool = true;
                datebool = false;
                daysbefore = string.valueOf(ecamp.Email_Send_Date__c.daysBetween(event.Start_Date__c));
            }else{
                selectedRadio = 'Date';
                datebool = true;
                daysbool = false;
                scheduleddate = ecamp.Email_Send_Date__c;
            }
            //ecamp.Email_Send_Date__c = ecamp.Email_Send_Date__c;
        }
    hashtagslist  = new List<Hash_Tag__c> ([SELECT ID,Name,RowId__c,Table_Name__c,Tag_Text__c,Event__c FROM Hash_Tag__c WHERE Event__c=:selectedeventid ]);
    system.debug('123222222222' +hashtagslist  );
    set<string> tagsset = new set<string>(); 
           
           for(Hash_Tag__c tags: hashtagslist  ){
                  tagsset.add(tags.Tag_Text__c);
                  taglist.add(new selectoption(tags.Tag_Text__c,tags.Tag_Text__c)); 
           }
     LIST<string> tolist =  new LIST<string>();
     if(ecamp.ToList__c != null && ecamp.ToList__c != ' '){
         tolist = ecamp.ToList__c.split(',');
             for(string st : tolist){
              selectedtags.add(st);
    
             }   
         }
          system.debug('123222222222' +tagsset);
          reciepientslist = new List<String>();
          reciepientslist.addAll(tagsset);
    
    }
    //SAVING SCHEDULED DATE
    public void addingschedule(){
    
    string seltag ='';
    BLN_Event__c event = [select id,name,Start_Date__c From BLN_Event__c WHERE id =: selectedeventid ];
        
        if(selectedRadio == 'Days before the event'){
            date dd = event.Start_Date__c-integer.valueOf(daysbefore);
                for(string sst:selectedtags ){
                    seltag += sst+',';
                }                 
        ecamp.Email_Send_Date__c = dd;
        }else{
            system.debug('pppppppppppppppppppppppppppppppppppppppppppp'+scheduleddate);
            ecamp.Email_Send_Date__c =scheduleddate ;
        }
        
    system.debug('pppppppppppppppppppppppppppppppppppppppppppp'+ecamp.Email_Send_Date__c);
        if(seltag != null && seltag != ' '){
            ecamp.ToList__c = seltag ;
        }
    ecamp.auto_schedule_Type__c = selectedRadio;
    update ecamp ;
    scheduleBool = false;
    allcampaigns();
    system.debug('pppppppppppppppppppppppppppppppppppppppppppp'+ecamp );
    }
    
   //FOR SENDING EMAILS NOW
   public LIST<id> emailids {get ; set ;}
   public LIST<GN_User__c> GNUSERS {get ; set ;}
   public boolean emailalert {get ; set ;}
   
   public void sendnow(){
   
   GNUSERS = new LIST<GN_User__c>();
   emailids = new LIST<id>();
   string  editcamid = Apexpages.Currentpage().getparameters().get('editcamid');
   string  selectedeventid  = Apexpages.Currentpage().getparameters().get('eventid');
   //geteventdetails();
   system.debug('::::::::::::::::editcamid::::::::::::::::;'+editcamid);
   emailcamp = new EmailCampaign__c();
   emailcamp = [SELECT NAME,CampEmailTemplate__c,CampFromEmailId__c,Template_Body__c,CampFromName__c,Template_Type__c,Owner.Name,CampSubject__c,createdDate,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE Event__c=:selectedeventid AND id=:editcamid];
   system.debug('RRRRRRRRRRRRRRRRRRRRRRRRrrrr'+emailcamp.ToList__c);
   LIST<string> taglist =  emailcamp.ToList__c.split(',');     
   Emailtemplate E = [select Body,Subject,HtmlValue,Markup from EmailTemplate Where id=: emailcamp.CampEmailTemplate__c];
   system.debug('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEe'+E);
   //LIST<ItemPool_Tag_Junction__c> ITJ = new LIST<ItemPool_Tag_Junction__c>();
   //ITJ = [SELECT id,Pool_Id__c,Tag_Id__c FROM ItemPool_Tag_Junction__c WHERE Tag_Id__r.Event__c =:selectedeventid ];
  
   //system.debug('HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHh'+ITJ );
   LIST<Ticket__c> tics = [SELECT id,Item__r.Name,Item_Pool__r.Name,Client_GN_User__c FROM Ticket__c WHERE  Event__c =:selectedeventid AND Ticket_Status__c ='Booked'];
     //if(ITJ.size() != 0){
      /* for(ItemPool_Tag_Junction__c ITJR : ITJ ){
       system.debug('::::::::::;RowId__c:::::::::::::;;;;'+ITJR.Pool_Id__c );
         if(tics.size() != 0){
           for(Ticket__c TIC : tics ){
               IF(TIC.Item_Pool__c == ITJR.Pool_Id__c){
                      emailids.add(TIC.Client_GN_User__c); 
               }
           
           }
           }
      }*/
     // }
      if(emailids.size() != 0){
    GNUSERS = [SELECT id,Email__c,First_Name__c,Last_Name__c FROM GN_User__c WHERE id IN :emailids ];
      system.debug('::::::::::::EMAIL IDS :::::::::::;;;'+emailids);
      
      //SENDING MAIL
      BLN_Event__c BLEvent = [SELECT id,name,City__c,BLN_Country__c,Venue_Name__c,Description__c,End_Date__c,End_Time__c,Hosting_Location__c,Start_Date__c,BLN_State__c,Street2__c,ZipCode__c,Website_Url__c FROM BLN_Event__c WHERE id =:selectedeventid  ];
      list <Messaging.SingleEmailMessage> emails = new List <Messaging.SingleEmailMessage> ();
        for(GN_User__c GN : GNUSERS){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] toaddress = new String[] { GN.Email__c };
            email.setToAddresses(toaddress);
            String subject = E.Subject;
            String ReplaceContactName   = E.HtmlValue;
                if(ReplaceContactName.contains('{$Lastname}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$Lastname}',GN.Last_Name__c);                   
                }
                if(ReplaceContactName.contains('{$FirstName}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$FirstName}',GN.First_Name__c);                    
                }
                if(ReplaceContactName.contains('{$username}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$username}',GN.First_Name__c+' '+GN.Last_Name__c);                    
                }
                if(ReplaceContactName.contains('{$EventName}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$EventName}',BLEvent.Name);                    
                }
                if(ReplaceContactName.contains('{$Location}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$Location}',BLEvent.Venue_Name__c);                    
                }
                if(ReplaceContactName.contains('{$company}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$company}','');                    
                }
                if(ReplaceContactName.contains('{$logo}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$logo}','<img src="https://c.cs11.content.force.com/servlet/servlet.ImageServer?id='+BLEvent.Logo_URL__c+'&oid=00DZ0000000pGvZ"'+' width="150" height="140" style=" border:0px; padding:10px; " />');                    
                }
                if(ReplaceContactName.contains('{$date}')){
                    ReplaceContactName  = ReplaceContactName.Replace('{$date}',BLEvent.Start_Date__c+' ' +BLEvent.End_Date__c);                    
                }
            email.setHtmlBody(ReplaceContactName);
            email.setSubject(subject);       
            emails.add(email);
      
       }
       
    Messaging.SendEmailResult[] r = Messaging.sendEmail(emails);
    system.debug('::::::::::::::;;EMAIL RESULT:::::::::;'+r);
    boolean check = true;
         for (Messaging.SendEmailResult ms: r) {
             check = check && ms.isSuccess();
         }
         if (check == true){
             emailalert = true;
     }  
     }
   }
   public boolean datebool {get ; set ;}
   public boolean daysbool {get ; set ;}
   public void selectradiobool(){
   if(selectedradio == 'Days before the event'){
   daysbool = true;
   datebool = false;
   }else{
   daysbool = false;
   datebool = true;
   }
   }
   public void savenewcampaign(){
   
    emailtemp =new List<EmailTemplate>();
    emailcamplist =emailcamplist = [SELECT NAME,CampEmailTemplate__c,Available_to_Use__c,CampFromEmailId__c,CampFromName__c,Template_Type__c,CreatedDate,Owner.Name,CampSubject__c,CampType__c,Event__c,ToList__c,ToListType__c FROM EmailCampaign__c WHERE  Event__c != NULL ORDER BY Template_Type__c];
    emailtemp = [SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate WHERE  Id =: inputvalue];
    string  campname = Apexpages.Currentpage().getparameters().get('campname');
    string  frmname = Apexpages.Currentpage().getparameters().get('frmname');
    string  reciepients = Apexpages.Currentpage().getparameters().get('reciepients');
    string  updatetempbody = Apexpages.Currentpage().getparameters().get('updatestandardtemp'); 
    string  templateName = Apexpages.Currentpage().getparameters().get('tempnamenew');
            system.debug('::::::::::::::;;Temp Name::::::::::::;'+templateName );
    system.debug(':::::::::::::::::::HTML BODY::::::::::::::::;;;'+updatetempbody );
    EmailTemplate custemailtemp =new EmailTemplate();
    String devname1 =  'MatchLeads'+selectedeventid+'_'+emailcamplist.size(); 
    system.debug(':::::::::::Eventdex:::::::::::::'+devname1);
             custemailtemp = emailtemp[0].clone();
             custemailtemp.DeveloperName = devname1.trim();
             custemailtemp.Name = templateName;
             custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
             system.debug(':::::::::::::saved Result::::::;;'+k);
             SET<STRING> failuremessagt = new SET<STRING>();

                    if(!k.isSuccess()){
                        Database.Error error = k.getErrors().get(0);
                        String failedDML =Error.getMessage();             
                        failuremessagt.add(failedDML);
                  
                    }
              emailcamp.Event__c = selectedeventid;      
              emailcamp.CampType__c = selectedcamptype ;      
             forinsertcampaign(campname,custemailtemp.Id,emailcamp.CampFromEmailId__c,frmname,emailcamp.CampSubject__c,emailcamp.CampType__c,emailcamp.Event__c,reciepients,emailcamp.ToListType__c,selectedcamptype);     
           system.debug('eeeeeeeeeeeeeeeeee'+emailcamp);
            editbool = false;
           displaybool = true;   
           savebool = true;
           emailalert = false;
               allcampaigns();
   }
   public void creatingnewtemplate(){
   string  newtemp = Apexpages.Currentpage().getparameters().get('newtemp');
   string  updatetempbody = Apexpages.Currentpage().getparameters().get('updatestandardtemp');
   system.debug('ssssssssssssssssssssssssssssssssss'+newtemp );
   EmailTemplate custemailtemp =new EmailTemplate();
    String devname =  'campaign'+selectedeventid+'_'+emailcamplist.size(); 
             custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.DeveloperName = devname.trim();
             custemailtemp.Name = newtemp ;
             custemailtemp.HtmlValue= updatetempbody;
             custemailtemp.IsActive = true;
             custemailtemp.FolderId = '00lF0000001Izb7';
             custemailtemp.Subject =  emailcamp.CampSubject__c;
             Database.SaveResult  k = Database.Insert(custemailtemp,false);
   }
   
    public string status {get ; set ;}
    public void activatetemp(){
    
        string ss = Apexpages.Currentpage().getparameters().get('active');
        system.debug('aaaaaaaaaaaaaaaaaa'+ss);
        EmailCampaign__c ec = [SELECT id,Name,System_Template_Type__c,CampEmailTemplate__c,Available_to_Use__c from EmailCampaign__c where id =: ss];
        if(ec.Available_to_Use__c == true){
        ec.Available_to_Use__c = false;
        status = 'inactive';
        }else{
        ec.Available_to_Use__c = true;
        status = 'active';
        }
        update ec;
        EmailTemplate e = [SELECT id,Name from EmailTemplate Where id=: ec.CampEmailTemplate__c];
        system.debug(':::::::::::::::18id::::::::::'+e.id);
        string namet = e.Name;
        LIST<EmailCampaign__c> ecs = [SELECT id,Name,System_Template_Type__c,CampEmailTemplate__c,Available_to_Use__c from EmailCampaign__c where Event__c =: selectedeventid];
        MAP<string,EmailCampaign__c> ecmap = new MAP<string,EmailCampaign__c>();
            for(EmailCampaign__c em : ecs){
                ecmap.put(em.CampEmailTemplate__c,em);
            }
        LIST<EmailTemplate> es = [SELECT id,Name from EmailTemplate Where id !=: e.id];
        LIST<EmailCampaign__c> newcamps = new LIST<EmailCampaign__c> ();
            for(EmailTemplate e1 : es){
            EmailCampaign__c ecm = ecmap.get(e1.id);   
              if(ecmap.get(e1.id) != null && ecm.System_Template_Type__c == ec.System_Template_Type__c){
              system.debug(':::::::::::;mythily1::::::::::'+ecm.System_Template_Type__c);
              EmailCampaign__c ecam =  ecmap.get(e1.id);
              ecam.Available_to_Use__c = false;
              newcamps.add(ecam);
             }
            }
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+newcamps);
        update newcamps;
      allcampaigns();
    } 
    
    public void deleteremcamp(){
    
        string renid= Apexpages.Currentpage().getparameters().get('remid');
        EmailCampaign__c ecm = [select id,CampEmailTemplate__c from EmailCampaign__c WHERE id =: renid];
        Emailtemplate e = [select id from emailtemplate WHERE id =: ecm.CampEmailTemplate__c];
        delete e;
        futuredel(ecm.id);
       // delete ecm;
    allcampaigns();
    }
    @future
    public static void futuredel(id campid){
     EmailCampaign__c ecm = [select id,CampEmailTemplate__c from EmailCampaign__c WHERE id =: campid];
     delete ecm;
    }
    
    public void CancelAction(){
        string campid = ApexPages.Currentpage().getparameters().get('cancelid');
        EmailCampaign__c ec = [SELECT id,Name,Email_Send_Date__c,System_Template_Type__c,CampEmailTemplate__c,Available_to_Use__c from EmailCampaign__c where id =: campid];
        ec.Email_Send_Date__c = null;
        ec.auto_schedule_Type__c = ' ';
        update ec;
         
        allcampaigns();
    
    }
}