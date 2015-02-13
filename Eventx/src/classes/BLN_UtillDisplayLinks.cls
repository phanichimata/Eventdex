public class BLN_UtillDisplayLinks{
 
 public string tablabel {get;set;}
 public string eventId {get;set;}
  public string eventName {get;set;}
  
 public string isDashboardPage{get;set;}
 public string isTicketsPage{get;set;}
 public string ispromocodesPage{get;set;}
 public string issurveyPage{get;set;}
 
 // Attendee PAge
 public string isAttendeesPage{get;set;}
 public string isimportAttendeesPage{get;set;}
 public string isAttendeeSettingsPage{get;set;}
 
// Ragistration Page
 public string isregistrationPage{get;set;}
 public string isonsiteRegistrationPage{get;set;}
 public string isIframeRegSetPage{get;set;}
 public string isDispalySettingsPage{get;set;}  
 public string isDisplaySettingsPage{get;set;} 
 public string ispaymentSettingsPage{get;set;}
  
 // Seminars Page...............................
 public string isSeminorsPage{get; set;}
 public String isSeminorsPageExpand{get; set;}
 public String isTracksPage{get; set;}
 public string isroomsPage{get; set;}
 public String isSpeackersPage{get; set;}
  public String iseventschedulePage{get; set;}
  
    // Reports Page...............................
    public string isReportsPageExpand{get;set;}    
    public string isOrderReportPage{get; set;}
    public String isTicketReportPage{get; set;}
    public string isAttendeeReportPage{get; set;}
    public String isAttendeeDetailReportPage{get; set;}
    public String isPromocodeReportPage{get; set;}
    public String isSurveyQuestionReportPage{get; set;}
 // --------------------------------------------------------------------- Expand Page ------------------------------------------ 
  public string isTicketsPageExpand{get;set;}
 
 // Attendee PAge
 public string isAttendeesPageExpand{get;set;}

// Ragistration Page
 public string isregistrationPageExpand{get;set;}
 public string isemailsPage{get;set;}
 public string isemailcampaignpage {get ; set ;}
 
// ---------------------------------------------------------- End ----------------------------------------------
 
 
 // Orders Page
 public string isOrdersPage{get;set;}
 //Event Staff Page
 public string isEventsettingsExpand {get ; set ;}
 public string isEventsettings {get ; set ;}
 public string isEventsettingsPage {get ; set ;}
 public string isEventstaffPage {get ; set ;}
 public string isEventstaffsettingsPage {get ; set ;}
 
 // Booleans to display or hide according to role
    public boolean isAttendee {get;set;}
    public boolean isBoothAdmin {get;set;}
    public boolean isBoothStaff {get;set;}
    public boolean isCompanyAdmin {get;set;}
    public boolean isEventAdmin {get;set;}
    public boolean isEventStaff {get;set;}
    public boolean isMatchLeadsBuyer {get;set;}
    public boolean isMatchLeadsSeller {get;set;}
    //FOR EVENT STAFF SETTINGS
    public boolean IstickettabAvailable {get ; set ;}
    public boolean IsAttendeeTabAvailable {get ; set ;}
    public boolean IsDashboardTabAvailable {get ; set ;}
    public boolean IsRegistrationTabAvailable {get ; set ;}
    public boolean IsReportsTabAvailable {get ; set ;}
    public boolean IsSeminarTabAvailable {get ; set ;}
    public boolean IsEventSettingsTabAvailable {get ; set ;}
    public string isTicketFeeSettingsPage {get ; set ;}
      
    public LIST<Reg_Setting__c> ESsettings {get ; set ;}
       public void userPermissions(string uid , string eveid){
         ESsettings  = new LIST<Reg_Setting__c>();
          
           isEventAdmin = true; // This is temparary i am giving. In general we should use for loop which is in comment.
         
      
         system.debug('UUUUUUUUUUUUUUUU'+uid+'eeeeeeeeeeeeeeeeeeeee'+eveid);
         List<BLN_Event__c> ev = new List<BLN_Event__c> ();
         
         if(eveid != null || eveid != ''){
         ev = [select id,name,organizer_id__r.id from BLN_Event__c where id =: eveid ];
         }

         for(UC_Role__c ucRoles : [select id,RoleId__r.Name,GN_User__c,Event__c from UC_Role__c where GN_User__r.user__r.id=:uid and (Event__c = :eveid OR Event__c = : null OR Event__c = :' ')AND Company__r.id =: ev[0].organizer_id__r.id]){
            system.debug('UUUUUUUUUUUUUUUU'+ucRoles );
           
               
           // }else if(ucRoles.RoleId__r.Name=='Booth Admin' || ucRoles.RoleId__r.Name=='Booth Staff'){
              // isBoothAdmin =true;
           // } 
            //edited by Mythily from here 
            //it is for getting the settings of event staff based on role
            if(ucRoles.RoleId__r.Name == 'Full Admin' || ucRoles.RoleId__r.Name == 'Registration User' || ucRoles.RoleId__r.Name == 'Onsite Staff'){
            //IsEventstaff = true;
            //getting settings from custom setting using class BLN_StaffCustomSettings
            BLN_StaffCustomSettings seingttingscon = new BLN_StaffCustomSettings();
             Event_staff_settings__c se = seingttingscon.getstaffsettings(ucRoles.RoleId__r.Name);
                if(se.Attendee_Read__c == true){
                IsAttendeeTabAvailable = true;
                }
                if(se.Tickets_Read__c == true){
                IstickettabAvailable = true;
                }
                if(se.Dashboard_Read__c == true){
                IsDashboardTabAvailable = true;
                }
                if(se.Seminar_Read__c == true){
               IsSeminarTabAvailable = true;
                }       
            }else{
              if(ucRoles.RoleId__r.Name=='Event Admin' || ucRoles.RoleId__r.Name=='Company Admin'){
               //isEventAdmin = true;
             IsAttendeeTabAvailable = true;
             IstickettabAvailable = true;
             IsDashboardTabAvailable = true;
             IsReportsTabAvailable = true;
             IsSeminarTabAvailable = true;
             IsRegistrationTabAvailable = true;
             }
            }
         }
        
         
         
         
       }
   
   
 
 
}