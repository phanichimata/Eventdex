@isTest
public class Test_BLN_ASC_WS_TicketCheckin{
    static testmethod void myTickChecknTestMethod(){
        Test_BLN_ASC_AddEvents addEventTest = new Test_BLN_ASC_AddEvents();
        Test_BLN_ASC_AddEvents.Test_BLN_ASC_AddEvents();
        BLN_ASC_WS_TicketCheckin tchObj=new BLN_ASC_WS_TicketCheckin();
        
        BLN_ASC_WS_TicketCheckin.SuccessTickets t1 = new BLN_ASC_WS_TicketCheckin.SuccessTickets(Test_BLN_ASC_AddEvents.ticket.id,true,'01/30/2015 11:00 AM');
        BLN_ASC_WS_TicketCheckin.FailureTickets t2 = new BLN_ASC_WS_TicketCheckin.FailureTickets(Test_BLN_ASC_AddEvents.ticket.id,true,'01/30/2015 6:00 PM');
        BLN_ASC_WS_TicketCheckin.TicketCheckIn t3 = new BLN_ASC_WS_TicketCheckin.TicketCheckIn();
        BLN_ASC_WS_TicketCheckin.ticidsToUpdate t4 = new BLN_ASC_WS_TicketCheckin.ticidsToUpdate();
        
        
        RestContext.request.addParameter('Event_Id',BLN_ASC_WS_TicketCheckin.ScannedBy);
        string bodys = '{"poolid" : "","trowid":"1", "tprice" : 150,"tags" : [],"tqty" : 30,"tname" : "iPad air ticket","subpackagegroup" : [],"ispackage" : false,"tdesc" : "","tvisib" : true,"tpaytype" : "Paid","itemtype" : "a1Ac0000000cNTAEA2","grouptickets" : [{"edate" : "12/09/2014 07:30 pm","sdate" : "12/06/2014 07:30 pm","tprice" : 150,"minqty" : "1","maxqty" : 20,"tname" : "iPad air ticket","itemid" : "","poolid" : "a18c0000000WS0zAAG","qty" : 30}],"ticketcount" : "1"}';
        blob b = blob.valueOf(bodys);
		RestContext.request.requestBody  = b;
		//RestContext.request = req;
        
        //RestContext.request.requestURI ='/GlobalnestEM/BLN_ASC_EventSchedule';//{"poolid" : "","trowid":"1", "tprice" : 150,"tags" : [],"tqty" : 30,"tname" : "iPad air ticket","subpackagegroup" : [],"ispackage" : false,"tdesc" : "","tvisib" : true,"tpaytype" : "Paid","itemtype" : "a1Ac0000000cNTAEA2","grouptickets" : [{"edate" : "12/09/2014 07:30 pm","sdate" : "12/06/2014 07:30 pm","tprice" : 150,"minqty" : "1","maxqty" : 20,"tname" : "iPad air ticket","itemid" : "","poolid" : "a18c0000000WS0zAAG","qty" : 30}],"ticketcount" : "1"}
        
        
        BLN_ASC_WS_TicketCheckin chck = new BLN_ASC_WS_TicketCheckin();
        try{
            BLN_ASC_WS_TicketCheckin.dopost();    
        }catch(Exception Ex){ } 
    }
}