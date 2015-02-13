/***********************************************************************************************
*   Service Name : BLN_ASC_EventSettings
*   Date            : 30/12/2014
*   Author          : Arindam Sarkar
*   Purpose         : This class is Web service Class to to change the badge template, sales tax and paypal email id for event admin for a selected event on the server.
**************************************************************************************************/

@RestResource(urlMapping='/BLN_ASC_EventSettings')

global class BLN_ASC_EventSettings{

 @HttpPost  
    global static Response doPost(){
        RestRequest req = RestContext.request; 
        String EventId= req.params.get('EventId'); 
        String BadgeName= req.params.get('BadgeName');
        BLN_Events_DAO evdao=new BLN_Events_DAO();
        MAP<Id, Database.UpsertResult> eventSaveResult = new MAP<Id, Database.UpsertResult>();
        Response rsp=new Response();
        boolean success=false;
        try{
        if(BadgeName!=null)
        {  
        system.debug('Badge Name'+BadgeName);
          LIST<Database.UpsertResult> dbr  = evdao.updateBadge(EventId,BadgeName);
          for(Database.UpsertResult r: dbr){
            if(r.isSuccess()){
                success = true;
                  }
              }  
           
        }
        String SalesTax= req.params.get('SalesTax');
        
        if(SalesTax!=null)
        {

           String isTaxApplicable = req.params.get('isTaxApplicable');

             LIST<Database.UpsertResult> dbr  = evdao.updateSalesTax(EventId,Decimal.valueOf(SalesTax),Boolean.valueOf(isTaxApplicable));
          for(Database.UpsertResult r: dbr){
            if(r.isSuccess()){
                success = true;
                  }
              }  
        }
        String PayPal_EmailID= req.params.get('PayPal_EmailID');
        if(PayPal_EmailID!=null)
        {
           success=evdao.updatepgemail(EventId,PayPal_EmailID);
        }
        RestResponse response = RestContext.response; 
        
        if(success==true)
        rsp.success='updated succesfully';
        }catch(Exception e)
        {
        rsp.error=e.getMessage();
        }
        return rsp;
        }
        
        
        global class Response{
        
        public String success{get;set;}
        public String error{get;set;}
        
    }
        
        
        

}