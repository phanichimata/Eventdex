/***********************************************************************************************
*   Controller Name : BLN_PromoCodeReportCon
*   Date            : 10/28/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the Promocode Report
*   Change History  : 10/28/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*  10/28/2014            Manasa Gandham                  To Create Page
*  
**************************************************************************************************/

public with sharing class BLN_PromoCodeReportCon {

  

    public BLN_PromoCodeReportCon(){
        EventDates= new BLN_Event__c();
        Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            selectedEvent= k.getValue();
            promoCodes(); 
        }  
        //selectedEvent ='a0sc0000002MUoc';
        //promoCodes(); 
    }
    
    public BLN_PromoCodeReportCon_BAL balToGetPromocodes{get; set;}
    public BLN_Event__c EventDates{get; set;} 
    public String SearchString{get; set;}

    
    public Pagereference promoCodes(){
        
        balToGetPromocodes= new BLN_PromoCodeReportCon_BAL();
        promoCodeInnerList= new LIST<BLN_PromoCodeReportCon_BAL.promoCodeInner>();
        promoCodeInnerList= balToGetPromocodes.promotionsListForEvent(selectedEvent, EventDates.Start_Date__c, EventDates.End_Date__c, SearchString);
        system.debug(promoCodeInnerList.size()+'  PROMOTIONS LIST '+promoCodeInnerList);
        return null;
    }
    
    // Exporting PromoCodes
    public pageReference exportPromotions(){
       
        pageReference pg = page.BLN_ExportPromotionsAll;
        return pg;
    }
    
     public BLN_EventDetails eventInfo{get; set;}
    public PageReference printPromotions() {
    
     BLN_Event_DAO eventDAOClass= new BLN_Event_DAO();
        eventInfo= new BLN_EventDetails();
        eventInfo.eventDetailsToDisplay(selectedEvent);
        pageReference pg = page.BLN_PrintPromotionsAll;
        return pg;
    }




    
    public LIST<BLN_PromoCodeReportCon_BAL.promoCodeInner> promoCodeInnerList{get; set;}
    
    
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
    myticket.isPromocodeReportPage='active';
    myticket.tablabel='PromoCode Report';
    myticket.EventId = selectedEvent ;
     
   try{
     myticket.eventName=se.NAme;
    }catch(exception e){}
     myticket.userPermissions(userInfo.getUserId(),selectedEvent);
     
        return null;
    }
}