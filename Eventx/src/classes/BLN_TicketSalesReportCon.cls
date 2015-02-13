/***********************************************************************************************
*   Controller Name : BLN_TicketSalesReportCon
*   Date            : 10/30/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the Ticket Sales Report
*   Change History  : 10/28/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*  10/30/2014            Manasa Gandham                  To Create Page
*  
**************************************************************************************************/

public with sharing class BLN_TicketSalesReportCon { 

    public BLN_TicketSalesReportCon(){
        EventDates= new BLN_Event__c();
        Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            selectedEvent= k.getValue();
           
           displayTicketSalesRepor();
        }  
        //selectedEvent ='a0sc00000031NJKAA2';
       
      
       
    }
     
    public BLN_Event__c EventDates{get; set;}
    public String selectedEvent {get; set;}
    public BLN_TicketSalesReportCon_BAL balToGetTickets{get; set;}
    public LIST<BLN_TicketSalesReportCon_BAL.ticketSalesInner> TicketsInnerList{get; set;}
    public String SearchString{get; set;}
    
    public Pagereference displayTicketSalesRepor(){
        
        balToGetTickets= new BLN_TicketSalesReportCon_BAL();
        TicketsInnerList= new LIST<BLN_TicketSalesReportCon_BAL.ticketSalesInner>();
        TicketsInnerList= balToGetTickets.ticketsSalesForEvent(selectedEvent, EventDates.Start_Date__c, EventDates.End_Date__c);
         System.debug('eeeeeeeeeeeeeeeeee'+EventDates.Start_Date__c);
      System.debug('eeeeeeeeeeeeeeeeee'+EventDates.End_Date__c);
       System.debug('eeeeeeeeeeeeeeeeee'+selectedEvent);
        System.debug('eeeeeeeeeeeeeeeeee'+SearchString);
        system.debug(TicketsInnerList.size()+'  LIST OF TICKETS '+TicketsInnerList);
        system.debug('aaaaaaaaaaaaaaaaaaaaaaaaaaaa'+balToGetTickets);
        return null;
    }
    
    
    
   /*Method for search functionality(written by thirupathi pattipaka)
    public BLN_AttendeeReportCon_BAL balToGetTicketsTemp{get; set;} 
    public LIST<LIST<Ticket__c>> listOfListTickets{get; set;} 
    public pagereference displayTicketSalesRepor(){
     
     balToGetTicketsTemp= new BLN_AttendeeReportCon_BAL();
     listOfListTickets= new LIST<LIST<Ticket__c>>();
     listOfListTickets= balToGetTicketsTemp.ticketsListForEvent(selectedEvent, EventDates.Start_Date__c, EventDates.End_Date__c, SearchString);
     return null;
     
 }*/
    
     // Exporting PromoCodes
    public pageReference exportTicketSales(){
       
        pageReference pg = page.BLN_ExportTicketSales;
        return pg;
    }
    
    public BLN_EventDetails eventInfo{get; set;}
    public PageReference printTicketSales() {
        
        BLN_Event_DAO eventDAOClass= new BLN_Event_DAO();
        eventInfo= new BLN_EventDetails();
        eventInfo.eventDetailsToDisplay(selectedEvent);
        pageReference pg = page.BLN_PrintTicketSales;
        return pg;
    }


    
    public LIST<BLN_PromoCodeReportCon_BAL.promoCodeInner> promoCodeInnerList{get; set;}
    
    
    public BLN_UtillDisplayLinks   myticket { get; set; }
    

    public boolean isEventAdmin{get;set;}
    public boolean isBoothadmin{get;set;}
  
    public PageReference hideEventsTab() {
      Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){ 
      selectedEvent = k.getValue();
       }
   
     BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
     BLN_Event__c  se = new BLN_Event__c();
      try{
    se = blneventdetailbal.eventdetails(selectedEvent );
     }catch(exception e){}
      
     myticket = new BLN_UtillDisplayLinks();


    myticket.isReportsPageExpand='expand';
    myticket.isTicketReportPage='active';
    myticket.tablabel='Ticket Sales report';
    myticket.EventId = selectedEvent ;
    
   try{
     myticket.eventName=se.NAme;
    }catch(exception e){}
     myticket.userPermissions(userInfo.getUserId(),selectedEvent);
     
        return null;
    }
    
    }