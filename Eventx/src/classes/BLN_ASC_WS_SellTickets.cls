/***********************************************************************************************
*   Controller Name : BLN_ASC_WS_SellTickets
*   Date            : 08/12/2014
*   Author          : Rajesh Kumar Ch
*   Purpose         : This class is Web service Class to sell tickets from Scan attendee mobile application. Registration from Mobile.
**************************************************************************************************/

@RestResource(urlMapping='/BLN_ASC_WS_SellTickets')
global class BLN_ASC_WS_SellTickets{  
  
  BLN_Quick_Registration_BAL RegistrationBAL = new BLN_Quick_Registration_BAL();  
  
  Static boolean isCompanyProvide =false;
  static String eveid;
  static String userid;
  
  
  @HttpPost
  global static BLN_ASC_Checkin.TotalList doPost(){  
    
    SellTickets res = new SellTickets();
    
    // Instance for the Orders inner class
    List<Orders> OrdItms = new List<Orders>();
   
    List<NoTicketItems> nti = new List<NoTicketItems>();
    
    RestRequest req = RestContext.Request;
    
    // get params from Request URL
    eveid = req.params.get('eveid');
    system.debug('eveid==============='+eveid);
    userid = req.params.get('userid');
    system.debug('userid==============='+userid);
    
    // getting body and cnverting blob body to string
    String JsonString = req.requestBody.toString();
    system.debug('JsonString from body==='+JsonString);
    
    // Instance for the BuyerInfo inner class
    BuyerInfo buyinf; 
    
    // MAP for Item based on the Item Id in the Request body
    MAP<id,BLN_Item__c > mapitemidwithItem = new MAP<id,BLN_Item__c >();
    
    // Instance for the BLN_Quick_Registration_BAL class
    BLN_Quick_Registration_BAL QuickRegBAL = new BLN_Quick_Registration_BAL();
    
    // Getting all items available for the event based eveid
    for( BLN_Item__c blitems : QuickRegBAL.getEventItems(eveid)){
        mapitemidwithItem.put(blitems.id,blitems); 
    }
    
    TotalOrderInfo to = new TotalOrderInfo();
    JSONParser parser = JSON.createParser(JsonString);
    System.debug('JJJJJJJJJJJ:'+parser);
    while (parser.nextToken() != null){     
        /*system.debug('parser.getCurrentToken()==='+ parser.getCurrentToken()+'   000parser.getText()=== '+parser.getText());
        system.debug('parser.nextToken()==='+ parser.nextToken()+'   111parser.getText()=== '+parser.getText());*/
          
        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
           to = (TotalOrderInfo)parser.readValueAs(TotalOrderInfo.class);
           system.debug('to ==='+ to);
        }
    }
      system.debug('List Of ordee items'+OrdItms);
 
    
    
    system.debug('buyinf==========    ' + to.BuyerInfo); 
    system.debug('List Of ordee items' + to.Orders);
      
      //List<BLN_RegistrationnewCon.ItemInnerClass> itemInn = new List<BLN_RegistrationnewCon.ItemInnerClass>();
      
      // Creating GN User object to send it to BLN_Quick_Registration_BAL class
      Gn_user__c buyerUser = new GN_User__c();
      Company__c buyerCompweb = new Company__c();
      
      system.debug('buyinf.FirstName==========    '+to.BuyerInfo.FirstName);
      buyerUser.First_Name__c =  to.BuyerInfo.FirstName;
      buyerUser.Last_Name__c = to.BuyerInfo.LastName;
      buyerUser.Email__c = to.BuyerInfo.EmailId;
      buyerCompweb.Name =  to.BuyerInfo.Company;
      
      // RegTickets = QuickRegBAL.getTicketDetail(iic.items,Integer.valueOf(iic.selectedItemQuantity));
      
      // Instance for the BLN_RegistrationnewCon Items inner class
      List<BLN_RegistrationnewCon.ItemInnerClass> innItem = new List<BLN_RegistrationnewCon.ItemInnerClass>();
      
      // Instance for the BLN_RegistrationnewCon Tickets inner class
      List<BLN_RegistrationnewCon.TicketInnerClass> tcInn = new List<BLN_RegistrationnewCon.TicketInnerClass>();
       
       for(orders orditem : to.Orders){
           BLN_Item__c item = new BLN_Item__c();
           system.debug('orditem.ItemId========    '+orditem.ItemId);
           item = mapitemidwithItem.get(orditem.ItemId);
           innItem.add(new BLN_RegistrationnewCon.ItemInnerClass(item,new list<Selectoption>(),orditem.ItemQuantity,0,''));
           
           List<Ticket__c> tcList = new List<Ticket__c>();
           
           system.debug('PPPPPPPPPPPPPPp '+ item );
           system.debug('QQQQQQQQQQQQQQQQ '+ orditem.ItemQuantity);
           
           // Creating tickets List based on the selected item Quantity
           tcList = QuickRegBAL.getTicketDetail(item, Integer.valueOf(orditem.ItemQuantity));
           
           if(tcList.size()==0){
               NoTicketItems noticitems = new NoTicketItems();
               system.debug('orditem.ItemId===='+orditem.ItemId);
               noticitems.ItemId = orditem.ItemId;
               noticitems.Msg= 'No available tickets found for this item';
               nti.add(noticitems);
               system.debug('nti============== '+ nti);
           }else{
               integer i =0;
                system.debug('PPPPPPPPPPPPPPp '+ orditem.OrderLineItems);
               If(item.item_type__r.Name!='Package'){
                system.debug('PPPPPPPPPPPPPPp '+ item );
                   for(OrderLineItem ordlineitem : orditem.OrderLineItems){
                    system.debug('PPPPPPPPPPPPPPp '+ orditem.OrderLineItems);
                       BLN_RegistrationnewCon.TicketInnerClass regTick = new BLN_RegistrationnewCon.TicketInnerClass();
                       regTick.ticket = tcList[i];
                       i++;
                       regTick.EachUser.First_NAme__c = ordlineitem.firstName;
                       system.debug('ordlineitem.firstName=== = '+ordlineitem.firstName);
                       regTick.EachUser.Last_NAme__c =ordlineitem.lastName;
                       system.debug('ordlineitem.lastName=== = '+ordlineitem.lastName);
                       regTick.EachUser.Email__c =ordlineitem.EmailId;
                       system.debug('ordlineitem.EmailId=== = '+ordlineitem.EmailId+'nn '+ordlineitem.company);
                       if(ordlineitem.company!=null){
                       regTick.EachCompany = new Company__c();
                          regTick.EachCompany.Name =ordlineitem.company;
                       }
                       system.debug('ordlineitem.company=== = '+ordlineitem.company);
                       regTick.BLNItem =  item; 
                       tcInn.add(regTick);
                    }     
                }
            }      
        }
        
        
        // calling BLN_Quick_Registration_BAL insertingTotalorder method after construnting all required parametrs of the insertingTotalorder  method
        string msg = QuickRegBAL.insertingTotalorder(innItem,tcInn,buyerUser ,'',new Company_Ext__c(),decimal.valueOf(to.BuyerInfo.OrderTotal),decimal.valueOf(to.BuyerInfo.DiscountedPrice),decimal.valueOf(to.BuyerInfo.FeeAmount),decimal.valueOf(to.BuyerInfo.OrderTaxes),decimal.valueOf(to.BuyerInfo.AmountPayable),new MAP<id,decimal>(),new MAP<id,decimal>(),new Promotion__c(),to.BuyerInfo.PaymentType,to.BuyerInfo.PaymentType,to.BuyerInfo.PayKey,to.BuyerInfo.PaymentType, new Pay_Address__c(), buyerCompweb,new List<BLN_RegistrationnewCon.UserAnswerInnerClass>(), '');    
        system.debug('PPPPPPPPPPPPPPp '+msg);
        //string ordstatus =   Quickbal.insertingTotalorder(ItemList,TicketList,GNUserforbuyer,null,GNbuyerCompanyDetails,totalAmount + DiscountedAmount,DiscountedAmount,FeeAmount,TaxAmount,totalAmount,mapitemWithFee,mapitemWithDiscount,PromotionOb,SelectedCardType,SelectedPaymentGateway,ChargeId,PayGatewayMode);
        BLN_ASC_Checkin.TotalList TL = new BLN_ASC_Checkin.TotalList ();
        BLN_Mytickets_BAL ordersList = new BLN_Mytickets_BAL();
       
        // Sending email If order and order Items created then creating service response 
        if(msg=='Success'){
            List<BLN_ASC_Checkin.maincontainer> Mc = new List<BLN_ASC_Checkin.maincontainer> ();
            system.debug('QuickRegBAL.orderId====  '+QuickRegBAL.orderId);
            BLN_SuccessController SuccessBal= new BLN_SuccessController();
            SuccessBal.orderId =QuickRegBAL.orderid ;
            SuccessBal.eventId=eveid;
            SuccessBal.sendMail();
            ordersList.orderId=QuickRegBAL.orderid;
            // For mobile app response 
            LIST<BLN_Mytickets_BAL.inncls>  inlists = ordersList.userTickets(Userid,eveid,'BLN_ASC_ScannedTickets','');    
            for(BLN_Mytickets_BAL.inncls cls : inlists){
             BLN_ASC_Checkin.maincontainer nemain= new BLN_ASC_Checkin.maincontainer();
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
         TL.isorder=ordersList.isorder;//to check from mobile wheteher it is a orderqrcode or badgeqrcode
         return TL; 
     }
      
      return null;      
  }

  global class SellTickets{
      public string ErrorMsg;
      public Order__c OrderInfo;
      public List<NoTicketItems> ntis;
  }
  
  global class NoTicketItems{
      public Id ItemId;
      public String Msg;
  }
  
  global class TotalOrderInfo{
      public BuyerInfo BuyerInfo;
      public List<Orders> Orders;
  
  }
  
  global class BuyerInfo{
      global string FirstName;
      global string LastName;
      global string EMailId;
      global string Company;
      global string PaymentType;
      global string PayKey;
      global string OrderTotal;
      global string AfterDiscountPrice;
      global string DiscountedPrice;
      global string FeeAmount;
      global string OrderTaxes;
      global string AmountPayable;
      global string OrderStatus;
      global string CurrencyCode;
      global string TransactionStatus;
  }
  
  
  global class Orders{
      global Id ItemId;
      global String ItemName;
      global String ItemType;
      global String ItemPoolId;
      global String ItemPrice;
      global String ItemDiscount;
      global String ItemTotal;
      global String ItemQuantity;
      LIST<OrderLineItem> OrderLineItems;      
      
      global Orders(Id itid, String itname, String ItTyp, String itemplid, String itprice, String itdisc, String ittotal, String itqnt, LIST<OrderLineItem> ords){
        //OrderLineItems = new LIST<OrderLineItem>();
          ItemId = itid;
          ItemName = itname;
          ItemType = ItTyp;
          ItemPoolId = itemplid;
          ItemPrice = itprice;
          ItemDiscount = itdisc;
          ItemTotal = ittotal;
          ItemQuantity = itqnt;
          OrderLineItems = ords.clone();      
      }      
  }
  
  global class OrderLineItem{
      public String FirstName;
      public String LastName;
      public String EmailId;
      public String Company;
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