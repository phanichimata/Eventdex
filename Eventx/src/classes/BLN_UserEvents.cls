public without sharing class BLN_UserEvents {
/******************************************************************************
Page:BLN_UserEvents
Purpos         : For showing all events.This is the first page to show the User as soon as he logs in
Developer Name : Mythily Nagandla
Email Id       : mythilyn@globalnest.com
Start Date     : July 3,2014
static values  : i) noevent(), systemadmin profile id
                 ii)UpdateEvent() ,Shared document folder id
********************************************************************************/

//------------------------VARIALBEL DECLARATION-----------------------

public list<UC_Role__c> UCRoles {get ; set ;}
public User Userid {get ; set ;}
public list<BLN_Event__c> EventsList {get ; set ;}
public BLN_Event__c Eventedit {get ; set ;}
public list<Eventwrapper> wrapperEventList {get ; set ;}
public string SelectedEvent {get ; set ;}
public boolean editpopup {get ; set ;}
public string eventImageName {get ; set ;}
public blob eventImage {get ; set ;}
public document mydoc {get ; set ;}
public LIST<Country__c> country {get ; set ;}
public LIST<SelectOption> countryOptions {get ; set ;}
public LIST<SelectOption> stateOptions{get; set;}
public string selectedCountry {get ; set ;}
public string serchEvent{get;set;}



    //CONSTRUCTOR
    public BLN_UserEvents(){
    
        // Clear cookie on pageload
           Cookie counter = ApexPages.currentPage().getCookies().get('counter');
            if (counter == null) {
               counter = new Cookie('counter', '',null,-1,false);
             }
            else{
               counter = new Cookie('counter','',null,-1,false);
               system.debug('@@@@@@@@@@@@@@@@@@ ');
            }
         ApexPages.currentPage().setCookies(new Cookie[]{counter});    
        listOfEvents();
       
        
    }
  public pagereference noevent(){
    
             Cookie counter = ApexPages.currentPage().getCookies().get('counter');
             //Cookie usercookie = ApexPages.currentPage().getCookies().get('userid');
          
            if (counter == null) {
                counter = new Cookie('counter', SelectedEvent ,null,-1,false);
               
            }
            else{
             system.debug('UUUUUUUUUUUU '+SelectedEvent );
                counter = new Cookie('counter', SelectedEvent ,null,-1,false);
            }
            //usercookie = new Cookie('userid', userInfo.getUserId(),null,-1,false); 
            
             //ApexPages.currentPage().setCookies(new Cookie[]{usercookie });
             ApexPages.currentPage().setCookies(new Cookie[]{counter});
    
       Profile pro = [select id from Profile Where profile.Name =: 'System Administrator'];
      if(EventsList.size() == 0 && Userinfo.getProfileId() != pro.id){
        
        pagereference pg = new pagereference('/apex/BL_Event');
        pg.setredirect(True);
        return pg;
      }else
            return null;
    
    }
    
    public id uid {get ; set ;}
    public string uemailid  {get ; set ;}
    
    
    
    public void listOfEvents(){
        UCRoles = new list<UC_Role__c> ();
        EventsList = new list<BLN_Event__c> ();
        wrapperEventList = new List<Eventwrapper>();
        uid = Userinfo.getUserid();
        uemailid = Userinfo.getUserEmail();
        BLN_Events_BAL eventsBAL = new BLN_Events_BAL();
        
        EventsList = eventsBAL.listOfEvents(uid);
        Map<string,BLN_Event__c> EventsMap = new Map<string,BLN_Event__c>();
        SET<BLN_Event__c> EventsSet = new SET<BLN_Event__c> ();
        BLN_Gnuser_DAO GNDAO = new BLN_Gnuser_DAO ();
        GN_User__c GNUSER = GNDAO.existingGnuser(uemailid);
        LIST<Ticket__c> tics = [SELECT id,Event__c FROM Ticket__c WHERE Client_GN_User__c =: GNUSER.id];
       
        for(BLN_Event__c BLS : EventsList ){
              EventsSet.add(BLS);
         }
        
        LIST<id> ids = new LIST<id> ();
        SET<id> idset = new SET<id>();
       for(Ticket__c GNTICS : tics){
         if(idset.add(GNTICS.Event__c)){
              ids.add(GNTICS.Event__c);}
        }
        
        LIST<BLN_Event__c> ListofEvents = [SELECT is_Corporate__c, ZipCode__c, Website_Url__c, Waitlist__c, Venue_Name__c, User_Company__c,
                                        Twitter_URL__c, Twitter_Hash_Tag__c, Time_Zone__c, SystemModstamp, Street2__c, Street1__c,  
                                        Start_Time__c, Start_Date__c, Social_Hashtag__c, Show_Map__c, Phone_Number__c, Password__c, 
                                        PO_Box__c, OwnerId, Organizer_Email__c, Name, Logo_URL__c, LastModifiedById, IsDeleted, Id, Hosting_Location__c, 
                                        Facebook_URL__c, Event_Type__c, Event_Topic__c, Event_Status__c, Event_Privacy__c, End_Time__c, End_Date__c, 
                                         Description__c,BLN_Country__r.Short_Name__c,BLN_Country__r.Long_Name__c,City__c ,CreatedBy.Name ,
                                        BLN_State__c,BLN_State__r.Long_Name__c,BLN_State__r.Short_Name__c,BLN_State__r.Country__c,BLN_State__r.Country__r.Long_Name__c,BLN_State__r.Country__r.Short_Name__c,Show_Terms_Checkbox__c, 
                                        Tax_Rate__c,Accept_Tax_Rate__c,organizer_id__c,Terms_Conditions__c,Accept_Terms_Conditions__c,Accept_Refund_Policy__c,Refund_Policy__c, LinkedIn_URL__c, Language_Settings__c,Event_Blog_URL__c 
                                   FROM BLN_Event__c WHERE id IN : ids And Event_Status__c != 'Deleted' ];
                            system.debug('llllllllllllllllll'+ listOfEvents);       
         for(BLN_Event__c event : ListofEvents ){
            EventsSet.add(event);
         
         }
        UCRoles    = eventsBAL.roles(uid);
        system.debug('mmmmmmmmmmmmmmmmmmmmmmmm'+UCRoles.size());
        
        // By Phani
          SET<id> removeDupEve = new SET<id>();
            for(BLN_Event__c evs : EventsSet){
               for(UC_Role__c uu: UCRoles){
                 if( (evs.organizer_id__c == uu.Company__c && uu.RoleId__r.Name=='Company Admin') || (uu.RoleId__r.Name=='Event Admin' && uu.GN_User__r.Email__c==userInfo.getUsername() && evs.id==uu.Event__c ) ){ // For company admin 
                   if(!removeDupEve.contains(evs.id)){   
                     wrapperEventList.add(new Eventwrapper(uu,evs));
                   }
                    removeDupEve.add(evs.id); 
                 }               
               }  
            }
        
        // Ticket events for display
       for(BLN_Event__c evs : EventsSet){
         if(!removeDupEve.contains(evs.id)){
             wrapperEventList.add(new Eventwrapper(new UC_Role__c(),evs));
          }
        }
          
        /* for(BLN_Event__c evs : EventsSet){
           SET<ID> UCREVID = new SET<ID>();
            for(UC_Role__c uu: UCRoles ){
              if(UCREVID.add(uu.Event__r.id)){ 
                if((uu.Event__r.id == evs.id && uu.RoleId__r.Name=='Event Admin') || (uu.RoleId__r.Name=='Company Admin') ){
                    //if(uu.Company__c == evs.organizer_id__c){
                    wrapperEventList.add(new Eventwrapper(uu,evs));
                 }
               }  
            }       
        }
      */
    }
    
    
    
    public pagereference manageEvent(){
        SelectedEvent = ApexPages.CurrentPage().getParameters().get('EventName');
            system.debug('  EVNT NAME  '+SelectedEvent );
            Cookie counter = ApexPages.currentPage().getCookies().get('counter');
            if (counter == null) {
                counter = new Cookie('counter', SelectedEvent ,null,-1,false);
            }
            else{
                counter = new Cookie('counter', SelectedEvent ,null,-1,false);
            }
    
            ApexPages.currentPage().setCookies(new Cookie[]{counter});
            Pagereference Pg;
         Pg = new Pagereference('/apex/BLN_Dashboard');                
         return Pg ;
    
    }
    
    //Inner class for hiding the edit button of an Event based on Role
    public class Eventwrapper{
        public BLN_Event__c eventwrap {get ; set ;}
        public UC_Role__c UCRole {get ; set ;}
        public Eventwrapper(UC_Role__c ss,BLN_Event__c ev)
        {
            eventwrap = ev;
            UCRole = ss;
        }
    }
    //Edit EVENT
    public PageReference Editevent(){ 
    Eventedit  =new BLN_Event__c(); 
    SelectedEvent = ApexPages.CurrentPage().getParameters().get('EventName');
     for(BLN_Event__c evs : EventsList ){
                if(SelectedEvent == evs.id){
                Eventedit  = evs;
                }
    
    }
     countryStates();
    editpopup = TRUE;
    return new pagereference('/apex/BLN_EventNew?id='+Eventedit.id);
    }
    
    
    //Delete Event
     public PageReference deleteparamval(){
     
     Eventedit  =new BLN_Event__c(); 
    SelectedEvent = ApexPages.CurrentPage().getParameters().get('EventName');
     
     system.debug(SelectedEvent+'  SELECTED EVENT '+EventsList);
     for(BLN_Event__c evs : EventsList ){
                if(SelectedEvent == evs.id){
                Eventedit  = evs;
                }
    
    }
        deleteEvent(Eventedit.id);
         
    listOfEvents();
    
    
    return new pagereference('/apex/BLN_UserEvents');
     
     }
    public BLN_Event__c deleteEvent(id evid){ 
    
    system.debug('  EDITED EVENT '+evid);
    BLN_Events_DAO edao=new BLN_Events_DAO ();
    BLN_Event__c ble=edao.getEventDetails(evid);
    //system.debug('ssssssss'+Eventedit.id);
    ble.Event_Status__c='Deleted';
    update ble;
    return ble;
     
    }
    
    //For closing popups
    public void cancel(){
    editpopup = FALSE;
    }

    public void countryStates(){   
        country = new LIST<Country__c>();
        countryOptions= new LIST<SelectOption>();
        // countryOptions.add(new SelectOption('none' ,'Choose Country'));
        for(Country__c c: [SELECT ID, NAME, Short_Name__c, Long_Name__c FROM Country__c ])
        {
            countryOptions.add(new SelectOption(c.id, c.Long_Name__c));
        }        
        stateOptions= new LIST<SelectOption> ();
        // stateOptions.add(new SelectOption('none' ,'Choose Country'));
    statesBasedOnCountry();
    }
    
    public void statesBasedOnCountry(){    
        system.debug('STATESSSSSSSSSSSSSSSSSSS '+ selectedCountry );    
        stateOptions= new LIST<SelectOption> ();
        // stateOptions.add(new SelectOption('none' ,'Choose State'));    
        
        for(State__c s: [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c FROM State__c WHERE Country__c =: Eventedit.BLN_Country__c]){
            stateOptions.add(new SelectOption(s.id,s.Long_Name__c));
        }    
        system.debug('STATESSSSSSSSSSSSSSSSSSS '+ stateOptions);    
    }
    
    //For Update the values of an event on Edit
    public void UpdateEvent(){
        List<folder> folderList =new List<folder>();
        folderList = [select id from folder where Name =: 'Shared Documents']; 
        system.debug('ffffffffffffffff'+folderList );
         if (eventImage != NULL && (eventImageName != '' || eventImageName != NULL)) {    
             if (eventImage.size() != null) {
                 if (eventImage.size() <= 1024000) {
                     mydoc = new document();
                     mydoc.body = eventImage;
                     //if(folderList.size()>0){
                       mydoc.folderid ='00lF0000001VI7Y';
                       //}
                     mydoc.ispublic = true;
                     mydoc.Name = eventImageName;
                     insert mydoc;
                     Eventedit.Logo_URL__c = mydoc.id;
                 } else {
                     
                 }
             }
         }
    
        update Eventedit;
        editpopup = FALSE;
        listOfEvents( );
    }
    public pagereference myTickets(){
    SelectedEvent = ApexPages.CurrentPage().getParameters().get('EventName');
            system.debug('  EVNT NAME  '+SelectedEvent );
            Cookie counter = ApexPages.currentPage().getCookies().get('counter');
            if (counter == null) {
                counter = new Cookie('counter', SelectedEvent ,null,-1,false);
            }
            else{
                counter = new Cookie('counter', SelectedEvent ,null,-1,false);
            }
    
            ApexPages.currentPage().setCookies(new Cookie[]{counter});
            Pagereference Pg;
         Pg = new Pagereference('/apex/BLN_mytickets');                
         return Pg ;
    
    }
    
    
    
    
}