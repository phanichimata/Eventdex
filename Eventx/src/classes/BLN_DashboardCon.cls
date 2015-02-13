public with sharing class BLN_DashboardCon {
/***************************************************************
    *   Controller Name         : BLN_Dashboards
    *   Date                    : 30/10/2014 
    *   Author                  : Mythily Nagandla(mythilyn@globalnest.com)
    *   Purpose                 : This class is for Creating Dashboards.
******************************************************************/

    public BLN_UtillDisplayLinks   myticket { get; set; }
    public boolean isEventAdmin{get;set;}
    public boolean isBoothadmin{get;set;}
    public string selectedEvent{get;set;}
    
    
 //FOR SETTING PAGE DESIGN (SIDE BAR) USING COMPONENT   
    public PageReference hideEventsTab() {
    Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            selectedEvent = k.getValue();
        }
       //selectedEvent ='a0sc0000002qO9K';
    BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
    BLN_Event__c  se = new BLN_Event__c  ();
    try{
    se = blneventdetailbal.eventdetails(selectedEvent );
    }catch(exception e){}
    
    myticket = new BLN_UtillDisplayLinks();
    myticket.isDashboardPage='active';
    myticket.isEventAdmin= true;
    myticket.tablabel='Dashboard';
    myticket.eventId=selectedEvent;
    
    try{
    myticket.eventName=se.NAme;
    }catch(exception e){}
    myticket.userPermissions(userInfo.getUserId(),selectedEvent);
    return null;
    }
//CONSTRUCTOR
    public BLN_DashboardCon(){
    Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            selectedEvent = k.getValue();
        }
    getpaymentwithType();
    getpaymentwithtickettype();
    expectedrevenue();
    TotalTics();
    totalticsNo =0;
    LIST<BLN_Item__c> tics1 = [SELECT id,item_count__c FROM BLN_Item__c WHERE  Event__c =: selectedEvent];
     for(BLN_Item__c Item: tics1 ){
         totalticsNo = totalticsNo + Item.item_count__c;
     }
    registeredatt = 0;
    generated = 0;
    LIST<Order__c> ords = [SELECT id,name,Order_Total__c FROM Order__c WHERE Transaction_Status__c =: 'Completed' AND Order_Status__c != 'Cancelled' AND Events__c =: selectedevent];
      registeredatt = ords.size();
         for(Order__c ord : ords){
             generated = generated + ord.Order_Total__c; 
         }
     attendeesreig =0;
     LIST<Ticket__c> tics = [SELECT id,Item__r.id,Ticket_Status__c,Item_Type__r.Name FROM Ticket__c WHERE  Item__r.Event__c =: selectedEvent AND Order__r.Transaction_Status__c =: 'Completed' AND Order__r.Order_Status__c != 'Cancelled' AND Ticket_Status__c =: 'Booked'];
     for(Ticket__c ttt : tics){
              if(ttt.Item_Type__r.Name == 'Admissions' || ttt.Item_Type__r.Name == 'Seats' || ttt.Item_Type__r.Name == 'Seminars'){
              attendeesreig++;
              }
              }
    }   
//TO GET DATA FOR MAKING OF PAYMENTS Vs PAYMENT TYPE DASHBOARD
    public LIST<paymentinner> payinn {get ; set ;}
    public decimal payedamount {get ; set ;}
    public String cur {get ; set ;}
    public string paytype {get ; set ;}    
    public LIST<paymentinner> getpaymentwithType(){
    system.debug('eeeeeeeeeeeeeeeeeeeeee'+selectedEvent);
    payinn = new LIST<paymentinner> ();
    AggregateResult[] paymentsresult = [SELECT Payment_Mode__c p,SUM(Order__r.Order_Total__c) s FROM Payment__c WHERE Order__r.Events__c =:selectedEvent AND Order__r.Transaction_Status__c =: 'Completed' AND Order__r.Order_Status__c != 'Cancelled'  GROUP BY Payment_Mode__c];
    system.debug('aaaaaaaaaaaaaaaaaaaaaaaaaaaa'+paymentsresult );
        for(AggregateResult pay : paymentsresult)     
          {
           payedamount =(decimal)pay.get('s');//+decimal.valueOf('$')
           cur='$';
           paytype=(String)pay.get('p')+'($)';
           payinn.add(new paymentinner(paytype,payedamount,cur));
           system.debug('::::::::::::::PAY INNER:::::::::::::;'+payinn);
          }
      return payinn;
    }
