/***********************************************************************************************
*   Controller Name : BLN_AttendeeDetailReportCon
*   Date            : 10/31/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the Attendee Detail Report
*   Change History  : 10/31/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*  10/31/2014            Manasa Gandham                  To Create Page
*  
**************************************************************************************************/

public class BLN_AttendeeDetailReportCon {
    
    public BLN_AttendeeDetailReportCon(){
        EventDates= new BLN_Event__c();
        Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            selectedEvent= k.getValue();
            displayAttendeesInDetail(); 
        }  
        //selectedEvent ='a0sc0000002rKZD';
        //displayAttendeesInDetail();
    }
    public BLN_Event__c EventDates{get; set;}   
    public BLN_UtillDisplayLinks   myticket { get; set; }
    public BLN_AttendeeDetailReport_BAL attendeeDetailReportBAL{get; set;}
    public Integer questionNumber{get; set;}
    public Integer answerNumber{get; set;}
    
    public void displayAttendeesInDetail(){
        
        attendeeDetailReportBAL= new BLN_AttendeeDetailReport_BAL();
        listOfListTickets= new LIST<LIST<BLN_AttendeeDetailReport_BAL.AttendeeDetailInner>>();
        listOfListTickets= attendeeDetailReportBAL.ticketsListForEvent(selectedEvent, EventDates.Start_Date__c, EventDates.End_Date__c, SearchString);
    }
    
    public pagereference exportAttendeesInDetail(){
    pageReference pg = page.BLN_ExportAttendeeDetail;
        return pg;

}
 public BLN_EventDetails eventInfo{get; set;}
public pagereference printAttendeesInDetail(){
BLN_Event_DAO eventDAOClass= new BLN_Event_DAO();
        eventInfo= new BLN_EventDetails();
        eventInfo.eventDetailsToDisplay(selectedEvent);
     pageReference pg = page.BLN_PrintAttendeeDetail;
        return pg;
}  


    public LIST<LIST<BLN_AttendeeDetailReport_BAL.AttendeeDetailInner>> listOfListTickets{get; set;}
    public BLN_AttendeeDetailReport_BAL balToGetTickets{get; set;}
    public String SearchString{get; set;}

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
    myticket.isAttendeeDetailReportPage='active';
    myticket.tablabel='Attendee Detail Report';
    myticket.EventId = selectedEvent ;
     
   try{
     myticket.eventName=se.NAme;
    }catch(exception e){}
     myticket.userPermissions(userInfo.getUserId(),selectedEvent);
     
        return null;
    }
    
    
}