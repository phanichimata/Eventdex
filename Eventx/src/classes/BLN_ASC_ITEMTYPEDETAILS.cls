@RestResource(urlMapping='/BLN_ASC_ITEMTYPEDETAILS/*')
/***********************************************************************************************
*   Service Name : BLN_ASC_ITEMTYPEDETAILS
*   Date            : 06/02/2015
*   Author          : Arindam Sarkar
*   Purpose         : This class is for getting all details of a itemtype like sponsor,exhibitor,etc.
************************************************************************************************/
  

    global with sharing class BLN_ASC_ITEMTYPEDETAILS{
   
    @HttpPost  
    global static MainContainer doPost(){
        RestRequest req = RestContext.request;  
        String ItemTypeName= req.params.get('ItemType_Name');
        
        String EventID=req.params.get('Event_Id');
        MainContainer mc=new MainContainer();
             
        RestResponse response = RestContext.response;
        mc.ItemTypeName=ItemTypeName;
        
        //Attendee is admission
        if(ItemTypeName=='Attendee')
        ItemTypeName='Admissions';
        
        //GET ALL THE USER AND COMPANY INFORMATION FROM BOOKED TICKET BASED ON POOLID or TICKETID
        String q='select id,name,Item_Type__c,Item__r.Item_Type__r.name,Item_Type__r.name,Item_Pool__c,Client_GN_User__c,Client_Company__c,Ticket_Status__c,Client_GN_User__r.Home_Phone__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_GN_User__r.User_Pic__c,Client_GN_User__r.User__c,Client_GN_User__r.City__c,Client_GN_User__r.State__c,Client_GN_User__r.Country__c,Client_GN_User__r.FaceBookId__c,Client_GN_User__r.LinkedInId__c,Client_Company__r.Company_Logo__c,Client_Company__r.Name,Client_Company__r.Website_URL__c from Ticket__c where Item__r.Item_Type__r.Name=\''+ItemTypeName+'\' and Event__c=\''+EventID+'\' and (Ticket_Status__c=\'Booked\' or Ticket_Status__c=\'Checked-in\' or Ticket_Status__c=\'Checked-out\')';
        
         
         List<Ticket__c> Ticket=Database.query(q);
         
         
         //For sponsor get the room number also
         Map<Id,String> partcpmap=new Map<Id,String>();
         String idInClause = '(\'';
         if(ItemTypeName=='Speaker'&&Ticket.size()>0){
         
         for(integer i=0;i<Ticket.size();i++){
         idInClause += Ticket[i].Client_GN_User__c+ '\',\'';}
         if(idInClause.length()<4)
         idInClause='';
         if(idInClause!=''){
         idInClause  = idInClause.substring(0,idInClause.length()-2);
         idInClause += ')';
         
         String qs = 'Select id,name,Participant_Role__c,GN_User__c,Time_Slot__c,Time_Slot__r.Room__r.Name,Time_Slot__r.Room__r.Event__c from Participant__c where GN_User__c in ' + idInClause+' and Time_Slot__r.Room__r.Event__c=\''+EventID+'\'';
        List<Participant__c> partcplist=Database.query(qs);
        for(Participant__c p:partcplist)
         {
          partcpmap.put(p.GN_User__c,p.Time_Slot__r.Room__r.Name); 
         }
        
         
         
         }
         
         
         }
         //
          
         
         List<Container> container=new List<Container>();
         for(Ticket__c tc:Ticket)
         {
          Container cnt=new Container();
          cnt.FirstName=tc.Client_GN_User__r.First_Name__c==null?'':tc.Client_GN_User__r.First_Name__c;
          cnt.LastName=tc.Client_GN_User__r.Last_Name__c==null?'':tc.Client_GN_User__r.Last_Name__c;
          cnt.Email=tc.Client_GN_User__r.Email__c==null?'':tc.Client_GN_User__r.Email__c;
          cnt.CompanyName=tc.Client_Company__r.Name==null?'':tc.Client_Company__r.Name;
          //cnt.UserWebSite=tc.Client_GN_User__r.User_Website__c==null?'':tc.Client_GN_User__r.User_Website__c;
          cnt.UserPhoto=tc.Client_GN_User__r.User_Pic__c==null?'':tc.Client_GN_User__r.User_Pic__c;
          cnt.GnuserID=tc.Client_GN_User__c==null?'':tc.Client_GN_User__c;
          cnt.SfuserID=tc.Client_GN_User__r.User__c==null?'':tc.Client_GN_User__r.User__c;
          cnt.CompanyID=tc.Client_Company__c==null?'':tc.Client_Company__c;
          cnt.City=tc.Client_GN_User__r.City__c==null?'':tc.Client_GN_User__r.City__c;
          cnt.State=tc.Client_GN_User__r.State__c==null?'':tc.Client_GN_User__r.State__c;
          cnt.Country=tc.Client_GN_User__r.Country__c==null?'':tc.Client_GN_User__r.Country__c;
          cnt.Facebook=tc.Client_GN_User__r.FaceBookId__c==null?'':tc.Client_GN_User__r.FaceBookId__c;
          cnt.Linkedin=tc.Client_GN_User__r.LinkedInId__c==null?'':tc.Client_GN_User__r.LinkedInId__c;
          cnt.CompanyWebSite=tc.Client_Company__r.Website_URL__c==null?'':tc.Client_Company__r.Website_URL__c;
          cnt.CompanyLogo=tc.Client_Company__r.Company_Logo__c==null?'':tc.Client_Company__r.Company_Logo__c; 
          cnt.Phone=tc.Client_GN_User__r.Home_Phone__c==null?'':tc.Client_GN_User__r.Home_Phone__c; 
          cnt.RoomNameForSpeaker=partcpmap.get(tc.Client_GN_User__c)!=null?partcpmap.get(tc.Client_GN_User__c):'';
          container.add(cnt); 
         }
         mc.details=new List<Container>();
         mc.details=container;
         mc.ImagePath=URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id=';
         return mc;
        
      }
      
      
      
      global Class Container
      {
           public String FirstName{get;set;}
           public String LastName{get;set;}
           public String Email{get;set;}
           public String CompanyName{get;set;}
           public String UserWebSite{get;set;}
           public String UserPhoto{get;set;}
           public String GnuserID{get;set;}
           public String SfuserID{get;set;}
           public String CompanyID{get;set;}
           public String City{get;set;}
           public String State{get;set;}
           public String Country{get;set;}
           public String Facebook{get;set;}
           public String linkedin{get;set;}
           public String CompanyWebSite{get;set;}
           public String CompanyLogo{get;set;}
           public String Phone{get;set;}
           public String RoomNameForSpeaker{get;set;}
           
      }
      
      global class MainContainer
      {
         List<Container> details{get;set;}
         
         public String ItemTypeName{get;set;}
         public String ImagePath{get;set;}
      }
      
      
    
        
      
      
      }