//INNER CLASS FOR PAYMENT Vs PAYMENT TYPE REPORT 
    public class paymentinner
{
     public decimal amount{get;set;} 
     public String paytype{get;set;}
     public String dollar{get;set;} 
     public paymentinner(String paytype, decimal amount, String dollar)  
     { 
         this.amount=amount;
         this.paytype= paytype;  
         this.dollar= dollar;     
     }
}
//TO GET DATA FOR MAKING OF PAYMENTS Vs TICKET TYPE DASHBOARD
    public LIST<ticetpaymentinner> ticpayinn {get ; set ;}
    public decimal payment {get ; set ;}
    public string tictype {get ; set ;}
    public integer registeredatt {get ; set ;}
    public LIST<ticetpaymentinner> getpaymentwithtickettype(){
   
    AggregateResult[] paywithtics = [SELECT count(id) c,SUM(Order__r.Order_Total__c) s,Item__r.item_name__c t FROM Order_Item__c WHERE  Item__r.Event__c =: selectedevent AND Order__r.Transaction_Status__c =: 'Completed' AND Order__r.Order_Status__c != 'Cancelled' GROUP BY Item__r.item_name__c,Item__c ];//WHERE  Item__r.Event__c =: selectedevent
    //LIST<BLN_Item__c> items = [SELECT id,Name,item_type__r.Name,item_name__c,price__c,item_count__c FROM BLN_Item__c WHERE Event__c =: selectedEvent ];
    //MAP<string,items > itemmap = new MAP<string,items> ();
    system.debug('ttttttttttttttttttttttt'+paywithtics);
    ticpayinn = new LIST<ticetpaymentinner> ();
         SET<ID> BLID = new SET<ID> ();
        for(AggregateResult ag :paywithtics){
           //for(BLN_Item__c ITMS : items ){
                payment =(decimal)ag.get('s');
                tictype =(String)ag.get('t');
                
                    //if(tictype == ITMS.item_name__c){
                        //if(BLID.add(ITMS.id)){
                        ticpayinn.add(new ticetpaymentinner(tictype ,payment ));
                        system.debug('::::::::::::::PAY INNER:::::::::::::;'+payinn);
                    //}else{
                     //if(BLID.add(ITMS.id)){
                       // payment = 0;
                       // ticpayinn.add(new ticetpaymentinner(tictype ,payment ));}
                    //}
            //}
           //} 
        }
        return ticpayinn;
    
    }
//INNER CLASS FOR PAYMENT Vs TICKET TYPE REPORT 
    public class ticetpaymentinner{
    public string tictype {get ; set ;}
    public decimal payment {get ; set ;}
        public ticetpaymentinner(string tictype , decimal payment){
            this.tictype = tictype;
            this.payment = payment;
    
        }
    }
