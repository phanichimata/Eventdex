@RestResource(urlMapping='/BLN_ASC_ItemsList/*')

global class BLN_ASC_ItemsList{
global static List<Itemscls_info> ct1 {get ; set ;}
global static BLN_Item_DAO itemsDao {get; set ;}
    @HttpPost  
    global static List<Itemscls_info> doPost(){ 
        RestRequest req = RestContext.request;
        string eventid = req.params.get('Event_id');
        ct1 = new List<Itemscls_info>();
        itemsDao = new BLN_Item_DAO ();
        LIST<BLN_Item__c> itemsofEvent = itemsDao.getEventItems(eventid);
        List<string> poolids = new List<string> ();
        
            for(BLN_Item__c BL : itemsofEvent ){
                poolids.add(BL.Item_Pool__r.id);
                //ct1.add(new Itemscls_info(BL));
            }
            
        BLN_ItemPool_DAO pooldao = new BLN_ItemPool_DAO ();
        List<Item_Pool__c> pools = new List<Item_Pool__c> ();
        pools = pooldao.givesItemPools(poolids); 
         BLN_Event__c  ble=[select id,name,Time_Zone__c from BLN_Event__c where id=:eventid limit 1];
        
            for(BLN_Item__c BLT : itemsofEvent ){
            string Sdate = BLT.sale_start__c.format('yyyy-MM-dd hh:mm a',ble.Time_Zone__c);
            string Edate = BLT.sale_end__c.format('yyyy-MM-dd hh:mm a',ble.Time_Zone__c); 
                for(Item_Pool__c pL : pools ){
                         if(BLT.Item_Pool__r.id == PL.id){
                             ct1.add(new Itemscls_info(BLT,Sdate,Edate,PL));
                         }
                 
                 }
        
        }
        


        return ct1;

    }
    
   global class Itemscls_info{
   
   public BLN_Item__c Items {get ; set ;}
   public Item_Pool__c Itempool {get ; set ;}
   public string Startdate {get ; set ;}
   public string Enddate {get ; set ;}
   public Itemscls_info(BLN_Item__c Item1 ,string sdate,string edate, Item_Pool__c Itempool1){
   Items =Item1;
   Startdate= sdate;
   Enddate = edate;
   Itempool = ItemPool1;
   
   }
     public Itemscls_info(){}
   }
    

}