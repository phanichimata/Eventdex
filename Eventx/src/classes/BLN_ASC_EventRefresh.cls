/***********************************************************************************************
*   Service Name : BLN_ASC_EventRefresh
*   Date            : 30/12/2014
*   Author          : Arindam Sarkar
*   Purpose         : This class is Web service Class to to change the badge template, sales tax and paypal email id for event admin for a selected event on the server.
**************************************************************************************************/

@RestResource(urlMapping='/BLN_ASC_EventRefresh')

global class BLN_ASC_EventRefresh{

 @HttpPost  
    global static Main doPost(){
    RestRequest req = RestContext.request; 
        String EventId= req.params.get('Event_Id'); 
        String LastModifiedDate= req.params.get('LastModifiedDate');
        String UserId= req.params.get('User_id');
         String appname = req.params.get('appname');
        
        
        
        BLN_ASC_Events.maincontainer ascEve=BLN_ASC_Events.doPost();
        
        BLN_ASC_Checkin.TotalList ascCheckin=BLN_ASC_Checkin.doPost();
        
        List<BLN_ASC_ItemsList.Itemscls_info> ascItemlist=BLN_ASC_ItemsList.doPost();
        system.debug('PPPPPPPP '+ascEve);
        BLN_ASC_EventRefresh.Main m=new BLN_ASC_EventRefresh.Main();
        m.BLN_ASC_EventsOUTPUT=ascEve;
        m.BLN_ASC_CheckinOUTPUT=ascCheckin;
        m.BLN_ASC_ItemsListOUTPUT=ascItemlist;
        
        return m;
    
    }
    
    
    global class Main
    {
       BLN_ASC_Events.maincontainer BLN_ASC_EventsOUTPUT{get;set;}
       BLN_ASC_Checkin.TotalList BLN_ASC_CheckinOUTPUT{get;set;}
       List<BLN_ASC_ItemsList.Itemscls_info> BLN_ASC_ItemsListOUTPUT{get;set;}
    }
    
    
    
    
    
 }