public without sharing class BLN_Ticket_DAO{
  /**
* @author :Arindam Sarkar
* @date 05/12/2014
* @ This class is used for DML operations on Ticket object
*/ 
     
    //Updating the tickets  
    public BLN_StatusMessage insertTicket(List<Ticket__c> tckt){
        dataBase.saveResult[] saveRes = dataBase.insert(tckt,false); 
        return new BLN_StatusMessage(saveRes);
    }
    
    //Updating the tickets  
    public BLN_StatusMessage updateTicket(List<Ticket__c> tckt){
        dataBase.saveResult[] saveRes = dataBase.update(tckt,false); 
        return new BLN_StatusMessage(saveRes);
    }
    
    //Updating the tickets  
    public BLN_StatusMessage updateTicket(Ticket__c tckt){
        dataBase.saveResult saveRes = dataBase.update(tckt,false); 
        return new BLN_StatusMessage(saveRes);
    }

    // This method return user booked tickets 
    public List<Ticket__c> userOrderAndTickets(string str){
        string query1 = 'Select First_Name__c,Tstatus_Id__r.Tstatus_name__c,Tag_No__c,Email__c,Last_Name__c,Company__c,item_pool__c,badgeparentid__c,(select id,name,item__r.item_Name__c from badgeparentids__r),Tstatus_Id__c,order__r.id,item__r.item_Name__c,Badge_Label__c,Badge_ID__c,Badge_ID__r.name,(select id,name,Badge_Label__c from badges__r where cancel_time__c=null and Exp_time__c=null limit 1),order__r.Name,Client_Company__r.Name,Name,Item_Type__r.Name ,Client_GN_User__c,Client_GN_User__r.phone__c,Client_GN_User__r.user__r.id,Client_GN_User__r.user__r.MobilePhone,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Order_Item__c,event__c,Parent_ID__c,item_pool__r.item_type__r.Name,Client_GN_User__r.Mobile__c   From Ticket__c t '+ str;
       //(select id,name,Tstatus_name__c from Tstatus_Id__r ORDER BY LastModifiedDate DESC),
      
        List<Ticket__c> ticketsbooked = dataBase.query(query1);
        return ticketsbooked; 
    }

    //for getting available tickets for an item
    public List<Ticket__c> userOrderAndTickets(set<id> idvalues,String userId,string eveId) {
        List<Ticket__c> tckt = new List<Ticket__c>();
        if(eveId=='All'){
            tckt=[select  id,Tstatus_Id__r.Tstatus_name__c,Tstatus_Id__c,name,Tag_No__c,order__c,item__r.event__r.Name,item__r.item_Name__c ,Event__r.End_Date__c,Event__c,Item_Type__r.name,Ticket_Status__c,Parent_ID__c,Item_Pool__r.Badgable__c,Badge_ID__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.user__r.Email,Client_GN_User__r.Email__c,Client_GN_User__r.user__r.userName,item__r.Ticket_Settings__c,item__r.Item_Pool__r.Item_Pool_Name__c,item__r.item_type__r.Name from Ticket__c where order__c NOT IN :idvalues and  Client_GN_User__r.user__c=:userId];
        }else{
            tckt=[select  id,Tstatus_Id__r.Tstatus_name__c,Tstatus_Id__c,name,order__c,Tag_No__c,item__r.event__r.Name,item__r.item_Name__c ,Event__r.End_Date__c,Event__c,Item_Type__r.name,Ticket_Status__c,Parent_ID__c,Item_Pool__r.Badgable__c,Badge_ID__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.user__r.Email,Client_GN_User__r.Email__c,Client_GN_User__r.user__r.userName,item__r.Ticket_Settings__c,item__r.Item_Pool__r.Item_Pool_Name__c,item__r.item_type__r.Name  from Ticket__c where order__c NOT IN :idvalues and  Client_GN_User__r.user__c=:userId and event__c=:eveId];
        }   
        system.debug('Ticket Object Fetch From Database');
        return tckt;
    } 

    //Common Method For Get Ticket Information based on fields and condition
    public List<Ticket__c> getTickets(String fields,String whereCondition){
        List<Ticket__c> tc;
        String sql='select '+fields+' from Ticket__c  where '+whereCondition;
         system.debug('   Sql 0000000000000000  '+sql);
        tc=Database.query(sql);
        return tc;    
    }
    
    //Get Tickets Based on selected Items
    public LIST<Ticket__c> getSelectedTickets(LIST<Id> itemIds){
        LIST<Ticket__c> ticketsList = new LIST<Ticket__c>();
        
        ticketsList = [SELECT ID, NAME,Tstatus_Id__r.Tstatus_name__c,Tstatus_Id__c,Event__c,Parent_ID__c FROM Ticket__c  WHERE item__c IN: itemIds];
        return ticketsList;
    }
    
    //Get Tickets not availabletickets Based on selected Item
    public LIST<Ticket__c> getTicketsforItem(String itemId){
        LIST<Ticket__c> ticketsList = new LIST<Ticket__c>();        
        ticketsList= [SELECT ID, NAME, Event__c, Parent_ID__c, Client_GN_User__r.First_Name__c, Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c,  (SELECT ID, Item_Question__c, Answer__c, User__c, Item_Question__r.Name, Item_Question__r.Question__r.Question_Text__c, UAnswer_Text__c FROM User_Answers__r) FROM Ticket__c  WHERE item__c =: itemId AND Ticket_Status__c !=: 'Available'];
        return ticketsList;
    }
    // This Method is used to get all tickets along with GN User Information belongs to a particular Event written by Manasa Gandham
    
    public LIST<Ticket__c> ticketsListForEvent(String EventId, Date FromDate, Date ToDate){
        
        LIST<Ticket__c> ticketsList= new LIST<Ticket__c>();
        //ticketsList= database.query('SELECT ID, Name, order__c, item__r.item_Name__c , Item_Type__r.name,Client_GN_User__r.Mobile__c, Ticket_Status__c, Parent_ID__c, Item_Pool__r.Badgable__c, Badge_Label__c, Client_GN_User__r.First_Name__c, Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c,  TKT_Job_Title__c Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c, Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c,  Client_GN_User__r.Prefix__c,Client_GN_User__r.Prefix__c, Client_GN_User__r.Suffix__c, Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c,  item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,First_Name__c,Last_Name__c,Email__c FROM Ticket__c WHERE '+Condition);
        system.debug('  DAO CLASS0000000 '+FromDate+'   '+ToDate+'    '+EventId);
        if(FromDate != NULL && ToDate != NULL){
        
            ticketsList= [SELECT ID, Name,Tstatus_Id__r.Tstatus_name__c,Tstatus_Id__c, Tag_No__c, order__c, item__c, item__r.item_Name__c , Item_Type__r.name, Client_GN_User__c, Client_GN_User__r.Mobile__c, Ticket_Status__c, Parent_ID__c, Item_Pool__r.Badgable__c, Badge_Label__c, Client_GN_User__r.First_Name__c, Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c,  TKT_Job_Title__c, Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c, Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c, Client_GN_User__r.Prefix__c, Client_GN_User__r.Suffix__c, Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c, item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,Client_Company__r.Name, First_Name__c,Last_Name__c,Email__c, Company__c,   
                          (SELECT Id, Item_Question__c, Item_Question__r.Question_Level__c, Item_Question__r.Item__c, Item_Question__r.Question__r.Question_Text__c, UAnswer_Text__c, Answer__c, Answer__r.Answer_Text__c, User__c, Item_Question__r.Item__r.item_Name__c FROM User_Answers__r)
                          FROM Ticket__c 
                          WHERE Event__c =: EventId
                          AND Ticket_Status__c =: 'Booked'
                          AND CreatedDate >=: FromDate
                          AND CreatedDate <=: ToDate];
        }else{
            ticketsList= [SELECT ID, Name, Tag_No__c,Tstatus_Id__r.Tstatus_name__c,Tstatus_Id__c, order__c, item__c, item__r.item_Name__c , Item_Type__r.name, Client_GN_User__c, Client_GN_User__r.Mobile__c, Ticket_Status__c, Parent_ID__c, Item_Pool__r.Badgable__c, Badge_Label__c, Client_GN_User__r.First_Name__c, Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c,  TKT_Job_Title__c, Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c, Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c,  Client_GN_User__r.Prefix__c, Client_GN_User__r.Suffix__c, Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c,  item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,Client_Company__r.Name, First_Name__c,Last_Name__c,Email__c, Company__c,  
                          (SELECT Id, Item_Question__c, Item_Question__r.Question_Level__c, Item_Question__r.Item__c, Item_Question__r.Question__r.Question_Text__c, UAnswer_Text__c, Answer__c, Answer__r.Answer_Text__c, User__c, Item_Question__r.Item__r.item_Name__c FROM User_Answers__r)
                          FROM Ticket__c 
                          WHERE Event__c =: EventId
                          AND Ticket_Status__c =: 'Booked'];
        }
        system.debug(ticketsList.size()+'  DAO CLASS11111111 '+FromDate+'   '+ToDate+'    '+EventId);
        return ticketsList;
    }
    /*
    //This method is used to filter the attendees
    public LIST<Ticket__c> ticketsFilterListForEvent(String EventId, SET<Id> TicketIds, String selectedAttendeeType){
        
        LIST<Ticket__c> ticketsList= new LIST<Ticket__c>();
       if(selectedAttendeeType=='All'){
        
            ticketsList= [SELECT ID, Name, Tag_No__c, order__c, item__c, item__r.item_Name__c , Item_Type__r.name, Client_GN_User__c, Client_GN_User__r.Mobile__c, Ticket_Status__c, Parent_ID__c, Item_Pool__r.Badgable__c, Badge_Label__c, Client_GN_User__r.First_Name__c, Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c,  TKT_Job_Title__c, Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c, Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c, Client_GN_User__r.User_Type__c , Client_GN_User__r.User_Website__c,Client_GN_User__r.Prefix__c, Client_GN_User__r.Suffix__c, Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c, item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,Client_Company__r.Name, First_Name__c,Last_Name__c,Email__c, Company__c,   
                          (SELECT Id, Item_Question__c, Item_Question__r.Question_Level__c, Item_Question__r.Item__c, Item_Question__r.Question__r.Question_Text__c, UAnswer_Text__c, Answer__c, Answer__r.Answer_Text__c, User__c, Item_Question__r.Item__r.item_Name__c FROM User_Answers__r)
                          FROM Ticket__c 
                          WHERE Event__c =: EventId
                          AND (Ticket_Status__c =: 'Booked' OR Ticket_Status__c =: 'Cancelled')
                          AND Id IN : TicketIds];
        }else if(selectedAttendeeType=='Booked'){
            ticketsList= [SELECT ID, Name, Tag_No__c, order__c, item__c, item__r.item_Name__c , Item_Type__r.name, Client_GN_User__c, Client_GN_User__r.Mobile__c, Ticket_Status__c, Parent_ID__c, Item_Pool__r.Badgable__c, Badge_Label__c, Client_GN_User__r.First_Name__c, Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c,  TKT_Job_Title__c, Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c, Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c, Client_GN_User__r.User_Type__c , Client_GN_User__r.Prefix__c, Client_GN_User__r.Suffix__c, Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c,  item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,Client_Company__r.Name, First_Name__c,Last_Name__c,Email__c, Company__c,  
                          (SELECT Id, Item_Question__c, Item_Question__r.Question_Level__c, Item_Question__r.Item__c, Item_Question__r.Question__r.Question_Text__c, UAnswer_Text__c, Answer__c, Answer__r.Answer_Text__c, User__c, Item_Question__r.Item__r.item_Name__c FROM User_Answers__r)
                          FROM Ticket__c 
                          WHERE Event__c =: EventId
                          AND Ticket_Status__c =: 'Booked'
                          AND Id IN : TicketIds];
        }else if(selectedAttendeeType=='Cancelled'){
            ticketsList= [SELECT ID, Name, Tag_No__c, order__c, item__c, item__r.item_Name__c , Item_Type__r.name, Client_GN_User__c, Client_GN_User__r.Mobile__c, Ticket_Status__c, Parent_ID__c, Item_Pool__r.Badgable__c, Badge_Label__c, Client_GN_User__r.First_Name__c, Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c,  TKT_Job_Title__c, Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c, Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c, Client_GN_User__r.User_Type__c , Client_GN_User__r.Prefix__c, Client_GN_User__r.Suffix__c, Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c,  item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,Client_Company__r.Name, First_Name__c,Last_Name__c,Email__c, Company__c,  
                          (SELECT Id, Item_Question__c, Item_Question__r.Question_Level__c, Item_Question__r.Item__c, Item_Question__r.Question__r.Question_Text__c, UAnswer_Text__c, Answer__c, Answer__r.Answer_Text__c, User__c, Item_Question__r.Item__r.item_Name__c FROM User_Answers__r)
                          FROM Ticket__c 
                          WHERE Event__c =: EventId
                          AND Ticket_Status__c =: 'Cancelled'
                          AND Id IN : TicketIds];
        }
        return ticketsList;
    }*/
    
    public LIST<Ticket__c> ticketsListWithDates(String EventId, String SearchString, Date FromDate, Date ToDate){
        
        system.debug(EventId+'  FROM DATEEEEEEEEEEE   '+SearchString);
        LIST<Ticket__c> ticketsList= new LIST<Ticket__c>();
        //ticketsList= database.query('SELECT ID, Name, order__c, item__r.item_Name__c , Item_Type__r.name,Client_GN_User__r.Mobile__c, Ticket_Status__c, Parent_ID__c, Item_Pool__r.Badgable__c, Badge_Label__c, Client_GN_User__r.First_Name__c, Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c,  TKT_Job_Title__c Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c, Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c, Client_GN_User__r.Prefix__c,Client_GN_User__r.Prefix__c, Client_GN_User__r.Suffix__c, Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c, item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,First_Name__c,Last_Name__c,Email__c FROM Ticket__c WHERE '+Condition);
        if(SearchString == NULL && (FromDate != NULL && ToDate != NULL)){
            ticketsList= [SELECT ID, Name, order__c,Tstatus_Id__r.Tstatus_name__c,Tstatus_Id__c, item__r.item_Name__c , Item_Type__r.name,Client_GN_User__r.Mobile__c, Ticket_Status__c, Parent_ID__c, Item_Pool__r.Badgable__c, Badge_Label__c, Client_GN_User__r.First_Name__c,  Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c,  TKT_Job_Title__c, Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c,  Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c,  Client_GN_User__r.Prefix__c, Client_GN_User__r.Suffix__c,  Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c,  item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,First_Name__c,Last_Name__c,Email__c  
                          FROM Ticket__c 
                          WHERE Event__c =: EventId 
                          AND Ticket_Status__c !=: 'Available'
                          AND Order__r.CreatedDate >=: FromDate
                          AND Order__r.CreatedDate <=: ToDate];
           
        }else if(SearchString != NULL && (FromDate == NULL && ToDate == NULL)){
            ticketsList= [SELECT ID, Name, order__c,Tstatus_Id__r.Tstatus_name__c,Tstatus_Id__c, item__r.item_Name__c , Item_Type__r.name,Client_GN_User__r.Mobile__c, Ticket_Status__c, Parent_ID__c, Item_Pool__r.Badgable__c, Badge_Label__c, Client_GN_User__r.First_Name__c,  Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c,  TKT_Job_Title__c, Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c,  Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c,Client_GN_User__r.Prefix__c, Client_GN_User__r.Suffix__c,  Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c,  item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,First_Name__c,Last_Name__c,Email__c  
                          FROM Ticket__c 
                          WHERE Event__c =: EventId 
                          AND Ticket_Status__c !=: 'Available'
                          AND (Order__r.name LIKE : '%'+SearchString+'%' OR Client_GN_User__r.First_Name__c Like: '%'+SearchString+'%' OR Client_GN_User__r.Last_Name__c Like: '%'+SearchString+'%' OR Client_GN_User__r.Email__c Like: '%'+SearchString+'%' OR Client_Company__r.Name Like: '%'+SearchString+'%' OR item__r.item_Name__c Like: '%'+SearchString+'%')];

        
        }else if(SearchString != NULL && (FromDate != NULL && ToDate != NULL)){
            ticketsList= [SELECT ID, Name, order__c,Tstatus_Id__r.Tstatus_name__c,Tstatus_Id__c, item__r.item_Name__c , Item_Type__r.name,Client_GN_User__r.Mobile__c, Ticket_Status__c, Parent_ID__c, Item_Pool__r.Badgable__c, Badge_Label__c, Client_GN_User__r.First_Name__c,  Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c,  TKT_Job_Title__c, Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c,  Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c,  Client_GN_User__r.Prefix__c,  Client_GN_User__r.Suffix__c,  Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c,  item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,First_Name__c,Last_Name__c,Email__c  
                          FROM Ticket__c 
                          WHERE Event__c =: EventId 
                          AND Ticket_Status__c !=: 'Available'
                          AND Order__r.CreatedDate >=: FromDate
                          AND Order__r.CreatedDate <=: ToDate           
                          AND (Order__r.name LIKE : '%'+SearchString+'%' OR Client_GN_User__r.First_Name__c Like: '%'+SearchString+'%' OR Client_GN_User__r.Last_Name__c Like: '%'+SearchString+'%' OR Client_GN_User__r.Email__c Like: '%'+SearchString+'%' OR Client_Company__r.Name Like: '%'+SearchString+'%' OR item__r.item_Name__c Like: '%'+SearchString+'%')];

        }else{
            ticketsList= [SELECT ID, Name, order__c, Tstatus_Id__r.Tstatus_name__c,Tstatus_Id__c,item__r.item_Name__c , Item_Type__r.name,Client_GN_User__r.Mobile__c, Ticket_Status__c,Parent_ID__c, Item_Pool__r.Badgable__c, Badge_Label__c, Client_GN_User__r.First_Name__c, Client_GN_User__r.Last_Name__c, Client_GN_User__r.Email__c, TKT_Job_Title__c, Client_GN_User__r.Phone__c, Client_GN_User__r.Address1__c, Client_GN_User__r.Address2__c, Client_GN_User__r.City__c, Client_GN_User__r.State__r.Long_Name__c, Client_GN_User__r.Country__r.Long_Name__c, Client_GN_User__r.Zip_Code__c, Client_GN_User__r.DOB__c, Client_GN_User__r.Prefix__c, Client_GN_User__r.Suffix__c, Client_GN_User__r.user__r.Id, Client_GN_User__r.user__r.Email, item__r.Ticket_Settings__c,  item__r.Item_Pool__r.Item_Pool_Name__c, item__r.item_type__r.Name, Client_Company__r.Id,First_Name__c,Last_Name__c,Email__c 
                          FROM Ticket__c 
                          WHERE Event__c =: EventId
                          AND Ticket_Status__c !=: 'Available']; 
        }
        
        
        return ticketsList;
    }
    
    // All Booked Tickets For An Item 
    
     public LIST<Ticket__c> bookedTicketsForItem(String itemId){
        LIST<Ticket__c> bookedTickets= new LIST<Ticket__c>();
        bookedTickets= [SELECT Id, Tstatus_Id__r.Tstatus_name__c,Tstatus_Id__c,(SELECT Id FROM User_Answers__r)
                           FROM Ticket__c 
                           WHERE item__c =: itemId
                           AND Ticket_Status__c =: 'Booked'];
        //bookedTickets= Integer.valueOf(bookedAggrResult[0].get('expr0'));
        system.debug(itemId+'   '+bookedTickets.size()+'   AGGREGATE RESULT '+bookedTickets);                   
        return bookedTickets;
    }

}