/******************************************************
*   Author                  : Mythily Nagandla
*   Date                    : 14/12/2014 
*   Purpose                 : This is Web Service class for getting statistics and dash board values.
********************************************************/
@RestResource(urlMapping='/BLN_ASC_dashboard/*')
global class BLN_ASC_dashboard{
global static maincontainer  Mc {get;set;}
global static  BLN_DashboardConBAL Dashboardcon {get ; set ;}
@HttpPost  
  global static maincontainer  doPost(){ //Post Mthod
   RestRequest req = RestContext.Request;
   string Eventid = req.params.get('Event_id');
   Mc = new maincontainer();
  //cookie  counter = new Cookie('counter',Eventid ,null,-1,false);
  //ApexPages.currentPage().setCookies(new Cookie[]{counter});
  Dashboardcon = new BLN_DashboardConBAL();
  
  //Dashboardcon.selectedEvent = Eventid ;
  //List<BLN_DashboardCon.ticetpaymentinner> ticketList = Dashboardcon.getpaymentwithtickettype(Eventid);
  List<payvstype> PTs = new List<payvstype> ();
  payvstype PT = new payvstype ();
  AggregateResult[] aggvalues =  Dashboardcon.paymentwithticket(Eventid);
  for(AggregateResult ag  : aggvalues ){
  PT.tictype = (String)ag.get('t');
  PT.payment = (decimal)ag.get('s');
  PTs.add(PT);
  }
  Mc.PaymentVsTicketTypes = PTs;
  
  //--------------------------------------
  List<soldvsavl> SLS = new List<soldvsavl> ();
  List<BLN_DashboardConBAL.soldticketsinn> soldVsavltics = Dashboardcon.TotalTics(Eventid);
  for(BLN_DashboardConBAL.soldticketsinn SA : soldVsavltics){

   SLS.add(new soldvsavl (SA.SOLD,SA.Available,SA.TIC));
  }
  Mc.Soldtics = SLS;
  //-------------------------------------------------
  List<Payments> paymenstypes = new List<Payments> ();
  decimal payedamount =0;
  string paytype='';
  AggregateResult[] payvals =  Dashboardcon.paymenttype(Eventid);
  for(AggregateResult pay : payvals )     
          {
           payedamount =(decimal)pay.get('s');
           paytype=(String)pay.get('p')+'($)';
           paymenstypes.add(new Payments(paytype,payedamount ));
           system.debug('::::::::::::::PAY INNER:::::::::::::;'+paymenstypes);
          }
     Mc.PaymentVsPaymentTypes = paymenstypes;
  
  return Mc;
   
  }
  
  global class maincontainer  {
  public List<Payments> PaymentVsPaymentTypes {get ; set ;}
  public List<payvstype> PaymentVsTicketTypes {get ; set ;}
  public List<soldvsavl> Soldtics {get ; set ;}
  }
  global class payvstype{
    public string tictype {get ; set ;}
    public decimal payment {get ; set ;}

  }
  global class soldvsavl{
   public String TIC {get;set;} 
        public decimal SOLD{get;set;} 
        public decimal Available{get;set;} 
        public soldvsavl(decimal SOLD ,decimal Available,String TIC)  { 
            this.SOLD =SOLD ;
            this.Available=Available;
            this.TIC  =TIC  ;
        }
        public soldvsavl(){}
  
  
  }
  //INNER CLASS FOR PAYMENT Vs PAYMENT TYPE REPORT 
    public class Payments
{
     public decimal amount{get;set;} 
     public String paytype{get;set;} 
     public Payments(String paytype, decimal amount)  
     { 
         this.amount= amount;
         this.paytype= paytype;      
     }
}
  
}