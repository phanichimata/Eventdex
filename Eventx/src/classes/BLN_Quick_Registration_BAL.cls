/**************************************************
* @author :Arindam Sarkar
* @date 05/11/2014
* @ This class is used for Quick Registration module
****************************************************/


public without sharing class BLN_Quick_Registration_BAL{
public string orderId{get;set;}

//Check user availability
public String checkUser(User newu)
{
   
   BLN_User_DAO blnuserDao = new BLN_User_DAO();
      user user = new user();
      user = blnuserDao.CheckUser(newu.email);
      return user.id!=null?user.id:null;
}

//GetExistingUSerInformation for Ajax call
public User getExistingUser(String email){
    BLN_User_DAO blnuserDao = new BLN_User_DAO();
    user user = new user();
    user = blnuserDao.CheckUser(email);
    return user;
}


//Check Company Availability
public String checkCompany(Company__c newcomp){
    BLN_Company_DAO blncmpDao = new BLN_Company_DAO();
    Company__c comp = new Company__c ();
    comp = blncmpDao.checkCompany(newcomp.name);
    return comp.id!=null?comp.id:null;
}

//Check User Email
public String checkUserEmail(String Email){
    BLN_User_DAO blnuserDao = new BLN_User_DAO();
    user user = new user();
    user = blnuserDao.CheckUser(Email);
    return user.id!=null?user.id:null;
}


// Inserting GN User
public BLN_StatusMessage insertGNUser(GN_User__c NewUser){

    BLN_User_DAO UserDAO = new BLN_User_DAO();
    
    User SFUser = new User();
    
    String UserEmail;
    if(checkUserEmail(NewUser.Email__c) != NULL){
        UserEmail = checkUserEmail(NewUser.Email__c);
    }
    else{
        SFUser.FirstName = NewUser.First_Name__c;
        SFUser.LastName = NewUser.Last_Name__c;
        SFUser.Email = NewUser.Email__c;
       // SFUser.Title= NewUser.Title__c;
        SFUser.Phone= NewUser.Phone__c;
       /* if(newUser.Company_Name__c != NULL && newUser.Company_Name__c !=''){
            SFUser.Companyname= NewUser.Company_name__c;
        }else{
            SFUser.Companyname= NewUser.First_Name__c + NewUser.Last_Name__c;
        }
        */
        BLN_StatusMessage userMsg = insertUser(SFUser);
        if(userMsg.successBool){
            UserEmail = userMsg.successId;
        }
    }
    //NewUser.User__c = UserEmail;
    
    BLN_StatusMessage StatusMessage = UserDAO.insertGNUser(NewUser);
    return StatusMessage;
}


//Inserting User
public BLN_StatusMessage insertUser(user newu){
    BLN_User_DAO blnuserDao = new BLN_User_DAO();
    
    //Insert Contact
    contact Con = new Contact();
    Con.Lastname = newu.Lastname ;
    Con.Firstname =newu.Firstname ; 
    con.email = newu.email;
    
    string contactId = blnuserDao.account_Contact(con);
    //Get Profile
    Profile P = [SELECT Id,Name FROM Profile WHERE Name = 'Event Admin'];
    user u = new user();
    U.ContactID =contactId;    
    U.Username = newu.email;  
    U.Email = newu.email;
    U.LastName = newu.LastName;
    U.FirstName = newu.FirstName;
    U.CompanyName = newu.CompanyName;
    U.phone= newu.phone;
    U.title= newu.title;
    U.Alias = 'EAdmin';
    U.ProfileID = P.id;
    U.Eff_Date__c=system.today();
    U.LocaleSidKey = 'en_US';
    U.LanguageLocaleKey = 'en_US';
    U.TimeZoneSidKey = 'America/Los_Angeles';
    U.EmailEncodingKey='UTF-8';
    U.CommunityNickname = String.valueOf(math.random());
    BLN_StatusMessage userMsg = blnuserDAO.createUser(u);

    return userMsg ;
}

//Updating User
public String updateUser(User U){
    BLN_User_DAO blnuserDao = new BLN_User_DAO();
    String userMsg = blnuserDAO.updateUser(u);
    return userMsg;
}

//Inserting Company
public BLN_StatusMessage insertCompany(Company__c newcomp,Company_Ext__c comext)
{
    BLN_Company_DAO blnCompanyDAO = new BLN_Company_DAO();
    BLN_StatusMessage companyMsg = blnCompanyDAO.insertCompany(newcomp);
    if(companyMsg.successBool)
    if(comext != null){
        blnCompanyDAO.insertcompdetails(companyMsg.successId,comext);
    }
    return companyMsg;    
}

//Inserting UCRole
public BLN_StatusMessage insertUCRole(String userId,String comId,String eventId,String role){
        BLN_UCRole_DAO companyRole = new BLN_UCRole_DAO();    
        system.debug('UserID in BAL:'+userId+' CompanyID in BAL:'+comId);
        UC_Role__c uRole = new UC_Role__c();
        uRole.Company__c = comId; 
        uRole.GN_User__c =userId;
        if(eventId!=''){
          uRole.Event__c=eventId;
        }
        BLN_User_DAO UserDAO = new BLN_User_DAO();
        GN_User__c GU = UserDAO.getGNUser(UserId);
        //uRole.User__c = GU.User__c;
        
        BLN_StatusMessage ucRoleMsg = companyRole.insertUCRole(uRole, role);
        system.debug('Inserted UC Role Id in BAL:'+ucRoleMsg);
        return ucRoleMsg;           
}


//Inserting UCRole
public BLN_StatusMessage insertUCRolewithUtype(String userId,String comId,String eventId,String role,string utype){
        BLN_UCRole_DAO companyRole = new BLN_UCRole_DAO();    
        system.debug('UserID in BAL:'+userId+' CompanyID in BAL:'+comId);
        UC_Role__c uRole = new UC_Role__c();
        uRole.Company__c = comId; 
        uRole.GN_User__c =userId;
        uRole.Event__c=eventId;
        uRole.user_type__c =utype;
        
        BLN_User_DAO UserDAO = new BLN_User_DAO();
        GN_User__c GU = UserDAO.getGNUser(UserId);
        //uRole.User__c = GU.User__c;
        
        BLN_StatusMessage ucRoleMsg = companyRole.insertUCRole(uRole, role);
        system.debug('Inserted UC Role Id in BAL:'+ucRoleMsg);
        return ucRoleMsg;           
}


    //Get Available Tickets 
    public LIST<selectOption> getAvailableTickets(LIST<BLN_Item__c> items){
    System.debug('ITEMSSSS '+items);
        BLN_Ticket_DAO tcdao=new BLN_Ticket_DAO();
        LIST<selectOption> myitems = new LIST<selectOption>();
        myitems.add(new selectOption('','Select One'));
        LIST<Ticket__c> tckt;
        for(BLN_Item__c item:items){
        
            
            tckt = tcdao.getTickets('id,name,Event__c,Item__r.Payment__c,Item__r.Event__c,Item__r.price__c,Item__r.item_name__c,Item_Type__r.name,item__r.Ticket_Settings__c,Ticket_Status__c,Parent_ID__c,Item_Pool__r.Badgable__c','Event__c=\''+item.Event__c +'\' and Item__r.id=\''+item.id+'\' and Ticket_Status__c=\'Available\' and Parent_ID__c=null order by name limit 1');
            if(tckt.size()>0){
                myitems.add(new selectOption(tckt[0].id,item.item_name__c));
            } 
        }
        return myitems;
    }
    
    //Get Event Details based on Id
    public BLN_Event__c geteventDetails(string eventId){
        BLN_Event_DAO evdao=new BLN_Event_DAO();
        LIST<BLN_Event__c> eventdetails=evdao.getEventDetails(eventId);
        if(eventdetails.size()>0)
            return eventdetails[0];
        else
            return new BLN_Event__c();
    }

    //Get Items For an Event
    public LIST<BLN_Item__c> getEventItems(String eventId){
        BLN_Item_DAO itmdao=new BLN_Item_DAO();
        LIST<BLN_Item__c> items=itmdao.getEventItems(eventId);
        if(items.size()>0)
            return items;
        else
            return new LIST<BLN_Item__c>();
    }
    
    
   
// ------------------------------------------------------ Edit for Regular Registration start by Mahesh Sakunala ----------------------------------------------------------------
   
        
    //Get Registration Template Details For an Event
    public Registration_Template__c getRegTempDetails(String RegTemplateId){
        BLN_RegTemplate_DAO regTempDAO = new BLN_RegTemplate_DAO();
        Registration_Template__c registrationTemplate = regTempDAO.getRegTempDetails(RegTemplateId);
        return registrationTemplate;
    }
    
    //Get Ticket Details
    public LIST<Ticket__c> getTicketDetail(BLN_Item__c Item, Integer RecordCount){
        // Getting Ticket Details from Ticket DAO
        BLN_Ticket_DAO TicketDAO = new BLN_Ticket_DAO();
        LIST<Ticket__c> TicketList = new LIST<Ticket__c>();
        LIST<Ticket__c> PackageTickets = new LIST<Ticket__c>();
        
        //Getting Package Tickets from Ticket DAO
        if(Item.Item_Type__r.Name == 'Package' && Item.Ticket_Settings__c == 'Collect info from All Attendees'){
           List<Ticket__c> tckt = TicketDAO.getTickets('id,name,Event__c,Item__r.item_name__c,Item_Pool__r.Item_Pool_Name__c,item__r.Ticket_Settings__c,Item_Pool__r.Ticket_Settings__c,Item_Type__r.name,Ticket_Status__c,Parent_ID__c,Item_Pool__r.Package_Flag__c,Item_Pool__r.Badgable__c','Event__c=\''+item.Event__c +'\' AND Item__r.item_name__c=\''+item.item_name__c+'\' AND Ticket_Status__c=\'Available\' AND Parent_ID__c=null AND Item_Pool__r.Badgable__c=\'N - No Badge\' ORDER BY Name LIMIT '+ RecordCount);     
           //AND Parent_ID__c=null 
           system.debug('Package Single Ticket: '+tckt);
         for(Ticket__c tc : tckt){  
           if(tc.Item_Pool__r.Package_Flag__c == 'P - Package item pool'){
               PackageTickets.addAll(TicketDAO.getTickets('id,name,Event__c,Item__r.item_type__r.Name,Item_Pool__r.Item_Pool_Name__c,Item__r.item_name__c,Item_Pool__r.Ticket_Settings__c,Client_GN_User__c,Client_Company__c,Order__c,Order_Item__c,item__r.Ticket_Settings__c,Item_Type__r.name,Parent_ID__c,Item_Pool__r.Package_Flag__c,Item_Pool__r.Badgable__c,Ticket_Status__c','Ticket_Status__c=\'Available\' and  Parent_ID__c=\''+tc.id+'\'')); 
               PackageTickets.add(tc);
               system.debug('Package Tickets: '+PackageTickets);
           }
         } 
        }
        else{
          if(Item.Item_Type__r.Name == 'Package'){
            TicketList = TicketDAO.getTickets('id,Item__r.item_type__r.Name,name,Event__c,Item__r.item_name__c,Item_Pool__r.Item_Pool_Name__c,item__r.Ticket_Settings__c,Item_Pool__r.Ticket_Settings__c,Item_Type__r.name,Ticket_Status__c,Item_Pool__r.Package_Flag__c,Parent_ID__c,Item_Pool__r.Badgable__c','Event__c=\''+item.Event__c +'\' AND Item__r.item_name__c=\''+item.item_name__c+'\' AND Ticket_Status__c=\'Available\' AND Parent_ID__c=null AND Item_Pool__r.Badgable__c=\'N - No Badge\' ORDER BY Name LIMIT '+ RecordCount);     
           }else{
            TicketList = TicketDAO.getTickets('id,name,Item__r.item_type__r.Name,Event__c,Item__r.item_name__c,Item_Pool__r.Item_Pool_Name__c,item__r.Ticket_Settings__c,Item_Pool__r.Ticket_Settings__c,Item_Type__r.name,Ticket_Status__c,Item_Pool__r.Package_Flag__c,Parent_ID__c,Item_Pool__r.Badgable__c','Event__c=\''+item.Event__c +'\' AND Item__r.item_name__c=\''+item.item_name__c+'\' AND Ticket_Status__c=\'Available\' AND Parent_ID__c=null AND Item_Pool__r.Badgable__c=\'B - Badge\' ORDER BY Name LIMIT '+ RecordCount);     
          
           }
        }
        TicketList.addAll(PackageTickets);
        return TicketList;
    }
    
    // Get Event Payment Gateways
    public LIST<Event_Pay_Gateway__c> getEventPayGateWays(String EventId){
        // Get Event Payment Gateways from Event PayGateway DAO 
        BLN_EventPayGateway_DAO EventPayGatewayDAO = new BLN_EventPayGateway_DAO();
        LIST<Event_Pay_Gateway__c> EventPayGateWays = EventPayGatewayDAO.getEventPayGateWays(EventId);
        
        return EventPayGateWays;
    }
    
    public List<Ticket__c> ticketsForupdatePkg{get;set;}
    // Update Ticket Details 
    public BLN_StatusMessage updateTickets(LIST<String> UserIds,LIST<String> CompanyIds,LIST<String> TicketIds,String EventId,String OrderUserId, Decimal SubTotal, Decimal DiscountAmount, Decimal FeeAmount,Decimal TaxAmount, Decimal AmountPaid, MAP<Id,Id> PromotionIdMap,Integer PromotionCount,String PromoCode, String PayAddress, String ChargeType, String PGatewayType,String ChargeId, String PGatewayMode,String Module){
        ticketsForupdatePkg = new List<Ticket__c>();
        BLN_StatusMessage TicketUpdateMessage;
        
        
        
        //Buying Tickets
        BLN_Ticket_DAO TicketDAO = new BLN_Ticket_DAO();
        
        //Get Currency
        BLN_Currency_DAO CurDAO =new BLN_Currency_DAO();
        Currency__c cur = CurDAO.getCurrencyDetails('id,name','name=\'USD\' LIMIT 1');
        
        //Get PGateway Type
        BLN_PGateway_Type_DAO PGatewayDAO = new BLN_PGateway_Type_DAO();
        if(PGatewayMode == 'Stripe'){
            PGatewayType = 'Stripe';
        }else if(PGatewayMode == 'Authorize .Net'){
            PGatewayType = 'Authorize.Net';
        }else{
           /*if(SubTotal<=0){
             PGatewayType = 'Free';
           }else{*/
              PGatewayType = PGatewayType;
           //}
        }
         
         Event_Pay_Gateway__c  PGateway = new Event_Pay_Gateway__c  ();
        
         try{
            PGateway = BLN_EventPayGateway_DAO.getEventPayGateWay(eventId,PGatewayType,Module);
          }catch(exception er){}
        //Get User Details
        BLN_User_DAO UserDAO = new BLN_User_DAO();
        GN_User__c UserDetails = UserDAO.getGNUser(OrderUserId);
        
        //Insert Order
        BLN_Order_DAO OrderDAO =new BLN_Order_DAO();
        Order__c   Order = new Order__c();
        if(CompanyIds.size()>0){
            Order = new Order__c(Events__c=eventId,Amount_Paid__c=AmountPaid,Client_GN_User__c=OrderUserId,Client_Company__c=CompanyIds[0],Order_Total__c=AmountPaid,Order_Sub_Total__c=SubTotal,Order_Discount__c=DiscountAmount,Order_Status__c='Fully Paid',Currency_Code__c=cur.id,Fee_Amount__c=FeeAmount,Order_Taxes__c=TaxAmount,Transaction_Status__c='Completed');
       }else{
           Order = new Order__c(Events__c=eventId,Amount_Paid__c=AmountPaid,Client_GN_User__c=OrderUserId,Order_Total__c=AmountPaid,Order_Sub_Total__c=SubTotal,Order_Discount__c=DiscountAmount,Order_Status__c='Fully Paid',Currency_Code__c=cur.id,Fee_Amount__c=FeeAmount,Order_Taxes__c=TaxAmount,Transaction_Status__c='Completed');
      
       }
       
        BLN_StatusMessage OrderMessage  =OrderDAO.insertorder(Order);
        try{
             orderId =OrderMessage.successId;
            }catch(exception er){}
        
        
        
        //Insert Payment
        BLN_payment_DAO PaymentDAO = new BLN_payment_DAO();
        Payment__c Payment = new Payment__c(Payment_Amount__c=AmountPaid,Order__c=OrderMessage.successId,Currency_Code__c=cur.id,Payment_Mode__c=ChargeType,event_paygateway_id__c=PGateway.id,Pay_Address__c=PayAddress,Payment_Ref_Number__c=ChargeId);
        BLN_StatusMessage PaymentMessage = PaymentDAO.insertPayment(Payment);
        
        //Update Promotion
        BLN_PromoCode_BAL PromotionBAL = new BLN_PromoCode_BAL();
        BLN_Promotion_DAO PromotionDAO = new BLN_Promotion_DAO();
        
        LIST<Promotion__c> promotionlist  = new LIST<Promotion__c>();
        system.debug('Promo Code: '+PromoCode);
        if(PromoCode !=''){
            promotionlist = PromotionBAL.getPromotionDetails(eventId,PromoCode);
            if(promotionlist.size()>0){
                for(Promotion__c p:promotionlist){
                    p.T_Used_Count__c += PromotionCount;
                }
                PromotionDAO.UpsertPromotion(promotionlist);
            }
        }
        
        MAP<ID, ID> findDuplicateItems = new MAP<ID, ID>(); // Map to find out duplicate order items
       
         system.debug('TTTTTTTTTTTTTTtt  '+TicketIds.size());
      
        // Looping through Users, Companies and Tickets  
        for(integer i=0; i< TicketIds.size();i++){
            system.debug('AAAAAAAAAAAAAAAAAAA '+TicketIds[i]);
            //Getting Ticket Details to update
            LIST<Ticket__c> TicketsList = [select Parent_ID__c,id,name,First_Name__c,Last_Name__c,Email__c,Company__c,Client_GN_User__c,item__r.Id,item__r.Ticket_Settings__c,Client_Company__c,Order__c,Order_Item__c,Item_Pool__r.Package_Flag__c,Item__c,Item__r.price__c,Event__c,Item_Type__r.name,Ticket_Status__c from Ticket__c where id=:TicketIds[i] ];
            //TicketDAO.getTickets('Parent_ID__c,id,name,First_Name__c,Last_Name__c,Email__c,Company__c,Client_GN_User__c,item__r.Id,item__r.Ticket_Settings__c,Client_Company__c,Order__c,Order_Item__c,Item_Pool__r.Package_Flag__c,Item__c,Item__r.price__c,Event__c,Item_Type__r.name,Ticket_Status__c','id=\''+TicketIds[i]+'\' LIMIT 1');
            system.debug('AAAAAAAAAAAAAAAAAAA '+TicketsList);
            
            //Insert & Update Order Item
            BLN_StatusMessage OrderItemMessage;
            Id OrderItemId; 
            Order_Item__c insertedOrderItem = new Order_Item__c();
            
            BLN_OrderItem_DAO OrderItemDAO = new BLN_OrderItem_DAO();
            if(!findDuplicateItems.containsKey(TicketsList[0].item__r.Id)){
                findDuplicateItems.put(TicketsList[0].item__r.Id,TicketsList[0].item__r.Id);
                Order_Item__c OrderItem = new Order_Item__c(Currency__c=Cur.id,Item_Quantity__c=1,Item_Total__c=TicketsList[0].Item__r.price__c,Item__c = TicketsList[0].item__c,Item_Discount__c=DiscountAmount,Order__c=OrderMessage.successId,Promotion__c=PromotionIdMap.get(TicketsList[0].item__r.Id));
                OrderItemMessage = OrderItemDAO.insertorder(OrderItem); 
                OrderItemId = OrderItemMessage.successId;
               
            }
            else{
              if(TicketsList[0].Parent_ID__c==null){    
                    insertedOrderItem = OrderItemDAO.getOrderItem(OrderMessage.successId,TicketsList[0].item__r.Id);
                    insertedOrderItem.Item_Quantity__c = insertedOrderItem.Item_Quantity__c+1;
                    insertedOrderItem.Item_Total__c = insertedOrderItem.Item_Total__c+insertedOrderItem.Item__r.price__c;
                    LIST<Order_Item__c> insertedOrderItems = new LIST<Order_Item__c>();
                    insertedOrderItems.add(insertedOrderItem);
                    OrderItemMessage = OrderItemDAO.updateOrder(insertedOrderItems);
                    OrderItemId = OrderItemMessage.successId;
              }
            }
            
            // Update Ticket
            if(TicketsList[0].Item_Pool__r.Package_Flag__c=='P - Package item pool'){
            
               //List<Ticket__c> PackageTicket = new List<Ticket__c>();
              
                //Get all Package Tickets
                List<Ticket__c> PackageTicket = TicketDAO.getTickets('id,name,First_Name__c,Last_Name__c,Email__c,Company__c,Client_GN_User__c,Client_Company__c,Order__c,item__r.Ticket_Settings__c,Order_Item__c,Ticket_Status__c','Parent_ID__c=\''+TicketsList[0].id+'\'');
                List<Ticket__c> PackageTicket2 = new List<Ticket__c>(TicketDAO.getTickets('id,name,First_Name__c,Last_Name__c,Email__c,Company__c,Client_GN_User__c,Client_Company__c,Order__c,item__r.Ticket_Settings__c,Order_Item__c,Ticket_Status__c','id=\''+TicketsList[0].id+'\''));
                 for(Ticket__c tc :PackageTicket2  ){
                   tc.Ticket_Status__c = 'Booked';
                 }
                
                
                for(integer j=0;j<PackageTicket.size();j++){
                   
                    ticketsForupdatePkg.add(PackageTicket[j]);
                    PackageTicket[j].Client_GN_User__c= UserIds[i];
                   
                    
                    try{
                    PackageTicket[j].Client_Company__c = CompanyIds[i];
                   
                    }catch(exception e){}
                    
                    PackageTicket[j].Order__c = OrderMessage.successId;
                    if(OrderItemId != NULL){
                        PackageTicket[j].Order_Item__c = OrderItemId;
                    }else{
                        PackageTicket[j].Order_Item__c = insertedOrderItem.Id;
                    }
                    PackageTicket[j].Ticket_Status__c = 'Booked';
              
                }  
            
            
              //Update Package Ticket
                TicketsList[0].Client_GN_User__c= UserIds[i];
                
                 try{
                    TicketsList[0].Client_Company__c = CompanyIds[i];
                   
                 }catch(exception ex){}
                TicketsList[0].Order__c = OrderMessage.successId;
                if(OrderItemId != NULL){
                    TicketsList[0].Order_Item__c = OrderItemId;
                }else{
                    TicketsList[0].Order_Item__c = insertedOrderItem.Id;
                }
                TicketsList[0].Ticket_Status__c='Booked';
                PackageTicket.add(TicketsList[0]);
                TicketUpdateMessage = TicketDAO.updateTicket(PackageTicket);
            }
            else{
                //Update Individual Ticket
                system.debug('Ticket Details are : '+TicketsList[0]);  
                TicketsList[0].Ticket_Status__c='Booked';
                try{
                TicketsList[0].Client_GN_User__c= UserIds[i];
                }catch(exception er){}
                 try{
                  TicketsList[0].Client_Company__c = CompanyIds[i];
                  
                }catch(exception ey){}
                TicketsList[0].Order__c = OrderMessage.successId;
                if(OrderItemId != NULL){
                    TicketsList[0].Order_Item__c = OrderItemId;
                }else{
                    TicketsList[0].Order_Item__c = insertedOrderItem.Id;
                }
                
                TicketUpdateMessage = TicketDAO.updateTicket(TicketsList[0]);
                system.debug('Updated Ticket Response: '+TicketUpdateMessage);  
            }
        }
        return TicketUpdateMessage;      
    }
    
   // ----------------------------------------------------- Edit for Regular Registration by Mahesh Sakunala --------------------- END ------------------------------------------------------    
    
      
    //Get Badge For Ticket
    public String getBadgeForTicket(String ticketId){
        BLN_Badge_DAO badgedao=new BLN_Badge_DAO();
        String badgeid=badgedao.getBadgeForTicket(ticketId);
        
        //For tickets having the same badge
        if(badgeid==''){
            BLN_Ticket_DAO tcktdao=new BLN_Ticket_DAO();
            List<Ticket__c> tc=tcktdao.getTickets('id,name,Badge_Label__c,Badge_ID__c','id=\''+ticketId+'\'');
            if(tc.size()!=0)
                badgeid=tc[0].Badge_ID__c;
        }
        return badgeid;
    }
   
   
    //Get all the booked tickets for showing in picklist
    public List<Ticket__c> getBookedTickets(String event){
        BLN_Ticket_DAO tcktdao=new BLN_Ticket_DAO();
        return tcktdao.getTickets('id,name,Order_Item__r.Item__r.item_name__c,Order__r.Name,Client_User__r.FirstName,item__r.Ticket_Settings__c,Client_User__r.LastName,Client_User__r.Email,Client_Company__r.name','Event__c=\''+event+'\' and Ticket_Status__c=\'Booked\' and Item_Pool__r.Badgable__c=\'N - No Badge\' order by Order__r.Name');  
    }
   

 
//*******************************************************************
//Get Details to fill the form for updateprnt 
public Ticket__c getItemInfoFrmTicket(String ticketId){
BLN_Ticket_DAO tcktdao=new BLN_Ticket_DAO();
List<Ticket__c> tckt=tcktdao.getTickets('id,name,Badge_Label__c,First_Name__c,Last_Name__c,Email__c,Company__c,Badge_ID__c,Badge_ID__r.name,Badge_ID__r.badge_label__c,(select id,name,badge_label__c from badges__r where cancel_time__c=null and Exp_time__c=null),Client_Company__c,Order__c,Order__r.id,Order_Item__c,Order_Item__r.Item__r.id,Order_Item__r.Item__r.item_name__c,Client_GN_User__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_GN_User__r.phone__c,Client_Company__r.name','id=\''+ticketId+'\''); 
return tckt[0];
}
//**********************************************************************
   
   
   //Update Existing Ticket Information
   
  public void updateExistingBadge(String reason,String oldbadgelabel,String badgelabel,String oldASTitle ,String ASTitle ,String oldASPhone ,String ASPhone,String oldASFirstName,String ASFirstName,String oldASLastName,String ASLastName,String oldASUserEmail,String ASUserEmail,String oldASCompanyName,String ASCompanyName,String ticketitems )
{
String userid;
String companyid;
BLN_User_DAO userdao=new BLN_User_DAO();
BLN_Gnuser_DAO gnuserdao=new BLN_Gnuser_DAO();
//update badge
String[] ticketidandclientids =ticketitems.split(';');
String ticketids=ticketidandclientids [0];
generateBadge(badgelabel,ticketids,reason);
/*if(oldbadgelabel!=badgelabel)
{ 
String[] ticketidandclientid =ticketitems.split(';');
String ticketid=ticketidandclientid [0];

if(oldbadgelabel==null)
generateBadge(badgelabel,ticketid,'');
else
{
Badge__c bg=new Badge__c(); 
String badgeid=getBadgeForTicket(ticketid);
bg.id=badgeid;
bg.Badge_Label__c=badgelabel;

BLN_Badge_DAO bdgdao=new BLN_Badge_DAO();
bdgdao.updatebadge(bg);
}

}*/

//update user information
if(oldASFirstName!=ASFirstName||oldASLastName !=ASLastName||oldASTitle!=ASTitle||oldASPhone!=ASPhone||oldASUserEmail!=ASUserEmail)
{
GN_User__c upuser=new GN_User__c();
upuser.Email__c =ASUserEmail;
upuser.First_Name__c=ASFirstName;
upuser.Last_Name__c=ASLastName;
//upuser.title__c=ASTitle;
upuser.phone__c=ASPhone;
String[] ticketidandclientid =ticketitems.split(';');
String ticketid=ticketidandclientid [0];
String clientid=ticketidandclientid [1];
//userid=gnuserdao.updateGNUser(upuser,ASUserEmail,ticketid,null);
//update the placeholders
BLN_Ticket_DAO tcktdao=new BLN_Ticket_DAO();
List<Ticket__c> tc=tcktdao.getTickets('Company__c,First_Name__c,Last_Name__c,Email__c,Client_Company__c,Order__c,Order__r.id,Order_Item__c,item__r.Ticket_Settings__c,Order_Item__r.Item__r.id,Order_Item__r.Item__r.item_name__c,Client_GN_User__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_Company__r.name','id=\''+ticketId+'\' and Event__c=\''+Apexpages.currentPage().getParameters().get('id')+'\''); 
tc[0].First_Name__c=ASFirstName;
tc[0].Last_Name__c=ASLastName;
tc[0].Email__c=ASUserEmail;


user newu = new user();
newu.firstName = ASFirstName;
newu.lastName = ASLastName;
newu.Email = ASUserEmail;
newu.userName = ASUserEmail;

if(ASCompanyName !=null){
newu.companyName = ASCompanyName ;
}else{
newu.companyName = ASFirstName+''+ASLastName;
}

//GN_User__c gnUserEdit=[select id,name,First_Name__c,Last_Name__c ,Email__c,User__c from GN_User__c where id=:tc[0].Client_GN_User__c];
BLN_MyticketsCon blntickkcon=new BLN_MyticketsCon();
blntickkcon.isOrderEdit=false;
blntickkcon.ucrole=new UC_Role__c();
try{
//blntickkcon.ucrole = [select id,Company__c,Event__c,Invited_by__c,Invited_date__c,RoleId__c,GN_User__c,User__c,User_Type__c from UC_Role__c where company__c =:tc[0].Client_company__c and GN_User__c=:tc[0].Client_GN_User__c limit 1];
}catch(Exception e){}
//blntickkcon.saveLogic(newu,tc[0],new order__c(),gnUserEdit);


}



//create company and update user company role if company changes 
if(oldASCompanyName!=ASCompanyName )
{

String[] ticketidandclientid =ticketitems.split(';');
String ticketid=ticketidandclientid [0];
String clientid=ticketidandclientid [1];

BLN_Ticket_DAO tcktdao=new BLN_Ticket_DAO();
List<Ticket__c> tc=tcktdao.getTickets('Company__c,First_Name__c,Last_Name__c,Email__c,Client_Company__c,Order__c,Order__r.id,Order_Item__c,item__r.Ticket_Settings__c,Order_Item__r.Item__r.id,Order_Item__r.Item__r.item_name__c,Client_GN_User__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_Company__r.name','id=\''+ticketId+'\' and Event__c=\''+Apexpages.currentPage().getParameters().get('id')+'\''); 


if(ASFirstName=='')
ASFirstName=tc[0].Client_GN_User__r.First_Name__c;
if(ASLastName=='')
ASLastName=tc[0].Client_GN_User__r.Last_Name__c;
if(ASUserEmail=='')
ASUserEmail=tc[0].Client_GN_User__r.Email__c;

BLN_Company_DAO cdao=new BLN_Company_DAO();
companyid=cdao.insertcompanyAnducroleprocess(Apexpages.currentPage().getParameters().get('id'),ASFirstName,ASLastName,ASUserEmail,tc[0].Client_GN_User__c,ASCompanyName,null,null);


tc[0].Client_Company__c=companyid;
tc[0].Company__c=ASCompanyName ; 
update tc;
}
}
  //Get Tickets based on orderno or email
   //************************************************************************
public List<Ticket__c > getClientTicketsbasedonOrderOrEmail(String eventId,String ordernoOremail){
BLN_Ticket_DAO tcktdao=new BLN_Ticket_DAO();
List<Ticket__c > tckts=tcktdao.getTickets('id,name,Badge_Label__c,First_Name__c,Last_Name__c,Email__c,Company__c,Badge_ID__c,Badge_ID__r.Badge_Label__c,(select id,name,Badge_Label__c from badges__r where cancel_time__c=null and Exp_time__c=null),Order__r.Name,Event__c,Order__c,Order__r.id,Order_Item__c,Order_Item__r.Item__r.id,Order_Item__r.Item__r.item_name__c,Client_GN_User__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Client_Company__r.name,Ticket_Status__c,Item_Pool__r.Badgable__c','Event__c=\''+eventId+'\' and Ticket_Status__c=\'Booked\' and Item_Pool__r.Badgable__c=\'B - Badge\' and (Email__c=\'' + ordernoOremail+ '\' or Order__r.name=\''+ordernoOremail+'\' or First_Name__c=\''+ordernoOremail+'\' or Last_Name__c=\''+ordernoOremail+'\' or Company__c=\''+ordernoOremail+'\') order by Order__r.Name');
if(tckts.size()>0)
return tckts;
else
return new List<Ticket__c>();
}
//****************************************************************
  
   //Generate Badge while printing
   //used for attendees page portal
   public String generateBadge(String badgelabel,String ticketid,String Reason)
   {
   
      //get the badge for ticket if exists which is not cancelled
      try{
     String q = 'select id,name,badge_label__c,cancel_time__c,Cancel_Reason__c from Badge__c where ticket_id__c=\'' + ticketid +'\' and cancel_time__c=null and Exp_time__c=null limit 1';
        Badge__c badge=Database.query(q);
        badge.cancel_time__c=System.now(); 
        badge.Cancel_Reason__c=Reason;     
        update badge;
        }catch(Exception e){}
   
   
        //generate badge for single ticket
                    Badge__c bg=new Badge__c();
                    bg.Badge_Label__c=badgelabel;
                    bg.ticket_id__c=ticketid;
                    BLN_Badge_DAO bdgdao=new BLN_Badge_DAO();
                   
        BLN_StatusMessage userMsg =  bdgdao.insertbadge(bg);
           
        if(userMsg.successBool){
              //update badgeid in ticket
          Ticket__c up=new Ticket__c();
          up.id=ticketid;
          up.badge_label__c=badgelabel;
          up.badge_id__c=userMsg.successId;
          update up;
                 return userMsg.successId;
                              
              }else{
                  return userMsg.errors ;
              }
           
}

 



 
  //------------------------------------------------------------------------- Registration start --------------------------  
     public static BLN_Gnuser_DAO blnusersdao = new BLN_Gnuser_DAO();
     public static BLN_User_DAO usrdao = new BLN_User_DAO();
     public MAP<string,Gn_user__c> mapEmailWithUid {get;set;}
     public MAP<string,id> mapcompWithcid {get;set;}
     public MAP<string,Id> maproleWithId {get;set;}
     public MAP<string,string> mapemailsWithcId {get;set;}
     public MAP<string,Company__c> mapCompidWithcomp{get;set;}
     
     
    public string  insertingTotalorder(List<BLN_RegistrationnewCon.ItemInnerClass> itemsListInn, List<BLN_RegistrationnewCon.TicketInnerClass> regInn,Gn_user__c buyerUsers,string buyerSelectedComp,Company_Ext__c compext,Decimal SubTotal, Decimal DiscountAmount, Decimal FeeAmount,Decimal TaxAmount, Decimal AmountPaid, MAP<id,decimal> mapitemWithFee,MAP<id,decimal> mapitemWithDiscount,Promotion__c PromotionOb, String ChargeType, String PGatewayType,String ChargeId, String PGatewayMode,Pay_Address__c BillingAddressForbuyer,Company__c buyerComp,List<BLN_RegistrationnewCon.UserAnswerInnerClass> eventlevelQuestions,String module){
       
       
       system.debug('EEEEEEEEEEEEEEEEEEEEEEE '+regInn.size());
       
        List<Gn_User__c> getgnusersList = new List<Gn_User__c>() ;
        mapEmailWithUid = new MAP<string,Gn_user__c>();
        maproleWithId = new MAP<string,Id>();
        mapcompWithcid = new MAP<string,id>();
        mapemailsWithcId = new MAP<string,string>(); 
        MAP<string,Company_Ext__c> mapcomwithext = new MAP<string,Company_Ext__c>();
        mapCompidWithcomp  = new MAP<string,Company__c>();
        
        string  orderStatus = 'Success';
        IF(buyerUsers.Email__c !=null){
           buyerUsers.Email__c =buyerUsers.Email__c.toLowerCase();
        }
        getgnusersList.add(buyerUsers);  // Adding buyer to list for insert
       
        SET<string> comiesForinsert = new SET<string>();
        List<GN_User__c> percomiesForinsert = new List<GN_User__c>();
        BLN_Role_DAO  roledao = new BLN_Role_DAO();
        string eventid ='';
        
        // Getting available roles for UC role Obj
         for(Role__c r :roledao.userRole()){
            maproleWithId.put(r.Name,r.id);
         }
        
        // Adding buyer info to insering classes
        if(buyerSelectedComp!=null && buyerSelectedComp!=''){
           mapcompWithcid.put(buyerComp.Name,buyerSelectedComp);  
        }else{
            if(buyerComp.Name!=null){
               comiesForinsert.add(buyerComp.Name);
               mapcomwithext.put(buyerComp.Name,compext);
               mapCompidWithcomp.put(buyerComp.Name,buyerComp);
            }else{
                percomiesForinsert.add(buyerUsers);
            }
        }
        
        if(regInn.size()>0){
             eventid = regInn[0].Ticket.Event__c;
        }
        
         for(BLN_RegistrationnewCon.TicketInnerClass tinn :regInn ){
             IF(tinn.EachUser.Email__c !=null){
                tinn.EachUser.Email__c =tinn.EachUser.Email__c.toLowerCase();
             }
            
            if((tinn.Ticket.Item__r.Ticket_Settings__c != 'Collect info from All Attendees' && tinn.Ticket.Item_Type__r.name != 'Package')  || (tinn.Ticket.Item_Pool__r.Ticket_Settings__c != 'Collect info from All Attendees' && tinn.Ticket.Item_Type__r.name == 'Package')){
            
            }else{
               if(tinn.EachUser.Email__c!=null && tinn.EachUser.Last_Name__c!=null ){
                  getgnusersList.add(tinn.EachUser);// Adding guests to list for insert 
                    if(tinn.EachCompany.Name!='' && tinn.EachCompany.Name !=null){ // if guest provide company 
                  }
               } 
            }           
        }
       
          mapEmailWithUid = insertingusers(getgnusersList); // Map wich holds email as keys and Gnuser as Value 
                   
          
        // iterating for companies
           for(BLN_RegistrationnewCon.TicketInnerClass tinn :regInn ){
             if((tinn.Ticket.Item__r.Ticket_Settings__c != 'Collect info from All Attendees' && tinn.Ticket.Item_Type__r.name != 'Package')  || (tinn.Ticket.Item_Pool__r.Ticket_Settings__c != 'Collect info from All Attendees' && tinn.Ticket.Item_Type__r.name == 'Package')){
                  
            }else{
                if(tinn.EachCompany.Name!='' && tinn.EachCompany.Name !=null){ // if guest provide company 
                  if(tinn.selectedCompnay!=null && tinn.selectedCompnay!=''){ // if guest picks existing company
                      mapcompWithcid.put(tinn.EachCompany.Name,tinn.selectedCompnay);     
                  }else{ // if guest provide new company
                      comiesForinsert.add(tinn.EachCompany.Name);
                       mapcomwithext.put(tinn.EachCompany.Name,tinn.EachCompanyExt);
                        mapCompidWithcomp.put(tinn.EachCompany.Name,tinn.EachCompany);
                    }
                    }else{ // If guest did not provide company
                       if(buyerComp.Name!=null && buyerComp.Name!=''){ // checking buyer provide company or not
                         if(buyerSelectedComp!=null && buyerSelectedComp!=''){ // If buyer picks his company from exiting
                             mapcompWithcid.put(buyerComp.Name,buyerSelectedComp);
                         }else{ // buyer provide new company
                            
                         }   
                        }else{ // if buyer company empty
                            percomiesForinsert.add(tinn.EachUser); // Inserting personal companies
                       }    
                        
                    } 
                 }
           }
         getpersonalCompanies(percomiesForinsert);   // Inserting new companies
         insertingCompanies(comiesForinsert);  // inserting individual companies
         
           // Inserting company extentions        
           List<Company_Ext__c>  compextList = new List<Company_Ext__c>();
            for(string compName : mapcomwithext.keySet()){
                system.debug('111111111 '+mapcomwithext);
                system.debug('222222222  '+mapcomwithext.get(compName));
                system.debug('33333333333  '+mapcompWithcid.get(compName));
                
                Company_Ext__c compextind = new Company_Ext__c();
                compextind = mapcomwithext.get(compName);
                compextind.Company__c = mapcompWithcid.get(compName);
               if(compextind!=null){
                compextList.add(compextind);
               }
            }
            system.debug('44444444444   '+compextList);
         BLN_Company_Ext_DAO compextdao = new BLN_Company_Ext_DAO();
         compextdao.insertingComexts(compextList);
         
         BLN_Currency_DAO CurDAO =new BLN_Currency_DAO();
         Currency__c cur = CurDAO.getCurrencyDetails('id,name','name=\'USD\' LIMIT 1');
         
         system.debug('SSSSSSSSSSSSSSSSSSSSS  '+mapEmailWithUid+'ZZZZZZZZZz  '+mapcompWithcid+'EEEEEEEEEEEEEE '+eventId);
        
        // Insert Order
       Order__c  Order = new Order__c();
       Order.Events__c=eventId;
       Order.Amount_Paid__c=AmountPaid;
       Order.Client_GN_User__c=mapEmailWithUid.get(buyerUsers.Email__c).id;
       if(null!=mapcompWithcid.get(buyerComp.Name)){
          Order.Client_Company__c=mapcompWithcid.get(buyerComp.Name);
       }else{
          Order.Client_Company__c=mapemailsWithcId.get(buyerUsers.Email__C);
       }
       Order.Order_Total__c=AmountPaid;
       Order.Order_Sub_Total__c=SubTotal;
       Order.Order_Discount__c=DiscountAmount;
       Order.Order_Status__c='Fully Paid';
       Order.Currency_Code__c=cur.id;
       Order.Fee_Amount__c=FeeAmount;
       Order.Order_Taxes__c=TaxAmount;
       database.saveresult dsave =  DataBase.insert(order,false);
       system.debug('SSSSSSSSSSSSSSSSSSSSS  '+dsave);
        orderId=Order.id;
      
      // Inserting order Items
      BLN_OrderItem_DAO OrderItemDAO = new BLN_OrderItem_DAO();
      List<Order_Item__c> orderItemList = new List<Order_Item__c>();
      MAP<id,id> maoitemWithorderItem = new MAP<id,id>();
        for(BLN_RegistrationnewCon.ItemInnerClass iicQuick :itemsListInn){
            if(Decimal.valueOf(iicQuick.selectedItemQuantity)>0){ 
              Order_Item__c  ordIt = new Order_Item__c(); 
              ordIt.Item__c = iicQuick.items.id;
              ordIt.Item_Quantity__c = Decimal.valueOf(iicQuick.selectedItemQuantity);
              ordIt.Order__c = Order.id;
              ordIt.Currency__c=Cur.id;
              ordIt.Item_Total__c  = iicQuick.items.price__c*Decimal.valueOf(iicQuick.selectedItemQuantity);
               if(null != mapitemWithDiscount){
                  if(mapitemWithDiscount.keySet().contains(iicQuick.items.id)){
                      ordIt.Item_Discount__c =mapitemWithDiscount.get(iicQuick.items.id); 
                      ordIt.Promotion__c  = PromotionOb.id;
                  }    
               }
               
              if(null != mapitemWithFee){
                if(mapitemWithFee.keySet().contains(iicQuick.items.id)){
                  ordIt.Item_Fee__c=mapitemWithFee.get(iicQuick.items.id);
                }
              } 
               
              orderItemList.add(ordIt);
            }
          }
           system.debug('TTTTTTTTTTTTTTTTT  '+orderItemList);
           BLN_StatusMessage blOrderItems = OrderItemDAO.insertOrderitem1(orderItemList);
           system.debug('111111111    '+blOrderItems);
           system.debug('222222222    '+OrderItemDAO.getTicketsOfperticularOItem(blOrderItems.successIds));
           
          for(Order_Item__c ordit : OrderItemDAO.getTicketsOfperticularOItem(blOrderItems.successIds)){
            maoitemWithorderItem.put(ordit.item__c,ordit.id);       
         }
      
      system.debug('UUUUUUUUUUU  '+regInn[0].Ticket);
      system.debug('VVVVVVVVVVV   '+maoitemWithorderItem);
       
       
      SET<string> checkcompanyforRole = new SET<string>(); 
      List<UC_role__c> ucroleList = new List<UC_role__c>();
        //Updating tickets 
             if(buyerSelectedComp!=null && buyerSelectedComp!=''){
                 
             }else{
                UC_role__c ucroleind = new UC_role__c();
                ucroleind.Company__c = mapcompWithcid.get(buyerComp.Name);
                ucroleind.Event__c = eventid;
                ucroleind.GN_User__c = mapEmailWithUid.get(buyerUsers.Email__c).id;
                ucroleind.User_Type__c =  'Business';
                ucroleind.RoleId__c = maproleWithId.get('Company Admin');   
                ucroleList.add(ucroleind);
             }
         
         List<ticket__c> tcListForupdate = new List<ticket__c>();
         LIst<surveyQuestions> surveysListToinsert = new List<surveyQuestions>();
         
         for(BLN_RegistrationnewCon.TicketInnerClass tinnupdate :regInn ){
           if((tinnupdate.Ticket.Item__r.Ticket_Settings__c != 'Collect info from All Attendees' && tinnupdate.Ticket.Item_Type__r.name != 'Package')  || (tinnupdate.Ticket.Item_Pool__r.Ticket_Settings__c != 'Collect info from All Attendees' && tinnupdate.Ticket.Item_Type__r.name == 'Package')){
               tinnupdate.ticket.First_Name__c =  buyerUsers.First_Name__c;
               tinnupdate.ticket.Last_Name__c =  buyerUsers.Last_Name__c;   
               tinnupdate.ticket.Email__c =  buyerUsers.Email__c;
               tinnupdate.ticket.Company__c = buyerComp.Name ;
               tinnupdate.ticket.Client_Company__c = mapcompWithcid.get(buyerComp.Name);
               tinnupdate.ticket.Client_GN_User__c = mapEmailWithUid.get(buyerUsers.Email__c).id;
               tinnupdate.ticket.Order__c = order.id;
               tinnupdate.ticket.Order_Item__c = maoitemWithorderItem.get(tinnupdate.ticket.Item__c);
               tinnupdate.ticket.Ticket_Status__c = 'Booked';
               tcListForupdate.add(tinnupdate.ticket); 
               
           }else{
                
               tinnupdate.ticket.First_Name__c =  tinnupdate.EachUser.First_Name__c;
               tinnupdate.ticket.Last_Name__c =  tinnupdate.EachUser.Last_Name__c;   
               tinnupdate.ticket.Email__c =  tinnupdate.EachUser.Email__c;
               tinnupdate.ticket.Company__c = tinnupdate.EachCompany.Name ;
              
                
                 tinnupdate.ticket.Order__c = order.id;
                  system.debug('WWWWWWWWWW   '+tinnupdate.ticket.Item__c);
                 tinnupdate.ticket.Order_Item__c = maoitemWithorderItem.get(tinnupdate.ticket.Item__c);
                  system.debug('XXXXXXXXXXXXXXXx   '+tinnupdate.ticket.Email__c);
                 tinnupdate.ticket.Client_GN_User__c = mapEmailWithUid.get(tinnupdate.ticket.Email__c).id;
                
                  if(tinnupdate.EachCompany.Name!='' && tinnupdate.EachCompany.Name !=null){ // if guest provide company 
                     if(tinnupdate.selectedCompnay!=null && tinnupdate.selectedCompnay!=''){ // if guest picks existing company
                        tinnupdate.ticket.Client_Company__c =tinnupdate.selectedCompnay;
                      }else{ // if guest provide new company
                        tinnupdate.ticket.Client_Company__c =mapcompWithcid.get(tinnupdate.EachCompany.Name);
                         // For inserting uc roles
                          if(tinnupdate.ticket.Email__c!=buyerUsers.Email__c){
                              UC_role__c ucroleind = new UC_role__c();
                              ucroleind.Company__c = mapcompWithcid.get(tinnupdate.EachCompany.Name);
                            
                              ucroleind.GN_User__c = mapEmailWithUid.get(tinnupdate.ticket.Email__c).id;
                              ucroleind.User_Type__c =  'Business';
                              if(!checkcompanyforRole.contains(tinnupdate.EachCompany.Name)){
                                 ucroleind.RoleId__c = maproleWithId.get('Company Admin');   
                              }else{
                                ucroleind.RoleId__c = maproleWithId.get('Guest Attendee');      
                                  ucroleind.Event__c = eventid;
                              }
                             checkcompanyforRole.add(tinnupdate.EachCompany.Name);
                             ucroleList.add(ucroleind);
                          }  
                      }
                   }else{ // If guest did not provide company
                       if(buyerComp.Name!=null && buyerComp.Name!=''){ // checking buyer provide company or not
                         if(buyerSelectedComp!=null && buyerSelectedComp!=''){ // If buyer picks his company from exiting
                            tinnupdate.ticket.Company__c = buyerComp.Name ; 
                            tinnupdate.ticket.Client_Company__c =buyerSelectedComp; 
                            if(tinnupdate.ticket.Email__c!=buyerUsers.Email__c){
                              UC_role__c ucroleind = new UC_role__c();
                              ucroleind.Company__c = buyerSelectedComp;
                              ucroleind.Event__c = eventid;
                              ucroleind.GN_User__c = mapEmailWithUid.get(tinnupdate.ticket.Email__c).id;
                              ucroleind.User_Type__c =  'Business';
                              ucroleind.RoleId__c = maproleWithId.get('Guest Attendee');    
                              ucroleList.add(ucroleind);
                            }
                         }else{ // buyer provide new company
                            tinnupdate.ticket.Company__c = buyerComp.Name ; 
                            tinnupdate.ticket.Client_Company__c = mapcompWithcid.get(buyerComp.Name); 
                                 if(tinnupdate.ticket.Email__c!=buyerUsers.Email__c){
                                  UC_role__c ucroleind = new UC_role__c();
                                  ucroleind.Company__c = mapcompWithcid.get(buyerComp.Name);
                                  ucroleind.Event__c = eventid;
                                  ucroleind.GN_User__c = mapEmailWithUid.get(tinnupdate.ticket.Email__c).id;
                                  ucroleind.User_Type__c =  'Business';
                                  ucroleind.RoleId__c = maproleWithId.get('Guest Attendee');    
                                  ucroleList.add(ucroleind);
                                }
                          }   
                        }else{ // if buyer copmpany empty and guest company empty
                          tinnupdate.ticket.Client_Company__c = mapemailsWithcId.get(tinnupdate.EachUser.Email__c);
                       }    
                        
                    } 
                    tinnupdate.ticket.Ticket_Status__c = 'Booked';
                    tcListForupdate.add(tinnupdate.ticket);   
                 }
                 
             If(tinnupdate.surveys =true){
                if(tinnupdate.QuestionMap!=null){
                     surveysListToinsert.add(new surveyQuestions(mapEmailWithUid.get(tinnupdate.ticket.Email__c).id,tinnupdate.UserAnswer,tinnupdate.BLNItem,tinnupdate.ticket,false,eventid));
                
                 }
             }    
                 
           }
          BLN_Ticket_DAO tcktdaoupdate =new BLN_Ticket_DAO();
          tcktdaoupdate.updateTicket(tcListForupdate );  
          BLN_UCRole_DAO ucroledaoupdate = new BLN_UCRole_DAO();
          ucroledaoupdate.saveUserCompanyRole(ucroleList); 
          
      //Get PGateway Type
        BLN_PGateway_Type_DAO PGatewayDAO = new BLN_PGateway_Type_DAO();
        if(PGatewayMode == 'Stripe'){
            PGatewayType = 'Stripe';
        }else if(PGatewayMode == 'Authorize .Net'){
            PGatewayType = 'Authorize.Net';
        }else{
           PGatewayType = PGatewayType;
        }
       Event_Pay_Gateway__c  PGateway = new Event_Pay_Gateway__c  ();
         try{
           PGateway = BLN_EventPayGateway_DAO.getEventPayGateWay(eventId,PGatewayType,Module);
        }catch(exception er){}
        
           //Insert Pay Address
        BLN_Pay_Address_DAO PayAddressDAO = new BLN_Pay_Address_DAO();
        //Pay_Address__c PayAddress = new Pay_Address__c();
        BillingAddressForbuyer.Event__c = eventid;
       // PayAddress
        if(buyerSelectedComp!=null && buyerSelectedComp!=''){
          BillingAddressForbuyer.Company__c =buyerSelectedComp;
        }else{
           BillingAddressForbuyer.Company__c =mapcompWithcid.get(buyerComp.Name);
         }
        BillingAddressForbuyer.GN_User__c = mapEmailWithUid.get(buyerUsers.Email__c).id;
        BLN_StatusMessage  PayAddressMessage = PayAddressDAO.insertPayAddress(BillingAddressForbuyer);
        
        //Insert Payment
        BLN_payment_DAO PaymentDAO = new BLN_payment_DAO();
        Payment__c Payment = new Payment__c(Payment_Amount__c=AmountPaid,Order__c=order.id,Currency_Code__c=cur.id,Payment_Mode__c=ChargeType,event_paygateway_id__c=PGateway.id,Pay_Address__c=PayAddressMessage.SuccessId,Payment_Ref_Number__c=ChargeId);
        BLN_StatusMessage PaymentMessage = PaymentDAO.insertPayment(Payment);
   
   
       string buyerId  =  mapEmailWithUid.get(buyerUsers.Email__c).id;
   
       // inserting event level Questions
         if(eventlevelQuestions.size()>0){
             surveysListToinsert.add(new surveyQuestions(mapEmailWithUid.get(buyerUsers.Email__c).id,eventlevelQuestions,new BLN_Item__c(),new Ticket__c(),true,eventid));
          }      
   
      // Inserting ticekt level Questions
        BatchexeforSurveys barchex = new BatchexeforSurveys();
        barchex.iterateSurveys(surveysListToinsert);
        database.executeBatch(barchex,99);
     
        return orderStatus;
   } 
    
    
    // For inserting Survey Questions 
    public class surveyQuestions{
        public string userid{get;set;}   
        public Ticket__C ticket {get;set;}
        public BLN_Item__c tick{get;set;}
        public boolean iseventlevel {get;set;}
        public string eventid{get;set;}   
        public List<BLN_RegistrationnewCon.UserAnswerInnerClass> listinn{get;set;}
        public surveyQuestions(string userid,List<BLN_RegistrationnewCon.UserAnswerInnerClass> inn,BLN_Item__c tc,Ticket__c ticketinn,boolean elevel,string eventid){
          this.userid = userid;
          this.listinn =inn;
          this.ticket  = ticketinn;
          this.tick = tc;
          this.iseventlevel  = elevel;
          this.eventid = eventid;
        }
         
    }
    
    
    
    // Insert orders and tickets for registrationpage By Phani On 22/12/2014
      public MAP<string,Gn_user__c> insertingusers(List<Gn_user__c> userslist){
          MAP<string,Gn_user__c> mapEmailWithUid12 = new MAP<string,Gn_user__c>();
           SET<string> duplicateremove = new SET<string>();
           List<contact> insertingCon = new List<contact>();
           MAP<string,Gn_user__c> existingusers = new MAP<string,Gn_user__c>(); 
           MAP<string,id> mapconemailWithId = new MAP<string,id>();
           List<user> sfuserList = new List<user>();   
           MAP<string,Gn_user__c> emails = new MAP<string,Gn_user__c>(); 
           List<Gn_user__c> gnusersList = new List<Gn_user__c>();   
           Profile P = [SELECT Id,Name FROM Profile WHERE Name = 'Event Admin'];
           
             for(Gn_user__c users : userslist){
               emails.put(users.Email__c,users);
             }  
            // Getting users who are existed   
             for(Gn_user__c  em :blnusersdao.existingGnusers(emails.keyset()) ){
               existingusers.put(em.Email__c,em);   
            }
             // Inserting Contacts for inserting user
             for(Gn_user__c usersid : userslist){
              if((!existingusers.keyset().contains(usersid.Email__c)) && (!duplicateremove.contains(usersid.Email__c))){
                    contact Con = new Contact();
                    Con.Lastname = usersid.Last_name__c ;
                    Con.Firstname =usersid.First_name__c ; 
                    con.email = usersid.email__c;
                    insertingCon.add(con);
                    duplicateremove.add(usersid.email__c);
                   // contactId = blnuserDao.account_Contact(con);
               }       
            }  
            BLN_StatusMessage blnmsg ;
             //Mapping contactEmail with conid 
                If(insertingCon.size()>0){
                 List<contact> contactslistnew = new List<Contact>();
                 contactslistnew = usrdao.conList(usrdao.account_Contact(insertingCon));
                   for(contact conids :contactslistnew ){
                     user sfuser = new user();
                      sfuser.ContactID =conids.id;    
                      sfuser.Username = conids.email;  
                      sfuser.Email = conids.email;
                      sfuser.LastName = conids.LastName;
                      sfuser.Alias = 'EAdmin';
                      sfuser.ProfileID = P.id;
                      sfuser.Eff_Date__c=system.today();
                      sfuser.LocaleSidKey = 'en_US';
                      sfuser.LanguageLocaleKey = 'en_US';
                      sfuser.TimeZoneSidKey = 'America/Los_Angeles';
                      sfuser.EmailEncodingKey='UTF-8';
                      sfuser.CommunityNickname = String.valueOf(math.random());
                      sfuserList.add(sfuser);
                   }
              // Inserting users 
                if(sfuserList.size()>0){
                 blnmsg = usrdao.insertUserBulk(sfuserList);      
                }
            }
           system.debug('Inserted Userssssss '+blnmsg );
          //  system.debug('Inserted Userssssss '+blnmsg.successIds);
            
          if(blnmsg!=null){
          // Iterating for inserting gn user
           for(user uy :usrdao.getusers(blnmsg.successIds)){
              Gn_user__c gn =  emails.get(uy.username);
              system.debug(uy.username);              
              gn.User__c = uy.id;
              system.debug(uy.id);
              gnusersList.add(gn);
           }         
            if(gnusersList.size()>0){
                blnusersdao.InsertGNUser(gnusersList);  
            }
            
      } 
            
            for(Gn_user__c gnu : blnusersdao.existingGnusers(emails.keyset())){
                mapEmailWithUid.put(gnu.Email__c,gnu);
          }  
       return  mapEmailWithUid;  
     }
    
      // Inserting companies for guests if he picks company from existing we are not passing here
      public static BLN_Company_DAO compdao = new BLN_Company_DAO();
      public static BLN_UCRole_DAO ucroledao = new BLN_UCRole_DAO();
      
       public Void insertingCompanies(SET<string> companies){
         // MAP<string,Company__c> mapcompWithcid12 = new MAP<string,Company__c>();
          compdao = new BLN_Company_DAO();
         //mapCompidWithcomp
          SET<Company__c> colist = new SET<Company__c>();
           for(string cname :companies){
              Company__c Co = new Company__c();
               try{
                Company__c Comptemp = new Company__c();
                 if(null!= mapCompidWithcomp.get(cname)){
                   Comptemp  = mapCompidWithcomp.get(cname);
                   co.Description__c = Comptemp.Description__c;
                   co.Website_URL__c = Comptemp.Website_URL__c;
                   
                 }
                 
               }catch(exception ed){}
              
              co.Name = cname;
              colist.add(co);
           }
           BLN_StatusMessage blnmsg = compdao.insertCompanyBulk(colist);
            for(company__c co : compdao.companiesForEvent(blnmsg.successIds)){
                mapcompWithcid.put(co.Name,co.id);  
            }  
         // return mapcompWithcid; 
       }
       
       
      //  Getting personal companies 
       public void  getpersonalCompanies(List<GN_user__c> gnusp){
          SET<string> strEmails = new SET<string>();    
            for(GN_user__c gn : gnusp){
                strEmails.add(gn.Email__c);
            }
            
         MAP<string,string> existedEmails = new MAP<string,string>();   
         for(UC_Role__c rt :[select id,GN_User__r.Email__c,company__c from UC_Role__c where GN_User__r.Email__c in :strEmails and User_Type__c='Personal'] ){
            existedEmails.put(rt.GN_User__r.Email__c,rt.company__c);
            system.debug('QQQQQQQQQQQQ '+existedEmails);
         }  
         
          SET<company__c> compList = new SET<company__c>();
          MAP<string,Gn_user__c> mapEmailWithGnusers = new MAP<string,Gn_user__c>();
          
           for(GN_user__c gn : gnusp){
              
             IF(!existedEmails.keySet().contains(gn.Email__c)){
                 Company__c comp = new Company__c();
                 comp.Name = gn.First_Name__c+gn.Last_Name__c;
                 mapEmailWithGnusers.put(gn.First_Name__c+gn.Last_Name__c,mapEmailWithUid.get(gn.Email__c));
                 compList.add(comp);
             }
           }  
           
          compdao = new BLN_Company_DAO();  
          List<Uc_role__c> uList = new List<Uc_role__c>();
          BLN_StatusMessage blnmsg = compdao.insertCompanyBulk(compList);
          
           for(company__c co : compdao.companiesForEvent(blnmsg.successIds)){
              Uc_role__c ucnew = new uc_role__c();
              ucnew.Company__c = co.id;
              ucnew.GN_User__c = mapEmailWithGnusers.get(co.Name).id;
              ucnew.User_Type__c = 'Personal';
              ucnew.RoleId__c= maproleWithId.get('Company Admin');
              uList.add(ucnew);
           } 
         
          BLN_StatusMessage blucroledao = ucroledao.saveUserCompanyRole(uList);  
         MAP<string,string> emailwithcomp = new MAP<string,string>();
            for(UC_role__c ucr : [select id,GN_User__r.Email__c,company__c from UC_Role__c where GN_User__r.Email__c in :strEmails and User_Type__c='Personal']){
                mapemailsWithcId.put(ucr.GN_User__r.Email__c,ucr.Company__c);
            }
             
          //return emailwithcomp; 
            
       }
  
  
}