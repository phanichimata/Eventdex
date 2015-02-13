/***********************************************************************************************
*   Controller Name : BLN_AttendeeReportCon_BAL
*   Date            : 10/28/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the PromoCode Report
*   Change History  : 10/28/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*    10/28/2014              Manasa Gandham                 To Create Page
*  
**************************************************************************************************/

public without sharing class BLN_AttendeeReportCon_BAL{

    public BLN_AttendeeReportCon_BAL(){
    
    }  
    public BLN_Ticket_DAO ticketsDAOClass{get; set;}
    
    public LIST<LIST<Ticket__c>> ticketsListForEvent(String EventId, Date FromDate, Date ToDate){
        
        ticketsDAOClass= new BLN_Ticket_DAO();
        
        LIST<LIST<Ticket__c>> ListOfTickets= new LIST<LIST<Ticket__c>>();
        LIST<Ticket__c> ticksList= new LIST<Ticket__c>();
        LIST<Ticket__c> ticksList999= new LIST<Ticket__c>();
        ticksList= ticketsDAOClass.ticketsListForEvent(EventId, FromDate, ToDate);
        system.debug(ticksList.size()+'   ATTENDEES FROM DATE '+FromDate+'   '+ToDate+'    '+EventId);
        for(Ticket__c tic: ticksList){
            ticksList999.add(tic);
            if(ticksList999.size() == 999){
                ListOfTickets.add(ticksList999);
                ticksList999= new LIST<Ticket__c>();
            }
        }
        if(ticksList999.size() != NULL){
            ListOfTickets.add(ticksList999);
        }
        return ListOfTickets;
        }
}