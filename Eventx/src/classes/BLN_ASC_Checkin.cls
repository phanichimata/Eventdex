@RestResource(urlMapping='/BLN_ASC_Checkin/*')

global class BLN_ASC_Checkin{


global static BLN_Mytickets_BAL ordersList {get ; set ;}
//global static BLN_Item_DAO itemsDao {get; set ;}
//global static List<Ordersonly> ord {get ; set ;}
 //global static List<Itemscls_info> ct1 {get ; set ;}
 global static TotalList  TL {get ; set ;}
  @HttpPost  
    global static TotalList doPost(){ 
    //itemsDao = new BLN_Item_DAO ();
    RestRequest req = RestContext.request;
   List<maincontainer> Mc = new List<maincontainer> ();
   TL = new TotalList ();
   //ord = new Ordersonly ();
    string eventid = req.params.get('Event_id');
    string Userid = req.params.get('User_id'); 
    
    ordersList = new BLN_Mytickets_BAL();
    Map<id,string> mapdemo  = new Map<id,string>();
    
   LIST<BLN_Mytickets_BAL.inncls>  inlists = ordersList.userTickets(Userid,eventid,'Bln_orders','');
   
    for(BLN_Mytickets_BAL.inncls cls : inlists){
         maincontainer nemain= new maincontainer();
         nemain.orderInn =cls.orderInn;
         nemain.dt=cls.dt;
         nemain.ticketsInn =cls.ticketsInn ;
         nemain.cancelledTickets=cls.cancelledTickets;
          nemain.paymentInn=cls.paymentInn;
         nemain.orderItemInn =cls.orderItemInn ;
         nemain.orderPrice= cls.orderPrice;
         Mc.add(nemain);
    }
    
    
     
     
     TL.TotalLists= Mc;
      return TL;
    
    }
    
   global class maincontainer {
        public order__c orderInn{get;set;}
        public date dt{get;set;}
        public List<Ticket__c> ticketsInn{get;set;}
        public List<Ticket__c> cancelledTickets{get;set;}
        public payment__c paymentInn{get;set;}
        public List<order_Item__c>  orderItemInn {get;set;}
        public decimal orderPrice{get;set;}
        
        public maincontainer (){
       
        }
       
   
   } 
   global class Ordersonly{
   public Order__c OrdersList_info {get ; set ;}
   public Ordersonly(){}
   
   }
   
   global class TotalList{
   public List<maincontainer> TotalLists{get ; set ;}
   public boolean isorder{get;set;}
   
   public TotalList(){
    TotalLists= new List<maincontainer> ();
    
   }
   
   }
    
}


  /** global class Itemscls_info{
   public BLN_Item__c Items {get ; set ;}
   public Item_Pool__c Itempool {get ; set ;}
   public Itemscls_info(BLN_Item__c Item1 , Item_Pool__c Itempool1){
   Items =Item1;
   Itempool = ItemPool1;
   
   }
     public Itemscls_info(){}
   }
   */