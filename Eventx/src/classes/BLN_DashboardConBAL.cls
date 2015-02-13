public with sharing class BLN_DashboardConBAL {
/***************************************************************
    *   Controller Name         : BLN_Dashboards
    *   Date                    : 30/10/2014 
    *   Author                  : Mythily Nagandla(mythilyn@globalnest.com)
    *   Purpose                 : This class is for Creating Dashboards.
******************************************************************/
public BLN_DashboardConBAL(){}
public AggregateResult[] paywithtics {get ; set ;}
public AggregateResult[] paymentwithticket(string selectedevent ){
  paywithtics = [SELECT count(id) c,SUM(Order__r.Order_Total__c) s,Item__r.item_name__c t FROM Order_Item__c WHERE  Item__r.Event__c =: selectedevent AND Order__r.Transaction_Status__c =: 'Completed' AND Order__r.Order_Status__c != 'Cancelled' GROUP BY Item__r.item_name__c,Item__c ];//WHERE  Item__r.Event__c =: selectedevent
 return paywithtics ; 
}


public LIST<soldticketsinn> soldinn {get ; set ;}  
    public decimal booked {get ; set ;}
    public decimal Available {get ; set ;}
    public decimal totalticsNo {get ; set ;}
    public decimal soldtics {get ; set ;}
    public decimal attendeesreig {get ; set ;}
    
    public LIST<soldticketsinn> TotalTics(string selectedevent){
        soldtics =0;
        attendeesreig =0;
        soldinn  = new LIST<soldticketsinn> ();
        LIST<BLN_Item__c> items = [SELECT id,Name,item_type__r.Name,item_name__c,price__c,item_count__c FROM BLN_Item__c WHERE Event__c =: selectedEvent ];
            MAP<string,decimal> itemsmapcount = new MAP<string,decimal> ();
            for(BLN_Item__c its : items){        
                itemsmapcount.put (its.id,its.item_count__c);
            }
            //system.debug('::::::::::::;;;ex:::::::::;'+expected);      
         
         LIST<Ticket__c> tics = [SELECT id,Item__r.id,Ticket_Status__c,Item_Type__r.Name FROM Ticket__c WHERE  Item__r.Event__c =: selectedEvent AND Order__r.Transaction_Status__c =: 'Completed' AND Order__r.Order_Status__c != 'Cancelled'];
         
         booked =0;
         available = 0;
         for(BLN_Item__c item : items){
         booked =0;
         available = 0;
             for(Ticket__c tt : tics){
                 if(tt.Item__r.id == item.id && tt.Ticket_Status__c == 'Booked' ){
                    booked ++; 
         
                 }else if(tt.Item__r.id == item.id && tt.Ticket_Status__c != 'Booked' ){
                     //available ++;
                 }        
             }
                 
             available = available + (item.item_count__c - booked);
             string typename = item.item_name__c;
             soldinn.add(new soldticketsinn(booked,available,typename));
              soldtics= soldtics+booked;   
             }
             return soldinn;
     }
     //---------------------------------------------------------
     public  AggregateResult[] paymentsresult {get ; set ;}
     public  AggregateResult[]  paymenttype( string selectedEvent){
        paymentsresult = [SELECT Payment_Mode__c p,SUM(Order__r.Order_Total__c) s FROM Payment__c WHERE Order__r.Events__c =:selectedEvent AND Order__r.Transaction_Status__c =: 'Completed' AND Order__r.Order_Status__c != 'Cancelled'  GROUP BY Payment_Mode__c];
     return paymentsresult;
     }
 
    
//INNER CLASS FOR TOTAL NO OF TICKETS Vs SOLD TICKETS REPORT 
    public class soldticketsinn {
        public String TIC {get;set;} 
        public decimal SOLD{get;set;} 
        public decimal Available{get;set;} 
        public soldticketsinn(decimal SOLD ,decimal Available,String TIC)  { 
            this.SOLD =SOLD ;
            this.Available=Available;
            this.TIC  =TIC  ;
        }
    }



}