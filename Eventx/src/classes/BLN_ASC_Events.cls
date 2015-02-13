/***********************************************************************************************
*   Service Name : BLN_ASC_Events
*   Date            : 
*   Author          : 
*   Purpose         : 
*  Modified BY:ARINDAM,referred custom setting for getting site value,09-01-2015
************************************************************************************************/
  

@RestResource(urlMapping='/BLN_ASC_Events/*')

global class BLN_ASC_Events{
global static List<Container> ct {get ; set ;}
global static profile_info ct1 {get ; set ;}
global static List<Countries_info> ct4 {get ; set;}
global static List<UpcomingEvents> ct3 {get ; set ;}
global static List<ItemType_info> ct2 {get ; set ;}
global static maincontainer MC {get ; set ;}
global static string uemailid {get ; set ;}

//global static BLN_UserEvents EventsList {get ; set ;}

@HttpPost  

    global static maincontainer  doPost(){ 
    
    Force_com_Site_Url__c siteSettings = Force_com_Site_Url__c.getInstance('SiteURL');
        String siteurl=siteSettings.Site_Url__c;
     
     RestRequest req = RestContext.request; 
     ct = new List<Container> ();
     ct3 = new List<UpcomingEvents> ();
     ct4 = new List<Countries_info> ();
     mc = new maincontainer ();
     String Uid = req.params.get('User_id');
     String appname = req.params.get('appname');
        system.debug(':::::::::::::::'+Uid);
     User U = [select Email from User where id =: uid];
      uemailid = U.Email;
      //EventsList = new BLN_UserEvents();
      //EventsList.uid = Uid;
      //EventsList.uemailid = uemailid ;
      system.debug(':::::::::::::::'+uemailid );
     // EventsList.listOfEvents();
       //FOR getting all countries and respected states
       List<Country__c> Countries = [Select id,Long_Name__c,(SELECT id,Short_Name__c,Long_Name__c FROM State__r) FROM Country__c];
       //List<Country__c> Countries = [Select id,Long_Name__c FROM Country__c];
       for(Country__c cou : Countries ){
        
        ct4.add(new Countries_info(cou,cou.State__r));
       }
       
        list<UC_Role__c> UCRoles = new list<UC_Role__c> ();
        list<UC_Role__c> UCRoles1 = new list<UC_Role__c> ();
        list<BLN_Event__c> EventsList = new list<BLN_Event__c> ();
        list<BLN_Event__c> EventsList1 = new list<BLN_Event__c> ();
        LIST<id> ids = new LIST<id> ();
        BLN_Events_BAL eventsBAL = new BLN_Events_BAL();
        EventsList = eventsBAL.listOfEvents(uid);
        for(BLN_Event__c BLS : EventsList){
            ids.add(bls.id);
        }
                                       
        Map<string,BLN_Event__c> EventsMap = new Map<string,BLN_Event__c>();
        SET<BLN_Event__c> EventsSet = new SET<BLN_Event__c> ();
        BLN_Gnuser_DAO GNDAO = new BLN_Gnuser_DAO ();
        GN_User__c GNUSER = GNDAO.existingGnuser(uemailid);
        LIST<Ticket__c> tics = [SELECT id,Event__c FROM Ticket__c WHERE Client_GN_User__r.id =: GNUSER.id];
        for(BLN_Event__c BLS : EventsList1 ){
              EventsSet.add(BLS);

        }
        
         for(Ticket__c GNTICS : tics){
              ids.add(GNTICS.Event__c);
        }
        LIST<BLN_Event__c> ListofEvents = [SELECT  Name,Venue_Name__c,ZipCode__c, Website_Url__c,  User_Company__c,organizer_id__r.Name,
                                        Twitter_URL__c, Twitter_Hash_Tag__c, Time_Zone__c, Street2__c, Street1__c,  
                                        Start_Time__c, Start_Date__c, Social_Hashtag__c,Phone_Number__c, Password__c, 
                                        PO_Box__c, Organizer_Email__c,Logo_URL__c, IsDeleted, Id, 
                                        Facebook_URL__c, Event_Type__c, Event_Topic__c, Event_Status__c, Event_Privacy__c, End_Time__c, End_Date__c, 
                                         Description__c,BLN_Country__r.Short_Name__c,BLN_Country__r.Long_Name__c,City__c ,
                                        BLN_State__c,BLN_State__r.Long_Name__c,BLN_State__r.Short_Name__c,BLN_State__r.Country__c,BLN_State__r.Country__r.Long_Name__c,BLN_State__r.Country__r.Short_Name__c,Show_Terms_Checkbox__c, 
                                        Tax_Rate__c,Accept_Tax_Rate__c,organizer_id__c,Terms_Conditions__c,Accept_Terms_Conditions__c,Accept_Refund_Policy__c,Refund_Policy__c, LinkedIn_URL__c,Event_Blog_URL__c 
                                        ,(select  Name From BadgeTemplate_Styles__r Where Mobile_Default_Badge__c = true ),(select id,name,Event__c,Table_Name__c,Column_Name__c,Label_Name__c,Setting_Type__c,Included__c from Reg_Settings__r where Table_Name__c='Item_Type__c' and Included__c=true and Setting_Type__c='Mobile') 
            ,(Select id,Pay_Gateway__c from Event_Pay_Gateway__r  ) FROM BLN_Event__c WHERE id IN : ids AND Event_Status__c != 'Deleted'];
                                   
         for(BLN_Event__c event : ListofEvents ){
         EventsSet.add(event);
         
         }
        UCRoles    = eventsBAL.roles(uid);
        SET<id> eidset = new set<id> ();
        for(UC_Role__c UR : UCRoles){
        if(eidset.add(UR.Event__r.id)){
        UCRoles1.add(UR);    
        
        }
        
        
        }
        system.debug('mmmmmmmmmmmmmmmmmmmmmmmm'+EventsList );
        string orgid = UserInfo.getOrganizationId();
        system.debug('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn222');
        List<BLN_Event__c> evslist= new List<BLN_Event__c> ();
            if(appname != 'Eventdex'){
             
            for(BLN_Event__c evs : EventsSet){
            SET<ID> UCREVID = new SET<ID>();
            for(UC_Role__c uu: UCRoles){            
                if(uu.Company__r.id == evs.organizer_id__r.id){
                if(UCREVID.add(uu.Event__c)){
                    evslist.add(evs); 
                    //for(BLN_BadgeTemplate_Styles__c bb: evs.BadgeTemplate_Styles__r){ 
                                    
                    ct.add(new Container(evs,uu.RoleId__r.Name,evs.organizer_id__r.Name,evs.BLN_Country__r.Long_Name__c,evs.BLN_State__r.Long_Name__c,URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id='+evs.Logo_URL__c+'&oid='+orgid,siteurl+'/BLN_Registrationnew?id='+evs.id));
                    //}
                    }
                }      
            }       
        }
       }else{
       SET<ID> UCREVID = new SET<ID>();
        for(BLN_Event__c evs : ListofEvents){
             
            for(UC_Role__c uu: UCRoles){            
                if(uu.Event__r.id == evs.id){
                if(UCREVID.add(uu.Event__c)){
                    evslist.add(evs); 
                    //for(BLN_BadgeTemplate_Styles__c bb: evs.BadgeTemplate_Styles__r){  
                    
                    List<Hash_Tag__c> t=[select id,Tag_Text__c,Event__c from Hash_Tag__c where Event__c=:evs.id];
                    
                    //                
                    ct.add(new Container(evs,uu.RoleId__r.Name,evs.organizer_id__r.Name,evs.BLN_Country__r.Long_Name__c,evs.BLN_State__r.Long_Name__c,URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id='+evs.Logo_URL__c+'&oid='+orgid,siteurl+'/BLN_Registrationnew?id='+evs.id));
                   // }
                    }
                }      
            }       
        }
        LIST<BLN_Event__c> ListofEventsupcoming = [SELECT  Name,Venue_Name__c,ZipCode__c, Website_Url__c,  User_Company__c,organizer_id__r.Name,
                                        Twitter_URL__c, Twitter_Hash_Tag__c, Time_Zone__c, Street2__c, Street1__c,  
                                        Start_Time__c, Start_Date__c, Social_Hashtag__c,Phone_Number__c, Password__c, 
                                        PO_Box__c, Organizer_Email__c,Logo_URL__c, IsDeleted, Id, 
                                        Facebook_URL__c, Event_Type__c, Event_Topic__c, Event_Status__c, Event_Privacy__c, End_Time__c, End_Date__c, 
                                         Description__c,BLN_Country__r.Short_Name__c,BLN_Country__r.Long_Name__c,City__c ,
                                        BLN_State__c,BLN_State__r.Long_Name__c,BLN_State__r.Short_Name__c,BLN_State__r.Country__c,BLN_State__r.Country__r.Long_Name__c,BLN_State__r.Country__r.Short_Name__c,Show_Terms_Checkbox__c, 
                                        Tax_Rate__c,Accept_Tax_Rate__c,organizer_id__c,Terms_Conditions__c,Accept_Terms_Conditions__c,Accept_Refund_Policy__c,Refund_Policy__c, LinkedIn_URL__c,Event_Blog_URL__c 
                                       ,(select  Name From BadgeTemplate_Styles__r ),(select id,name,Event__c,Table_Name__c,Column_Name__c,Label_Name__c,Setting_Type__c,Included__c from Reg_Settings__r where Table_Name__c='Item_Type__c' and Included__c=true and Setting_Type__c='Mobile') 
,(Select id,Pay_Gateway__c from Event_Pay_Gateway__r  ) FROM BLN_Event__c WHERE id NOT IN : ids AND Event_Status__c != 'Deleted'];
         
       for(BLN_Event__c evs: ListofEventsupcoming ){
       
                    
       
       ct3.add(new UpcomingEvents(evs,evs.BLN_Country__r.Long_Name__c,evs.BLN_State__r.Long_Name__c,URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id='+evs.Logo_URL__c+'&oid='+orgid,siteurl+'/BLN_Registrationnew?id='+evs.id));
       }
       
       
       }
      
       ct1 = new profile_info();
       GN_User__c gnuserpro= gndao.gettinggnuser(uid);
         system.debug('::::::::::::::::::::::Profile:::::::::::::::'+gnuser);
         ct1.profile = gnuserpro;
         ct1.profileimage = 'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id='+gnuserpro.User_Pic__c+'&oid='+orgid;
         ct1.profilestate = gnuserpro.State__r.Long_Name__c;
         ct1.profilecountry = gnuserpro.Country__r.Long_Name__c;
          ct1.Userid = uid;
     system.debug('::::::::::::::::::::::Profile:::::::::::::::'+ct1);
     
     //For geetting Item types of a default event
     ct2 = new List<ItemType_info>();
     List<Event_Price__c> Eprice = [Select id,Name,Item_type__r.id,Item_type__r.name from Event_Price__c Where Event__r.name =: 'Default Event(Boothleads)' ];
     
     for(Event_Price__c ep: Eprice){
     system.debug('::::::::::::::::Type1::::::::::::'+ep.Item_type__r.name);
      system.debug('::::::::::::::::Type2::::::::::::'+ep.Item_type__r.id);
     ct2.add(new ItemType_info(ep.Item_type__r.name,ep.Item_type__r.id));
     
     }
     
     //ct.add(ct1);
     mc.ItemTypes =ct2;
     mc.Events = ct;
     mc.Profile = ct1;
     mc.UpcomingEvents =ct3;
     mc.CountriesList = ct4;
     return mc;
    }

     
global class Container{
    
        public BLN_Event__c Events {get ; set ;}
        public string roles {get ; set ;}
        public List<BLN_Event__c> ListofEvents {get ; set ;}
        public string state{get ; set ;}
        public string country{get ; set ;}
        public string image{get ; set ;}
        public string company {get ; set ;}
        public GN_User__c Profile{get ; set ;}
        public string profileimage{get ; set ;}
        public string profilestate{get ; set ;}
        public string profilecountry{get ; set ;}
        public String RegistrationLink{get;set;}
     
        //public string BadgeName {get ; set ;}
        
        public Container(BLN_Event__c ev,string rl,string com,string cu,string st,string img,String reglink){
        Events = ev;
        roles = rl;
        country = cu;
        state = st;
        image = img;
        company = com;
        this.RegistrationLink=reglink;
        
        //BadgeName = Bname;
        
        }
        public container(){}
       
         
        
        }
        
     global class profile_info{
     public GN_User__c Profile{get ; set ;}
     public string Userid {get ; set ;}
     public string profileimage{get ; set ;}
     public string profilestate{get ; set ;}
     public string profilecountry{get ; set ;}

        
     }
     global class Countries_info{
      public Country__c Country = new Country__c();
        public LIST<State__c> States {get ; set ;}
     public Countries_info(){
     
     }
     public Countries_info(Country__c Country1 , LIST<State__c> States1){
     Country.id = Country1.id ;
     Country.Long_Name__c = Country1.Long_Name__c ;
     States = States1;
     }
        
        
     }
     global class ItemType_info{
     
     public string ItemType {get ; set ;}
     public string ItemType_Id {get ; set ;}
     public ItemType_info(string ItemType1,string ItemType_Id1){
     
     ItemType = ItemType1;
     ItemType_Id = ItemType_Id1;
     
     }
     public ItemType_info(){}
     }
     
     global class UpcomingEvents{
        public BLN_Event__c Events {get ; set ;}
        public string roles {get ; set ;}
        public string state{get ; set ;}
        public string country{get ; set ;}
        public string image{get ; set ;}
        public string company {get ; set ;}
         public String RegistrationLink{get;set;}
         
     
     public UpcomingEvents(BLN_Event__c ev,string cu,string st,string img,String reglink){
        Events = ev;   
        country = cu;
        state = st;
        image = img;
         this.RegistrationLink=reglink;
        
     
      }
       public UpcomingEvents(){
       
       }
     }  
        
     global class maincontainer{
     public list<container> Events {get ; set ;}
     public profile_info Profile {get ; set ;}
     public List<ItemType_info> ItemTypes {get ; set ;}
     public List<UpcomingEvents> UpcomingEvents {get ; set ;}
     public List<Countries_info> CountriesList {get ; set ;}
    
     public maincontainer(){
     Events = new list<container>();
     ItemTypes = new List<ItemType_info>();
     UpcomingEvents = new List<UpcomingEvents>();
     CountriesList = new List<Countries_info>();
     
     
     }
     
     
     }
     
     
    
       
}


        /**EventsList1 = [SELECT  Name, Venue_Name__c,ZipCode__c, Website_Url__c,  User_Company__c,organizer_id__r.Name,
                                        Twitter_URL__c, Twitter_Hash_Tag__c, Time_Zone__c, Street2__c, Street1__c,  
                                        Start_Time__c, Start_Date__c, Social_Hashtag__c,Phone_Number__c, Password__c, 
                                        PO_Box__c, Organizer_Email__c,Logo_URL__c, IsDeleted, Id, 
                                        Facebook_URL__c, Event_Type__c, Event_Topic__c, Event_Status__c, Event_Privacy__c, End_Time__c, End_Date__c, 
                                         Description__c,BLN_Country__r.Short_Name__c,BLN_Country__r.Long_Name__c,City__c ,
                                        BLN_State__c,BLN_State__r.Long_Name__c,BLN_State__r.Short_Name__c,BLN_State__r.Country__c,BLN_State__r.Country__r.Long_Name__c,BLN_State__r.Country__r.Short_Name__c,Show_Terms_Checkbox__c, 
                                        Tax_Rate__c,Accept_Tax_Rate__c,organizer_id__c,Terms_Conditions__c,Accept_Terms_Conditions__c,Accept_Refund_Policy__c,Refund_Policy__c, LinkedIn_URL__c, Event_Blog_URL__c 
                                       FROM BLN_Event__c WHERE id IN : evids ];
                                       */