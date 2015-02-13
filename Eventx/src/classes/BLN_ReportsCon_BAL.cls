/***********************************************************************************************
*   Controller Name : BLN_ReportsCon_BAL
*   Date            : 10/14/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the Reports
*   Change History  : 10/14/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*    10/14/2014              Manasa Gandham                 To Create Page
*  
**************************************************************************************************/

public without sharing class BLN_ReportsCon_BAL{

    public BLN_ReportsCon_BAL(){
    
    }  
    
    public BLN_Order_DAO  ordersDAOClass{get; set;}
    public BLN_Ticket_DAO  ticketsDAOClass{get; set;}
    
    public LIST<Order__c> ordersListForSta(String EventId){
        String queryString='';
        queryString= ' where Events__c = \''+EventId+'\'';
        queryString += ' AND Transaction_Status__c = \''+'Completed'+'\'';
        queryString += ' AND Order_Status__c != \''+'Cancelled'+'\'';
        
        system.debug('  000000000000  '+queryString);
        LIST<Order__c> orderList= new LIST<Order__c>();
        orderList= ordersDAOClass.orderListForEvent(queryString);
        system.debug(orderList.size()+' ORDERS LIST '+orderList);
        return orderList;
     }
    public LIST<Order__c> ordersListForEvent(String EventId, Date FromDate, Date ToDate, String SearchString, String selectedOrderType){
        
        ordersDAOClass= new BLN_Order_DAO();
        ticketsDAOClass= new BLN_Ticket_DAO();
        LIST<Order__c> orderList= new LIST<Order__c>();
        system.debug(FromDate+'  FROM DATE TO DATE '+ToDate);
        system.debug('  SEARCH STRING '+SearchString);
        SET<Id> OrderIds= new SET<Id>();        
            
            LIST<LIST<Ticket__c>> ListOfTickets= new LIST<LIST<Ticket__c>>();
            LIST<Ticket__c> ticksList= new LIST<Ticket__c>();
            LIST<Ticket__c> ticksList999= new LIST<Ticket__c>();
            //ticksList= ticketsDAOClass.ticketsListForEvent(queryString);
            ticksList= ticketsDAOClass.ticketsListWithDates(EventId, SearchString, FromDate, ToDate);
            system.debug(ticksList.size()+'   TICKETS SIZE '+ticksList);
            for(Ticket__c ticket: ticksList){
                OrderIds.add(ticket.Order__c);
            }
            system.debug(OrderIds.size()+'   ORDERS  SIZE '+OrderIds);

        
       
        //orderList= ordersDAOClass.orderListForEvent(queryString);
        orderList= ordersDAOClass.orderListForEventSearch(EventId, FromDate, ToDate, SearchString, OrderIds, selectedOrderType);
        system.debug(orderList.size()+' ORDERS LIST '+orderList);
        return orderList;
    }
    
        
    public LIST<Ticket__c> attendeesListForEvent(String EventId){
        
        ticketsDAOClass= new BLN_Ticket_DAO();
        //String queryString= '';
        //queryString= ' Event__c = \''+EventId+'\'';
        //queryString += ' AND Ticket_Status__c = \''+'Booked'+'\'';
        LIST<Ticket__c> ticksList= new LIST<Ticket__c>();
        ticksList= ticketsDAOClass.ticketsListForEvent(EventId, NULL, NULL);
        
        return ticksList;
    }
    
    public BLN_Payment_DAO paymentDAOClass{get; set;}
    
    public LIST<AggregateResult> PaymentForEvent(String EventId){
    
        paymentDAOClass= new BLN_Payment_DAO();
        LIST<AggregateResult> PaymentAggregateList= new LIST<AggregateResult>(); 
        PaymentAggregateList= paymentDAOClass.paymentsForEvent(EventId);
        return PaymentAggregateList;
    }
}