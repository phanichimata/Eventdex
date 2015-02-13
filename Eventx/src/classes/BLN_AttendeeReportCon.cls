/***********************************************************************************************
*   Controller Name : BLN_AttendeeReportCon
*   Date            : 10/28/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the Attendee Report
*   Change History  : 10/28/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*  10/28/2014            Manasa Gandham                  To Create Page
*  
**************************************************************************************************/
public class BLN_AttendeeReportCon {

 public BLN_AttendeeReportCon(){
        EventDates= new BLN_Event__c();
        Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            selectedEvent= k.getValue();
            displayAttendees(); 
        }  
        //selectedEvent ='a0sc0000002rKZD';
        
 }
 
 public BLN_Event__c EventDates{get; set;}
 public pagereference displayAttendees(){
     
     balToGetTickets= new BLN_AttendeeReportCon_BAL();
     listOfListTickets= new LIST<LIST<Ticket__c>>();
     listOfListTickets= balToGetTickets.ticketsListForEvent(selectedEvent, EventDates.Start_Date__c, EventDates.End_Date__c);
    
     return null;
     
 }    
public LIST<LIST<Ticket__c>> listOfListTickets{get; set;}
public BLN_AttendeeReportCon_BAL balToGetTickets{get; set;}
public String SearchString{get; set;}

public pagereference exportAttendees(){
    pageReference pg = page.BLN_ExportTicketsAll;
        return pg;

}
public BLN_EventDetails eventInfo{get; set;}
public pagereference printAttendees(){

 BLN_Event_DAO eventDAOClass= new BLN_Event_DAO();
        eventInfo= new BLN_EventDetails();
        eventInfo.eventDetailsToDisplay(selectedEvent);
     pageReference pg = page.BLN_PrintTicketsAll;
        return pg;
}      
    
    public BLN_UtillDisplayLinks   myticket { get; set; }
    
    public String SelectedEvent{get; set;}
    public boolean isEventAdmin{get;set;}
    public boolean isBoothadmin{get;set;}
  
    public PageReference hideEventsTab() {
      Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){ 
      selectedEvent = k.getValue();
       }
   
     BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
     BLN_Event__c  se = new BLN_Event__c  ();
      try{
    se = blneventdetailbal.eventdetails(selectedEvent );
     }catch(exception e){}
      
     myticket = new BLN_UtillDisplayLinks();


     myticket.isReportsPageExpand='expand';
    myticket.isAttendeeReportPage='active';
    myticket.tablabel='Attendee Report';
    myticket.EventId = selectedEvent ;
    
   try{
     myticket.eventName=se.NAme;
    }catch(exception e){}
     myticket.userPermissions(userInfo.getUserId(),selectedEvent);
     
        return null;
    }
}