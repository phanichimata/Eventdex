/***********************************************************************************************
*   Controller Name : BLN_ReportsCon
*   Date            : 10/14/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the Reports
*   Change History  : 10/14/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*  10/14/2014            Manasa Gandham                  To Create Page
*  
**************************************************************************************************/

public class BLN_ReportsCon {
    
    
    public LIST<SelectOption> orderTypes{get; set;}
    public String selectedOrderType{get; set;}
    
    public BLN_ReportsCon(){
    
        orderTypes= new LIST<SelectOption>();
        orderTypes.add(new SelectOption('All', 'All'));
        orderTypes.add(new SelectOption('Successed', 'Successed'));
        orderTypes.add(new SelectOption('Cancelled', 'Cancelled'));
        selectedOrderType= 'All';
        
        balToGetOrders= new BLN_ReportsCon_BAL();
        EventDates= new BLN_Event__c();
        Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            selectedEvent= k.getValue();
            displayOrders();
        }  
        
        //selectedEvent ='a0sc0000002rKZD';
        //displayOrders();
    }
    
    public String SelectedEvent{get; set;}
    
    // Statistics Variable Declaration
    public Integer TotalTransactions{get; set;}
    public Integer TotalAttendeesRegistered{get; set;}
    public Decimal AmountThroughCheck{get; set;}
    public Decimal AmountThroughCredit{get; set;}
    public Decimal AmountThroughCash{get; set;}
    public Decimal TotalAmount{get; set;}

    public BLN_Event__c EventDates{get; set;}
    public String SearchString{get; set;}
    public LIST<LIST<Order__c>> ListOfListOrders{get; set;}    
    public BLN_ReportsCon_BAL balToGetOrders{get;set;}
    
    //public Integer OrderNumber{get; set;}
    public Integer AttendeeNumber{get; set;}
    
    public Pagereference displayOrders(){
        
        ListOfListOrders= new LIST<LIST<Order__c>>(); 
        LIST<Order__c> ListOfOrders= new LIST<Order__c>();
        LIST<Order__c> ListOfOrdersStatistics= new LIST<Order__c>();        
        ListOfOrders= balToGetOrders.ordersListForEvent(selectedEvent, EventDates.Start_Date__c, EventDates.End_Date__c, SearchString, selectedOrderType);
        system.debug(ListOfOrders.size()+'  ORDERS IN MAIN CLASS   '+ListOfOrders);
        
        
        system.debug('ooooooooooooooooo'+SearchString);
          system.debug('ooooooooooooooooor'+selectedEvent);
           system.debug('ooooooooooooooooor'+EventDates.Start_Date__c);
        
        ListOfOrdersStatistics= balToGetOrders.ordersListForSta(selectedEvent);
        TotalTransactions= ListOfOrdersStatistics.size();
        
        LIST<Ticket__c> listOfAttendees= new LIST<Ticket__c>();
        listOfAttendees= balToGetOrders.attendeesListForEvent(selectedEvent);
        TotalAttendeesRegistered= listOfAttendees.size();
        system.debug('  TOTAL ATTENDEES REGISTERED '+TotalAttendeesRegistered);
        LIST<AggregateResult> PaymentAggregateList= new LIST<AggregateResult>();
        PaymentAggregateList= balToGetOrders.PaymentForEvent(selectedEvent);
        system.debug(PaymentAggregateList.size()+'  PAYMENT AGGREGATE RESULT  '+PaymentAggregateList);
        
        TotalAmount= 0;
        paymentTypeInnerList= new LIST<paymentTypeInner>();
        for(AggregateResult payAgg: PaymentAggregateList){
            paymentTypeInnerList.add(new paymentTypeInner(String.valueOf(payAgg.get('mode')), Decimal.valueof(String.valueOf(payAgg.get('amt')))));
            TotalAmount += Decimal.valueof(String.valueOf(payAgg.get('amt')));
            /*
            if(String.valueOf(payAgg.get('mode')) == 'Check'){
                AmountThroughCheck += Decimal.valueof(String.valueOf(payAgg.get('amt')));
            }
            if(String.valueOf(payAgg.get('mode')) == 'MasterCard' || String.valueOf(payAgg.get('mode')) == 'Visa' || String.valueOf(payAgg.get('mode')) == 'Discover' || String.valueOf(payAgg.get('mode')) == 'Credit Card' || String.valueOf(payAgg.get('mode')) == 'American Express'){
                AmountThroughCredit += Decimal.valueof(String.valueOf(payAgg.get('amt')));            
            }  
            
            if(String.valueOf(payAgg.get('mode')) == 'Cash'){
                AmountThroughCash += Decimal.valueof(String.valueOf(payAgg.get('amt')));            
            }  
            */    
        }
        system.debug(paymentTypeInnerList.size()+'  PAYMENT TYPE INNER '+paymentTypeInnerList);
        system.debug(' TOTAL AMOUNT '+TotalAmount);
        //TotalAmount= AmountThroughCheck+ AmountThroughCredit+ AmountThroughCash;
        LIST<Order__c> ListOfOrders999= new LIST<Order__c>();
        for(Order__c order: ListOfOrders){
            ListOfOrders999.add(order);
            if(ListOfOrders999.size() == 999){
                ListOfListOrders.add(ListOfOrders999);
                ListOfOrders999= new LIST<Order__c>();
            }
        }
        system.debug(ListOfOrders999.size()+'  ORDERS IN CLASS 99999999  '+ListOfOrders999);        
        if(ListOfOrders999.size() != 0){
            ListOfListOrders.add(ListOfOrders999);
        }

        system.debug(ListOfListOrders.size()+'   LIST OF LIST ORDERS '+ListOfListOrders);
       
        return null;
    }
    
    // Export Orders list
    
    
    public pagereference exportOrders(){
        
        pageReference pg = page.BLN_OrdersExport;
        return pg;
    }
    
    public BLN_EventDetails eventInfo{get; set;}
    public pagereference printOrders(){
        
        BLN_Event_DAO eventDAOClass= new BLN_Event_DAO();
        eventInfo= new BLN_EventDetails();
        eventInfo.eventDetailsToDisplay(selectedEvent);
        pageReference pg = page.BLN_OrdersPrint;    
        return pg;
    
    }
    // CODE TO GET HEADER SIDE BAR AND FOOTER
    
    public BLN_UtillDisplayLinks   myticket { get; set; }
  
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
    myticket.isOrderReportPage='active';
    myticket.tablabel='Order Sales Report';
    myticket.EventId = selectedEvent ;
    
    
   try{
     myticket.eventName=se.NAme;
    }catch(exception e){}
     myticket.userPermissions(userInfo.getUserId(),selectedEvent);
     
        return null;
    }
    
    public LIST<paymentTypeInner> paymentTypeInnerList{get; set;}
    public Class paymentTypeInner{
        
        public String paymentType{get; set;}
        public Decimal paymentAmount{get; set;}
        
        public paymentTypeInner(String paymentType, Decimal paymentAmount){
            this.paymentType= paymentType;
            this.paymentAmount= paymentAmount;
        }
    
    }
}