//TO GET DATA FOR MAKING OF Expected Revenue Vs Generated Revenue DASHBOARD
    public decimal expected {get ; set ;}
    public decimal generated {get ; set ;}
    public LIST<revenueinn> exinner {get ; set ;}
    public string rtype {get ; set ;}
    public decimal revenuepercent {get ; set ;}
    public void expectedrevenue(){
    revenuepercent =0;
    expected = 0;
    generated=0;
    rtype ='';
    exinner = new LIST<revenueinn> (); 
    LIST<BLN_Item__c> items = [SELECT id,Name,price__c,item_count__c FROM BLN_Item__c WHERE Event__c =: selectedEvent ];
    MAP<string,decimal> itemsmap = new MAP<string,decimal> ();
    MAP<string,decimal> itemsmapcount = new MAP<string,decimal> ();
        for(BLN_Item__c its : items){
            expected = expected + (its.price__c * its.item_count__c);
            system.debug('::::::::::::;;;ex:::::::::;'+expected);
            itemsmap.put(its.id,its.price__c );
            itemsmapcount.put (its.id,its.item_count__c);
        }
        system.debug('::::::::::::;;;ex:::::::::;'+expected);
    AggregateResult[] tics = [SELECT count(id) c,Item__r.id i FROM Ticket__c WHERE Ticket_Status__c =: 'Booked' AND Item__r.Event__c =: selectedEvent AND   Order__r.Transaction_Status__c =: 'Completed' AND Order__r.Order_Status__c != 'Cancelled' GROUP BY Item__r.id];
    
        for(AggregateResult ag :tics ){
            integer payment =(integer)ag.get('c');
            system.debug('::::::::::::;;;ge:::::::::;p'+payment );
            string itemtype =(String)ag.get('i');
            system.debug('::::::::::::;;;ge:::::::::;'+itemtype );
              system.debug('::::::::::::;;;ge:::::::::;'+itemsmap.get((String)ag.get('i')));
               system.debug('::::::::::::;;;ge:::::::::;'+(integer)ag.get('c'));
           generated = generated+(itemsmap.get((String)ag.get('i')) * (integer)ag.get('c'));
            system.debug('::::::::::::;;;ge:::::::::;'+generated );
        }
        LIST<string> types = new LIST<string> ();
        types.add('Expected Revenue($)');
        types.add('Generated Revenue($)');
            for(string s: types){
            rtype ='';
             rtype =s;
                If(rtype  == 'Expected Revenue($)'){
                     exinner.add(new revenueinn(rtype  , expected ));}
                 else{
                     exinner.add(new revenueinn(rtype  , generated ));}
              system.debug(':::::::::::::::;;rtype ::::::::::::::;'+exinner);       
        }
        if(expected != 0){
        //revenuepercent = Math.MOD(integer.valueOf(generated),integer.valueOf(expected)) * 100;
        system.debug('eeeeeeeeee'+expected);
        system.debug('rrrrrrrrrr'+revenuepercent );
        system.debug('eeeeeeeeee'+generated);
        system.debug('rrrrrrrrrr'+expected);
        system.debug('gggggggggggg'+generated);
        system.debug('gggggggggggg'+integer.valueOf(math.abs(generated)));
        integer i = integer.valueOf(generated);//integer.valueOf(math.abs(generated));
        integer j = integer.valueOf(expected);//integer.valueOf(math.abs(expected));
         system.debug('%%%%%%%%%%%%'+i / j);
         system.debug('iiiiiiiiiiiiii'+i);
        system.debug('jjjjjjjjjjjj'+j);
        revenuepercent = decimal.valueOf((i* 100) / j);
        
        }
    }
//INNER CLASS FOR PAYMENT Vs PAYMENT TYPE REPORT 
    public class revenueinn
    {
     public String type {get;set;} 
     public decimal geamount{get;set;} 
     public revenueinn(String  type , decimal geamount)  
     { 
         this.type = type ;
         this.geamount= geamount;      
     }
    }

    //TO GET DATA FOR MAKING OF TOTAL NO OF TICKETS Vs SOLD TICKETS  DASHBOARD 
    public LIST<soldticketsinn> soldinn {get ; set ;}  
    public decimal booked {get ; set ;}
    public decimal Available {get ; set ;}
    public decimal totalticsNo {get ; set ;}
    public decimal soldtics {get ; set ;}
    public decimal attendeesreig {get ; set ;}
    
    public void TotalTics(){
        soldtics =0;
        attendeesreig =0;
        soldinn  = new LIST<soldticketsinn> ();
        LIST<BLN_Item__c> items = [SELECT id,Name,item_type__r.Name,item_name__c,price__c,item_count__c FROM BLN_Item__c WHERE Event__c =: selectedEvent ];
            MAP<string,decimal> itemsmapcount = new MAP<string,decimal> ();
            for(BLN_Item__c its : items){        
                itemsmapcount.put (its.id,its.item_count__c);
            }
            system.debug('::::::::::::;;;ex:::::::::;'+expected);      
         
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
     }
 
    
//INNER CLASS FOR TOTAL NO OF TICKETS Vs SOLD TICKETS REPORT 
    public class soldticketsinn {
        public String TIC {get;set;} 
        public decimal Sold{get;set;} 
        public decimal Available{get;set;} 
        public soldticketsinn(decimal Sold,decimal Available,String TIC)  { 
            this.Sold=Sold;
            this.Available=Available;
            this.TIC  =TIC  ;
        }
    }
}