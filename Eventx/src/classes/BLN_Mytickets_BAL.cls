/***********************************************************************************************
*   Controller Name : BLN_MyticketsCon
*   Date            : 05/19/2014
*   Author          : Phani Kumar Ch
*   Purpose         : This class is for show and edit tickets
*   Change History  : 05/19/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*  05/19/2014          Phani Kumar ch                   To Create Page
*  06/30/2014          Phani Kumar Ch                   New Feature was came it is allowing Duplicates
   07/02/2014          Phani Kumar ch                   Removing createTicketsWithNewOderitem (Durga said no need to linlk up tickets with new order item)
**************************************************************************************************/

global class BLN_Mytickets_BAL{
   public String orderId{get;set;}
   public boolean isorder{get;set;}//used for scanned service in mobile to check whether it is a orderqrcode or badgeqrcode
  
   // to get all events of login user 
    public List<BLN_Event__c> getEvents(string userId){
     BLN_Ticket_DAO blnTdao = new BLN_Ticket_DAO();
     BLN_Event_DAO blnEdao = new BLN_Event_DAO();
     SET<id> eventids =new  SET<id>();
     string temp = ' where Client_GN_User__r.User__c = \''+userId+'\''+' or order__r.Client_GN_User__r.User__c = \''+userId+'\'';
      for(ticket__c tc : blnTdao.userOrderAndTickets(temp)){
          eventids.add(tc.event__c);
       }
       return  blnEdao.getevents(eventids);
     }
   
   // This Method is for getting the order,order items and tickets of users
   public List<BLN_Mytickets_BAL.inncls>  userTickets(string userId,string eveId,string page, String filterType){
    BLN_Ticket_DAO blnDao = new BLN_Ticket_DAO();
    BLN_Order_DAO blnOrderDao = new BLN_Order_DAO();
    BLN_OrderItem_DAO blnOrderItemDao = new BLN_OrderItem_DAO();
    List<inncls> inn = new List<inncls>();
    SET<id> orderIds = new SET<id>();
    MAP<id,List<ticket__c>>  mapOrdIdwithTic = new  MAP<id,List<ticket__c>>();
    string wherecondition ='';
       
       BLN_Quick_Registration_BAL QuickRegBAL = new BLN_Quick_Registration_BAL();
         BLN_EVent__c  evedetails = new BLN_EVent__c ();
         evedetails = QuickRegBAL.getEventDetails(eveId);
      system.debug('SSSSSSSSSSSSS '+userId ); 
    
     if(page=='BLN_Mytickets'){
          wherecondition = ' where Client_GN_User__r.user__c = \''+userId+'\'';
     }else if(page=='BLN_ASC_ScannedTickets')
     {
          //for orderqrcode
         wherecondition = ' where id= \''+orderId+'\'';
     }else{
        
          if(userId == evedetails.owner.id){
            wherecondition = ' where Events__c = \''+eveId+'\'';
          }else{
              system.debug('XXXXXXXXXXXXXX '+wherecondition);
               wherecondition = ' where Client_GN_User__r.user__c = \''+userId+'\''+' and Events__c = \''+eveId+'\'';
          }
            
     }
     system.debug('  FILTER TYPE  '+filterType );
     if(filterType == 'Completed'){
         wherecondition += ' and Transaction_Status__c = \''+'Completed'+'\'';
     }else if(filterType == 'Not Completed'){
         wherecondition += ' and Transaction_Status__c = \''+'Not Completed'+'\'';
     }else if(filterType == 'Cancelled'){
         wherecondition += ' and Order_Status__c = \''+'Cancelled'+'\'';
     }
     
       system.debug('YYYYYYYYYYYYYYYYYYy '+wherecondition);
     
      List<order__c> order = blnOrderDao.orderQuery(wherecondition);  // Getting order of user puchased tickets
      system.debug(page+'  ORDERS SIZE '+order.size());
      
      isorder=true;
      if(order.size()==0&&page=='BLN_ASC_ScannedTickets')
     {
         
        //for badgeqrcode
        try{
        Ticket__c tc=[select id,name,Badge_ID__c,Order__c from Ticket__c where Badge_ID__c=:orderId];
         wherecondition = ' where id= \''+tc.Order__c+'\'';
         order = blnOrderDao.orderQuery(wherecondition);
         isorder=false;
         }catch(Exception e){}
     }
      system.debug('XXXXXXXXx '+order);
      for(order__c ore :order){
       orderIds.add(ore.id);
      }
      
     if(page!='BLN_ASC_ScannedTickets') 
     for(Ticket__c myTic: blnDao.userOrderAndTickets(orderIds,userid,eveId)){  // This is Getting the order of user added by some else
        orderIds.add(myTic.order__c);
     }
     
   for(order_Item__c ordersOnTickets : blnOrderItemDao.orderQueryTicketCh(orderIds)){ // Getting order Items
        mapOrdIdwithTic.put(ordersOnTickets.id,ordersOnTickets.Tickets__r); 
     }  
     
    //Getting Payment type of orders
   BLN_payment_DAO blnPaymentDao = new BLN_payment_DAO();
   MAP<id,payment__c > mapOrderWithPayment = new MAP<id,payment__c>();
    for(payment__c pay : blnPaymentDao.paymentInfo(orderIds)){
        mapOrderWithPayment.put(pay.order__c,pay );
    }
    MAP<id,List<ticket__c>> mapOrdiDWithTicket = new MAP<id,List<ticket__c>>();
     for(order__c od : blnOrderDao.orderQueryChildTicket(orderIds)){  // This is Getting the order of user added by some else
        mapOrdiDWithTicket.put(od.id,od.tickets__r);
     }
     // Get tickets that he booked as a owner     
       for(order__c ord : blnOrderDao.orderQueryChildOrditem(orderIds)){
       system.debug('22222222222  '+ord); 
       system.debug('@@@@@@@@@@@  '+ord.Order_Items__r ); 
       
         List<order_Item__c> addingordItem = new List<order_Item__c>(); 
          for(order_Item__c orderIteam : ord.Order_Items__r ){
           system.debug('@@@@@@@@@@@ 22222 '+eveId  ); 
            if(eveId == 'All'){
               addingordItem.add(orderIteam);
             } else if(eveId == orderIteam.Item__r.Event__c){
                 addingordItem.add(orderIteam);
             } 
          }  
        date dDate;
        if(addingordItem.size()>0){
           dDate= addingordItem[0].Item__r.Event__r.End_Date__c;
        }
       List<ticket__c> ticValues = new List<ticket__c>();
       ticValues = mapOrdiDWithTicket.get(ord.id);
       if(addingordItem.size()>0){
            inn.add(new inncls(ord,addingordItem,dDate,mapOrderWithPayment.get(ord.id),ticValues)); 
         }
       }
     system.debug('INn value ppppppppp '+inn);  
    return inn; 
  }
  
  // Update ticket with new user and company
  public BLN_StatusMessage updateTickets(string uid,string comId,ticket__c tc){
    // tc.Client_User__c= uid ;
     tc.Client_company__c= comId ;
     BLN_Ticket_DAO blnTcdao = new BLN_Ticket_DAO();
     return blnTcdao.updateTicket(tc); 
  }
  
  // Update order with new user and company
  public BLN_StatusMessage updateorder(string uid,string comId,order__c tc){
    //  tc.Client_User__c= uid ;
      tc.Client_company__c= comId ;
       BLN_Order_DAO  blnordao = new BLN_Order_DAO();
       return blnordao.updateOrder(tc); 
  }
  
  
  // this method will return values of orderItem and tickets 
   public List<Order_Item__c> orderItemWithlineItem(string orderItemId){
     BLN_OrderItem_DAO blnOrderItemdaoSingle =new  BLN_OrderItem_DAO();
     List<Order_Item__c> ret = blnOrderItemdaoSingle.getTicketsOfperticularOItem(orderItemId);
     return ret;
   }
  
  
  
  // cancel order item if it has quatity 1
  public void cancelOrderItemValues(List<Order_Item__c> ordms){
     BLN_OrderItem_DAO blnOrderItemdaoSingle =new  BLN_OrderItem_DAO();
     List<Order_Item__c> orderForReduceBookedQuantity = new List<Order_Item__c>();
     BLN_Ticket_DAO blntic = new BLN_Ticket_DAO();
     
     
     for(Order_Item__c ord : ordms){
      List<Ticket__c> listOfTickets = new List<Ticket__c>();
      for(Ticket__c tc : ord.Tickets__r){
        if(tc.Ticket_Status__c!='Cancelled'){
         listOfTickets.Add(tc);  
        }
      }
       chengeItemOrderCount(ord,listOfTickets);
       cancelTickets(listOfTickets); //cancel tickets
       BLN_StatusMessage blstatus  = blnOrderItemdaoSingle.updateOrder(orderForReduceBookedQuantity);
       cloneTickets(listOfTickets);
      }
   } 
    
    // this method cancel the list of tickets
    public void cancelTickets(List<ticket__c> cancelTickets){
     BLN_Ticket_DAO blntic = new BLN_Ticket_DAO();
     List<Ticket__c> listOfTicketsForChangeStatus = new List<Ticket__c>();
      Ticket__c tid = new Ticket__c();
      for(Ticket__c  iterateTic : cancelTickets){
         iterateTic.Ticket_Status__c = 'Cancelled';
         listOfTicketsForChangeStatus.add(iterateTic);// for update tickets
      }
   BLN_StatusMessage blstatusTic =  blntic.updateTicket(listOfTicketsForChangeStatus); 
    }
    
    
    // cancel order items 
   public void cancelordtems(List<Order_Item__c> itemOrd){
     BLN_OrderItem_DAO blnOrderItemdaoSingle =new  BLN_OrderItem_DAO();
     List<Order_Item__c> orderForReduceBookedQuantity = new List<Order_Item__c>();
      for(Order_Item__c ord : itemOrd){
       ord.Item_Quantity__c = 0.0;
       ord.Item_Total__c = 0.0;
        orderForReduceBookedQuantity.add(ord); // for updating order Item
     }
       BLN_StatusMessage blstatus  = blnOrderItemdaoSingle.updateOrder(orderForReduceBookedQuantity);
  }
    
  // cloning tickets 
  public void cloneTickets(List<ticket__c> listOfTicketsForChangeStatus){
     BLN_Ticket_DAO blntic = new BLN_Ticket_DAO();
    List<ticket__c> forcloningTickets = new List<ticket__c>();
    for(Ticket__c tg :listOfTicketsForChangeStatus ){
        tg.id=null;
        tg.clone(false,true,false,false);
         tg.Client_Company__c =null;
         tg.Badge_ID__c =null;
         //tg.Client_User__c =null;
         tg.Order__c=null;
         tg.Order_Item__c = null;
         tg.Ticket_Status__c ='Available';
         forcloningTickets.add(tg);
     }
      
      BLN_StatusMessage blstatusTicclone = blntic.insertTicket(forcloningTickets);
     
  }
  
  public List<Bondbetweenchkandobj> bondObjChk{get;set;}
  //  this is for display ticket with check box
  public List<Bondbetweenchkandobj> mapchkandobj(List<Order_Item__c> ory){
    bondObjChk = new List<Bondbetweenchkandobj>();
     for(Order_Item__c iy : ory){
        for(Ticket__c tt :iy.Tickets__r ){
        bondObjChk.add(new Bondbetweenchkandobj(tt));
        }
     }
     return bondObjChk;
  }
   
   // decresing order item quantity after cancel the ticket
  public void chengeItemOrderCount(Order_Item__c orItem,List<Ticket__c> TicsCanQun){
    system.debug('11111111111111111  '+orItem+' ############## '+TicsCanQun);
    BLN_OrderItem_DAO blnOrderItemdaoSingle =new  BLN_OrderItem_DAO();
    List<Order_Item__c> orderForReduceBookedQuantity = new List<Order_Item__c>();
         Order_Item__c ordNewIn = new Order_Item__c();
        if(orItem.status__c!='Cancelled'){
         ordNewIn = orItem.clone(false,true,false,false);
         ordNewIn.Item_Quantity__c = (-ordNewIn.Item_Quantity__c);
         ordNewIn.Item_Total__c = (orItem.Each_Ticket_Price__c)*(ordNewIn.Item_Quantity__c);//+orItem.Item_Fee__c
         ordNewIn.Status__c ='Cancelled';
         orderForReduceBookedQuantity.add(ordNewIn);
         
           BLN_StatusMessage blstatus  = blnOrderItemdaoSingle.insertOrderitem1(orderForReduceBookedQuantity);
         }
         /*system.debug('SSSSSSSSSSSSSSS '+blstatus);
         for(id newOredItem : blstatus.successIds){
               createTicketsWithNewOderitem(newOredItem,TicsCanQun);            
         }*/
     } 
   
   // This will create new with new order item 
   public void createTicketsWithNewOderitem(id newordItem,List<Ticket__c> tcs){
    List<Ticket__c> tcListNewValues = new List<Ticket__c>();
      for(Ticket__c tic :tcs){
         Ticket__c tp = new Ticket__c();
         tp = tic.clone(false,true,false,false);
         tp.Order_Item__c = newordItem;
         tp.Ticket_Status__c = 'Cancelled';
        tcListNewValues.add(tp);
      }
     BLN_Ticket_DAO blnTcDaoval = new BLN_Ticket_DAO();
    BLN_StatusMessage blstatus1  = blnTcDaoval.insertTicket(tcListNewValues);
        
   }
   
   
   
   
   
    // This will return set of records for input orderIds
   public List<order__c> getOrdersOrdItems(Set<id> ordIds){
    BLN_Order_DAO bord = new BLN_Order_DAO();
     return  bord.orderQueryChildOrditem(ordIds);
   }
   
    // This will return set of records for input tickets
    public List<order__c> getOrderstickets(Set<id> ticIds){
        BLN_Order_DAO bord = new BLN_Order_DAO();
       return bord.orderQueryChildTicket(ticIds);
   }
   
    
     public List<ticket__c> getTicketDetails(string tcid){
        BLN_Ticket_DAO trf = new BLN_Ticket_DAO();
         string wherecondition = ' where id = \''+tcid+'\'' ;
         return trf.userOrderAndTickets(wherecondition);
    }
    
   
   // change the order status
    public void  uypdateOrderStatus(Set<id> ticIds){
        BLN_Order_DAO bord = new BLN_Order_DAO();
        boolean isOrdercancel = true;
        List<order__c> orderList = new List<order__c>();
        orderList =bord.orderQueryChildTicket(ticIds);
        for(order__c og :orderList){
            for(ticket__c tac :og.tickets__r){
              if(tac.Item_Type__r.Name!='Package'){
                if(tac.Ticket_Status__c !='Cancelled'){
                    isOrdercancel =false;
                }
              }else{
                  if(tac.Ticket_Status__c !='Cancelled' && tac.Parent_ID__c!=null){
                        isOrdercancel =false;
                    }
                } 
              }   
            }   
        
        system.debug('SSSSSSSSSSAAAAAAAAA W@@@@@@@@@@@'+isOrdercancel);
           if(isOrdercancel){
            if(orderList.size()>0){
               orderList[0].Order_Status__c='Cancelled';
               BLN_StatusMessage msg= bord.updateOrder(orderList[0]);
            }
            
        }
     }
 
 
 
 // innser calss for relate checkbox and ticket 
    public class Bondbetweenchkandobj{
      public boolean selectCheckbox{get;set;}
      public Ticket__c ticlineItems{get;set;}
      public Bondbetweenchkandobj(Ticket__c t){
        this.ticlineItems = t;
     }
  }
  
 // This class is for making bond with different objects
 global class inncls{
    public order__c orderInn{get;set;}
    public date dt{get;set;}
    public List<Ticket__c> ticketsInn{get;set;}
    public List<Ticket__c> cancelledTickets{get;set;}
    public payment__c paymentInn{get;set;}
    public List<order_Item__c>  orderItemInn {get;set;}
    public boolean displayOrderItems {get;set;} 
    public boolean selectCheckBox {get;set;}  
    public decimal orderPrice{get;set;}
    public MAP<id,integer> orderItemsMapWithTc{get;set;}
    public inncls(){
            
    } 
     public inncls(order__c od,List<order_Item__c> orderit,date d,payment__c paym,List<Ticket__c> ticin){
        cancelledTickets = new List<Ticket__c>();
        orderItemsMapWithTc = new MAP<id,integer>();
        ticketsInn = new List<Ticket__c>();
        this.orderInn =od;
        this.orderPrice = od.Order_Total__c;
        this.orderItemInn =orderIt;
        this.dt=d;
        this.paymentInn = paym;
        for(order_Item__c Oi :orderIt ){
         if(Oi.status__c =='Cancelled'){
            orderPrice-=Oi.Item_Total__c;//+Oi.Item_Fee__c
         }
         List<Ticket__c> ticOrd = new List<Ticket__c>();
        for(Ticket__c canTc : ticin){
          if(canTc.order_item__c == Oi.id){
             ticOrd.add(canTc);
          }
        }
        orderItemsMapWithTc.put(Oi.id,ticOrd.size());
      } 
        //this.ticketsInn = ticin;
        for(Ticket__c canTc : ticin){
            if(canTc.Ticket_Status__c =='Cancelled'){
               cancelledTickets.add(canTc);
              }else{
                ticketsInn.add(canTc);
            }
          }
                  
        }
   }
   
   // TO GET THE STATISTICS WRITTEN BY MANASA GANDHAM
   
   public BLN_Order_DAO  ordersDAOClass{get; set;}
   public BLN_Ticket_DAO  ticketsDAOClass{get; set;}
   public BLN_Payment_DAO  paymentDAOClass{get; set;}
   
   public LIST<Order__c> ordersListForSta(String EventId){
        ordersDAOClass= new BLN_Order_DAO();
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
  
  public Integer attendeesListForEvent(String EventId){
        
        ticketsDAOClass= new BLN_Ticket_DAO();        
        LIST<Ticket__c> ticksList= new LIST<Ticket__c>();
       // ticksList= ticketsDAOClass.ticketsListForEvent(EventId, NULL, NULL);        
        return ticksList.size();
    }
    
    
    public LIST<AggregateResult> PaymentsForEvent(String EventId){
    
        paymentDAOClass= new BLN_Payment_DAO();
        LIST<AggregateResult> PaymentAggregateList= new LIST<AggregateResult>(); 
        PaymentAggregateList= paymentDAOClass.paymentsForEvent(EventId);
        return PaymentAggregateList;
    }
}