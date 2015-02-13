public with sharing class BLN_Attendees_BAL {

 public BLN_Ticket_DAO tcDAo{get;set;}
 public List<inncls> inn{get;set;}
 
 //Method to get all the cancelled tickets related order 
  public List<inncls> getAllTickets(string uid,string eventId){
        tcDAo = new BLN_Ticket_DAO();
        inn= new List<inncls>();
        string status ='Cancelled';
        string ststus2 = 'Completed';
        string temp = ' where event__c = \''+eventId+'\''+' and  Ticket_Status__c != \''+status+'\''+' and order__c!=null and Client_GN_User__c!=null and order_item__c != null';
        
          temp+=' and  order__r.Order_Status__c != \''+status+'\'';
          temp+=' and  order__r.Transaction_Status__c= \''+ststus2+'\''+'order by order__c';
           
    // order by order__c
        for(Ticket__c tc : tcDao.userOrderAndTickets(temp)){
        System.debug('@@@@@@@:'+tc.Tstatus_Id__r.Tstatus_name__c);
            inn.add(new inncls(tc));
         }
         return inn;
     }

   public class inncls{
     public boolean selectCheckBox{get;set;}
     public Ticket__c ticket{get;set;}  
     public inncls(ticket__c t){
        this.ticket=t;     
     }
   }
}