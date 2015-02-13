/******************************************************
*   Author                  : Mythily Nagandla
*   Date                    : 10/12/2014 
*   Purpose                 : This is Web Service class for deleting ticket.


********************************************************/




@RestResource(urlMapping='/BLN_ASC_deleteTickets/*')
global class BLN_ASC_deleteTickets{

global static maincontainer  Mc {get ; set ;}
@HttpPost  
  global static maincontainer  doPost(){ //Post Mthod
  RestRequest req = RestContext.Request;
  Mc = new maincontainer();
  string poolid = req.params.get('poolid');//Getting pool id from requsted parameter
  
  //Reusing the deleteItemPool method from bln_eventseditcon class to delete ticket
  BLN_ReUse_EventsEditCon.deleteItemPool(poolid);
  
  Mc.success = 'success';
  
  
  return Mc;
  
  
  }
  
  global class maincontainer{
  public string success {get ; set ;}
  public maincontainer(){}
  
  }


}