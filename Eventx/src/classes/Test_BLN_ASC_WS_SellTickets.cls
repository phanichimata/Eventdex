@isTest
public class Test_BLN_ASC_WS_SellTickets{
    static testmethod void mySellTcktTestMethod(){
        Test_BLN_ASC_AddEvents addEventTest = new Test_BLN_ASC_AddEvents();
        Test_BLN_ASC_AddEvents.Test_BLN_ASC_AddEvents();
        BLN_ASC_WS_SellTickets sellTck=new BLN_ASC_WS_SellTickets();
        
        BLN_ASC_WS_SellTickets.SellTickets st1 = new BLN_ASC_WS_SellTickets.SellTickets();
        BLN_ASC_WS_SellTickets.NoTicketItems st2 = new BLN_ASC_WS_SellTickets.NoTicketItems();
        BLN_ASC_WS_SellTickets.TotalOrderInfo st3 = new BLN_ASC_WS_SellTickets.TotalOrderInfo();
        BLN_ASC_WS_SellTickets.BuyerInfo st4 = new BLN_ASC_WS_SellTickets.BuyerInfo();
        BLN_ASC_WS_SellTickets.OrderLineItem st6 = new BLN_ASC_WS_SellTickets.OrderLineItem();
        //testOrderList.add( new Order__c(Client_GN_User__c=gnUser.id,Client_Company__c=companyInfo.id,Events__c=eventInfo.id,Order_Total__c=2,Transaction_Status__c='Completed',Amount_Paid__c=30.6,Fee_Amount__c=6.7,Currency_Code__c=currenyInfo.id));
        List<BLN_ASC_WS_SellTickets.OrderLineItem> stList = new List<BLN_ASC_WS_SellTickets.OrderLineItem>();
        //stList.add(new BLN_ASC_WS_SellTickets.OrderLineItem());
        //stList[0].FirstName='thiru';
        //stList[0].LastName='pattipaka';
        //stList[0].EmailId='thiru@abc.com';
        //stList[0].Company='globalnest';
        BLN_ASC_WS_SellTickets.Orders st5 = new BLN_ASC_WS_SellTickets.Orders(Test_BLN_ASC_AddEvents.item.id, 'ticket', 'admission', Test_BLN_ASC_AddEvents.itempool2.id, '200', 'good', '20', '1', stList);
        
        BLN_ASC_WS_SellTickets.maincontainer  st7 = new BLN_ASC_WS_SellTickets.maincontainer (); 
        BLN_ASC_WS_SellTickets.Ordersonly st8 = new BLN_ASC_WS_SellTickets.Ordersonly ();
        BLN_ASC_WS_SellTickets.TotalList st9 = new BLN_ASC_WS_SellTickets.TotalList();
                
        RestContext.request.addParameter('eveid',Test_BLN_ASC_AddEvents.eventInfo.id);
        RestContext.request.addParameter('userid',Test_BLN_ASC_AddEvents.gnUser.id);
        
        BLN_ASC_WS_SellTickets sellTckTemp= new BLN_ASC_WS_SellTickets ();
        try{
            BLN_ASC_WS_SellTickets.dopost();    
        }catch(Exception Ex){ } 
    }
}