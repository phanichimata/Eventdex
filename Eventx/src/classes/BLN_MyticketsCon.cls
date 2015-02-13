/***********************************************************************************************
*   Controller Name : BLN_MyticketsCon
*   Date            : 05/19/2014
*   Author          : Phani Kumar Ch
*   Purpose         : This class is for show and edit tickets
*   Change History  : 05/19/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*  05/19/2014          Phani Kumar ch                   To Create Page
*   06/30/2014          Phani Kumar ch                  Allowing Duplicates in GN user Table
**************************************************************************************************/

public without sharing class BLN_MyticketsCon {

    public BLN_UtillDisplayLinks  myticket { get; set; }
    public String datename {get; set;}
    public boolean displyAddGuest{get;set;}
    public Boolean ShowCurrentTickets{get; set;} 
    public boolean displayTicForCancel{get;set;}
    public boolean isOrderEdit{get;set;} 
    public boolean orddetailbool{get;set;}
    
    public string selectedEvent{get;set;}
    public string loginUserId{get;set;}
    public string companyName {get;set;}
    public integer rowNum{get;set;}
    public string selectedOrder {get;set;}
    public  string isAttendeesPAge{get;set;}
    public List<Ticket__c> currentEventTickets{get;set;}
    public List<BLN_Mytickets_BAL.inncls> inncurrentTickets {get;set;} 
    public List<BLN_Mytickets_BAL.Bondbetweenchkandobj> innLineItems {get;set;}
    public List<Order_Item__c> ordIt{get;set;}
    public set<Id> displayandhideIdes {get;set;} // to display orderdetails again
    public  SET<id>  orid{get;set;}
    public List<BLN_Mytickets_BAL.inncls>  exportOrders{get;set;}
    public List<BLN_Mytickets_BAL.inncls>  ValuesOfseletedorder{get;set;}
    
    public BLN_Debug blndebug {get;set;}
    public BLN_Mytickets_BAL blnMyticketsBal {get;set;}
    public BLN_Mytickets_BAL.inncls editOrdRec{get;set;}   
    public Ticket__c addGuest{get;set;}  
    public BLN_Event__c   se{get;set;}
    public MAP<id,ticket__c> mapticWithId {get;set;}
    public MAP<id,order_item__c> mapitemWithId {get;set;}
    public MAP<id,BLN_Mytickets_BAL.inncls> mapOrdIsWithInner{get;set;}
    public MAP<id,GN_User__c> mapguIdWithGNU {get;set;}
    public string urlCheck {get;set;}
    public string RecordsForExport;
    public LIST<Country__c> country{get; set;}
   public LIST<State__c> states{get; set;}
   public LIST<SelectOption> countryOptions{get; set;}
   public LIST<SelectOption> stateOptions{get; set;}
   public string selectedCountry{get; set;}
   public String selectedState{get; set;}
   public LIST<LIST<NAICS_Code__c>> listOfnaicscodes{get; set;}
   public String checkNAICSforEdit{get; set;}

    public void displayPermissions(){
        Cookie k = ApexPages.currentPage().getCookies().get('counter');
        //system.debug('CCCCCCCCCCCCCCCCCC '+ k.getValue());
        if(k!=null){ 
            selectedEvent = k.getValue();
        }
        myticket = new BLN_UtillDisplayLinks();
        
        BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
        se = new BLN_Event__c();
        try{
            se = blneventdetailbal.eventdetails(selectedEvent );
             myticket.EventName=se.Name;
         }catch(exception e){}
        myticket.isTicketsPageExpand='expand';
        myticket.isOrdersPage='active';
        myticket.tablabel='Orders';
        myticket.EventId = selectedEvent ;
        myticket.userPermissions(userInfo.getUserId(),selectedEvent);
        
    }
  
   public String getRecordsForExport() {
        return RecordsForExport;
    }
                        
    public void setRecordsForExport(String s) {
        this.RecordsForExport = s;
    }
  
    public LIST<SelectOption> orderTypes{get; set;}
    public String selectedOrderType{get; set;}
    
    // This is constructor for this class in this i am getting event
    public BLN_MyticketsCon(){
        
        orderTypes= new LIST<SelectOption>();
        orderTypes.add(new SelectOption('All', 'All'));
        orderTypes.add(new SelectOption('Completed', 'Completed'));
        orderTypes.add(new SelectOption('Not Completed', 'Not Completed'));
        orderTypes.add(new SelectOption('Cancelled', 'Cancelled'));
        selectedOrderType= 'All';
        
        isOrderEdit = false; displayandhideIdes = new SET<id>();
        ShowCurrentTickets = true;
        displayTicForCancel = false;
        blnMyticketsBal = new BLN_Mytickets_BAL();
        loginUserId = userInfo.getUserId();  // To know login user Id
        //loginUserId = '005c00000013uMx';
        blndebug = new BLN_Debug();
        urlCheck =  ApexPages.currentPage().getUrl();
        if(urlCheck !=''){  // checking url for knowing about currentpage
            if((urlCheck.toLowerCase()).contains('BLN_Mytickets'.toLowerCase())){
                urlCheck ='BLN_Mytickets';
            }else{
                urlCheck ='BLN_Orders';
            }
        }
        
        
        Cookie k = ApexPages.currentPage().getCookies().get('counter');
       
         if(k!=null){ 
            if(k.getValue()!=''){
               selectedEvent = k.getValue();
               statistics();
            }else{
            selectedEvent ='All';
            }
            
            
         }else{
            selectedEvent ='All';
         }
        
        try{
        
            if(selectedEvent ==null  ){
                selectedEvent ='All'; 
            }
        }catch(exception er){
            selectedEvent ='All'; // default selected event
        }
        
        // selectedEvent  = Apexpages.CurrentPage().GetParameters().get('id');
        
        system.debug('MMMMMMMMMMMMMMMM '+selectedEvent );
        try{  
            onchangeEvent(); // Calling this method for getting all the order,tickets and orderitems of events
        }catch(exception es){}
        countryStates();
        statesBasedOnCountry();
        
        listOfnaicscodes= new LIST<LIST<NAICS_Code__c>>();
        List<NAICS_Code__c> naicscodeslist = new List<NAICS_Code__c>();
        for(NAICS_Code__c naics : [SELECT id,Name,Description__c FROM NAICS_Code__c]){
            naicscodeslist.add(naics); 
            if(naicscodeslist.size() == 999){
                listOfnaicscodes.add(naicscodeslist);                
                naicscodeslist= new LIST<NAICS_Code__c>();
            }
        }
       
       if(naicscodeslist.size() != 0){
            listOfnaicscodes.add(naicscodeslist);
        } 
        
    }
 
 

 // this method is getting all the order,orderItem and tickets of user respect to event.
 // This controller is same for BLN_MyTickets and BLN_orders so i am checking the page in this method.
 // according to that page we will get order and all
 
 public List<List<BLN_Mytickets_BAL.inncls>> listOfListOrders{get;set;}
 
 
 
      public void onchangeEvent(){
        mapticWithId  = new MAP<id,ticket__c>(); 
        mapitemWithId = new MAP<id,order_item__c>();
        mapguIdWithGNU = new MAP<id,GN_User__c>();
        inncurrentTickets= new List<BLN_Mytickets_BAL.inncls>();
        List<Ticket__c> ticketsList = new List<Ticket__c>();
        BLN_Gnuser_DAO guDAO = new BLN_Gnuser_DAO();
        listOfListOrders = new List<List<BLN_Mytickets_BAL.inncls>>();
       
        mapOrdIsWithInner = new MAP<id,BLN_Mytickets_BAL.inncls>();
     
          SET<id> GnuserList = new  SET<id>();
        //Getting all tickets and orders of perticular user
        
        system.debug('PPPPPPPPPPPPPPPPP '+selectedEvent+'WWWWWWWWWWWW '+urlCheck);
        integer k =0;
      
        for(BLN_Mytickets_BAL.inncls innTotal : blnMyticketsBal.userTickets(loginUserId,selectedEvent,urlCheck, selectedOrderType)){
            mapOrdIsWithInner.put(innTotal.orderInn.id,innTotal);
            GnuserList.add(innTotal.orderInn.Client_GN_User__c); 
              if(displayandhideIdes.size()>0){ 
               if(displayandhideIdes.contains(innTotal.orderInn.id)){
                   innTotal.displayOrderItems =true;
               }  
             }  
            
          k++;
            inncurrentTickets.add(innTotal);
            if(k==1000){
              listOfListOrders.add(inncurrentTickets);
              inncurrentTickets= new List<BLN_Mytickets_BAL.inncls>();
              k=0;
            }
            
           
          
            ticketsList.addAll(innTotal.ticketsInn);
             for(order_item__c orditem : innTotal.orderItemInn){
                 mapitemWithId.put(orditem.id,orditem ); // map orderItem with its id
                
              }
        } 
        
        
       listOfListOrders.add(inncurrentTickets);
       
         for(Ticket__c tc :ticketsList){
           mapticWithId.put(tc.id,tc); // Map tickets with its id  
           GnuserList.add(tc.Client_GN_User__c);
         } 
         
         for(GN_User__c gnu : guDAO.getGnuserList(GnuserList)){
            mapguIdWithGNU.put(gnu.id,gnu); 
         }
       system.debug('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE '+listOfListOrders);
       system.debug('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF '+inncurrentTickets);
       
     }
 
    //  This method is to diplay selected order details popup in Mytickets Page
    public PageReference renderDetails() {
        rowNum= Integer.valueOf(apexpages.currentpage().getparameters().get('guestindex'));
        if(inncurrentTickets[rowNum].displayOrderItems ==true){
            inncurrentTickets[rowNum].displayOrderItems =false;
            displayandhideIdes.remove(inncurrentTickets[rowNum].orderInn.id);
        }else{
            inncurrentTickets[rowNum].displayOrderItems=true;
            selectedOrder =inncurrentTickets[rowNum].orderInn.id;
            displayandhideIdes.add(inncurrentTickets[rowNum].orderInn.id);
        }
        try{
        
        } catch(exception re){}
        
        return null;
    }
 
 
   // -------------------------------------------  Actions on orders page  ----------------------------------- --> 
 
    // Open edit popup with selected record values
    public void displayorderEditform(){
        editOrdRec =new  BLN_Mytickets_BAL.inncls();
        gnUser  = new GN_User__c();
        
        string editableOrder = Apexpages.currentPage().getParameters().get('edform');
        try{
            editOrdRec = mapOrdIsWithInner.get(editableOrder);
            gnUser = mapguIdWithGNU.get(editOrdRec.orderInn.Client_GN_User__c);
        }catch(exception ex){}
        companyName = editOrdRec.orderInn.Client_Company__r.Name;
        isOrderEdit = true;
    }
     
    // saving user info after editing record
    public PageReference Saveord() {
        user newu = new user();
        newu.firstName = gnUser.First_Name__c;
        newu.lastName = gnUser.Last_Name__c ;
        newu.Email = gnUser.Email__c;
        newu.userName = gnUser.Email__c;
        /*
        if(companyName !=null){
            newu.companyName = companyName ;
        }else{
            newu.companyName = gnUser.First_Name__c+''+gnUser.Last_Name__c;
        }
       */ 
        saveLogic(newu,new Ticket__c(),editOrdRec.orderInn,gnUser);// In this method user Insertion,company insertion and user role will be done
        isOrderEdit = false; // close order edit popup
        onchangeEvent();
        return null;
    }
 
    // This is method is for closing edit popup of both tickets and orders
    public PageReference CloseGuests() {
        displyAddGuest = false; //close add guest popup
        if(isOrderEdit){
            isOrderEdit =false; // close order edit popup
        }
        return null;
    } 
    
    
    // cancel total order 
    public PageReference cancelTotalorder() {
        BLN_Mytickets_BAL bal = new BLN_Mytickets_BAL();
        orid = new SET<id>();
        orid.add(Apexpages.currentPage().getPArameters().get('guestindex12'));
        
        
        for(order__c od : bal.getOrdersOrdItems(orid)){
            SET<id>  oridItemsuniq = new SET<id>();
            for(Order_Item__c orditem: od.Order_Items__r){
                bal.cancelOrderItemValues(bal.orderItemWithlineItem(orditem.id));
            } 
        }
          
      /*     
           for(order__c odw : bal.getOrderstickets(orid)){
           List<Ticket__c> ty = new List<Ticket__c>();
            ty.addAll(odw.Tickets__r);
            bal.cancelTickets(ty); // canceling the tickets
            bal.cloneTickets(ty); // Cloning tickets for release tickets
         }    
       */  
        bal.uypdateOrderStatus(orid); // updating order Status
        onchangeEvent(); // To refresh the grid
        
        //Refreshing page after cancel
        PageReference pageTemp = new Pagereference('/apex/BLN_orders');
        pageTemp.setRedirect(true);
        return pageTemp ;
    }
 
   
    // Exporting All pages orders
    public pageReference exportOrders(){
       // RecordsForExport='All';
        //exportOrders = new List<BLN_Mytickets_BAL.inncls>();
       // exportOrders.addAll(inncurrentTickets);
        pageReference pg = page.BLN_ExportordersAll;
        return pg;
    }
    
    // export only Selected orders
    public pageReference  userSelectPerticularToExport(){
        exportOrders = new List<BLN_Mytickets_BAL.inncls>();
        for(BLN_Mytickets_BAL.inncls od :inncurrentTickets){
            if(od.selectCheckBox){
                exportOrders.add(od);
            }
        }
        pageReference pg = page.BLN_Exportorders;
        return pg; 
    } 
    
  
   
   
    
    // Display order details pop up in orders page
    // This will fire when we click on order name
    public void renderDetailsfororder() {
        ValuesOfseletedorder = new List<BLN_Mytickets_BAL.inncls>();
        string selectedOrd = apexpages.currentpage().getparameters().get('selectedordId');
        try{
          ValuesOfseletedorder.add(mapOrdIsWithInner.get(selectedOrd ));
        }catch(exception e){}
        orddetailbool = true;
    }
    
    // Closing order detail popup
    public PageReference cancelOrdDetail(){
        orddetailbool = false;
        PageReference pageTemp2 = new Pagereference('/apex/BLN_orders');
        pageTemp2.setRedirect(true);
        return pageTemp2 ;
    }
 
  // -------------------------------------------  Actions on orders page  End -----------------------------------  
 
  
  
 // ----------------------------------------- Actions on order details popup --------------------------------------   
  public GN_User__c gnUser{get;set;}
  public Company__c comp {get;set;}
  public Company_Ext__c compext {get;set;}
  public MAP<id,List<Reg_Setting__c>> settingsForbuyerMAp{get;set;}
  public  List<Reg_Setting__c> settingsForbuyer{get;set;} //To display buyer settings
  public UC_Role__c ucrole{get;set;}
  public List<surveyCls> ticketLevelQuestions {get;set;}
  public  List<surveyCls> eventLevelQuestions {get;set;}
  public string groupnamesForUi{get;set;}
  public string compid {get;set;}
  public string beforeEditEmail {get;set;}
  public string beforecompany{get;set;}
  
    // disply edit guest  pop up
    public PageReference editTicket(){
    
     gnUser = new GN_User__c();
      addGuest = new Ticket__c ();
      ucrole = new UC_Role__c();
     // groupnamesForUi = new SET<string>();
      checkNAICSforEdit= '';
      settingsForbuyerMAp = new MAP<id,List<Reg_Setting__c>>();
      settingsForbuyer = new List<Reg_Setting__c>();
      
       string ticketId = Apexpages.currentPage().getParameters().get('TicketIdparam');
       addGuest=  mapticWithId.get(ticketId);
       gnUser = mapguIdWithGNU.get(addGuest.Client_GN_User__c);
       BLN_RegistrationSettings_BAL RegSettingsBAL = new BLN_RegistrationSettings_BAL();
        beforeEditEmail = gnUser.Email__c;
          
        SET<id> ticketIdsset = new SET<id>();
        RegSettingsBAL = new BLN_RegistrationSettings_BAL();
        ticketIdsset.add(addGuest.item__c);
        
      if(ticketIdsset.size() >0){  
        settingsForbuyerMAp= RegSettingsBAL.getTicketSettings(ticketIdsset,selectedEvent);
        
          if(settingsForbuyerMap.size()>0){
             settingsForbuyer.addAll(settingsForbuyerMap.get(addGuest.item__c));
            }
       
       }  
       
       for(Reg_Setting__c rs : settingsForbuyer){
        if(rs.Group_Name__c!='Billing Address'){
         if(rs.Included__c==true || rs.required__c==true){
            groupnamesForUi += ','+rs.Column_Name__c;
         }
        }
       }
       
      compid =''; 
       comp = new Company__c(); 
       compext = new Company_Ext__c();
        compid = addGuest.Client_company__c;
       try{
         comp =[select id,name,Description__c,Website_URL__c From Company__c Where Id=:compid];
         compid = [select id,company__c,Client_Company__c,Client_GN_User__c from Ticket__c where id=:ticketId].Client_Company__c;
         //beforecompany = compid;
       }catch(exception ed){}
       
     if(compid!=''){
       try{
       compext= [select id,Blog_URL__c,Business_Address1__c,Business_Address2__c,Business_City__c,BLN_Business_Country__c,BLN_Business_State__c,Business_Zipcode__c,Company__c,Duns_Number__c,
       Established_Date__c,Keywords__c,Number_Of_Employees__c,Primary_Business_Category__c,Primary_NAICS_Code__c,Revenue__c,Secondary_Business_Category__c,Secondary_NAICS_Code__c,Tax_Id__c,Work_Phone__c from Company_Ext__c where company__c=:compid];
       companyName = addGuest.Client_company__r.Name;           
       beforecompany = companyName;
       checkNAICSforEdit= '';
                checkNAICSforEdit= '$$$$';
       if(compext.Primary_NAICS_Code__c != NULL){
           checkNAICSforEdit += compext.Primary_NAICS_Code__c;
       }
       if(compext.Secondary_NAICS_Code__c != NULL){
           checkNAICSforEdit += compext.Secondary_NAICS_Code__c;
       } 
       system.debug('  NAICS FOR EDIT '+checkNAICSforEdit);     
            
       }catch(exception er){}
     }
     system.debug('Company Ext '+compext);
     system.debug('Company Id'+compid ); 
     system.debug('User values '+gnUser ); 
     
    try{ 
     ucrole  = [select id,Company__c,Event__c,Invited_by__c,Invited_date__c,RoleId__c,GN_User__c,User_Type__c from UC_Role__c where company__c =:addGuest.Client_company__r.id and GN_User__c=:addGuest.Client_GN_User__c];
     }catch(exception rt){
        
     }
     
    ticketLevelQuestions = new  List<surveyCls>();
   eventLevelQuestions = new  List<surveyCls>();
   
    Map<ID, Item_Question__c> itemQue = new Map<ID, Item_Question__c>([select Question__r.Answer_Type__c,Question__r.Question_Text__c,id,Question_Level__c,Event__c,Question__c,Question__r.Name from Item_Question__c where Item__c=:addGuest.Item__c OR Event__c=:addGuest.Event__c ]);
    Map<ID, User_Answer__c> itemans = new Map<ID, User_Answer__c>([select Answer__r.Answer_Text__c,Answer__c,Item_Question__c,Item_Question__r.Question__r.Name,UAnswer_Text__c,User__c,Ticket__c from User_Answer__c where Item_Question__c IN :itemQue.keySET() and (Ticket__c=:ticketId OR Item_Question__r.Question_Level__c!='Ticket Level')]);
    
    for(Item_Question__c iq:itemQue.values()){
      List<User_Answer__c> unsList = new List<User_Answer__c>();
      for(User_Answer__c uns:itemans.values()){
         if(iq.id == uns.Item_Question__c){
               unsList.add(uns);
         } 
       }     
         if(iq.Question_Level__c!='Ticket Level'){
            eventLevelQuestions.add(new surveyCls(iq,unsList));
            
         }else{
             ticketLevelQuestions.add(new surveyCls(iq,unsList));
         } 
      
    }
     
       displyAddGuest= true;
       return null;
    }
   
   
   // survey Questions class
   
    
  public class surveyCls{
    public Item_Question__c question{get;set;}
    public List<user_Answer__c> answers{get;set;}
    public surveyCls(Item_Question__c question1,List<user_Answer__c> answers1){
        question = new Item_Question__c();
        answers = new List<user_Answer__c>(); 
        if(question1!=null){
        this.question =question1;
        }
        if(answers1.size()>0){
        this.answers = answers1;
        }
    }
  }

   // ------------------------------------------------------------------------------------- States & Countries Start ----------------------------------------------------------------------------------    
    public void countryStates(){ 
        country = new LIST<Country__c>();
        countryOptions= new LIST<SelectOption>();
        
        for(Country__c c: [SELECT ID, NAME, Short_Name__c, Long_Name__c, Order__c FROM Country__c ORDER BY Order__c]){
            countryOptions.add(new SelectOption(c.id, c.Long_Name__c));
            if(c.Short_Name__c == 'US'){
                selectedCountry = c.id;
            }
        }
        System.debug('CCCCCC:'+countryOptions);
        stateOptions = new LIST<SelectOption> ();   
    }

    public void statesBasedOnCountry(){
        system.debug('Selected Country '+selectedCountry);
        stateOptions= new LIST<SelectOption> ();   
    
        for(State__c s: [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c, Order__c FROM State__c WHERE Country__c =: selectedCountry]){
            stateOptions.add(new SelectOption(s.id,s.Long_Name__c));
        }
        System.debug('SSSSSS:'+stateOptions);
    }
// --------------------------------------------------------------------------------------- States & Countries End ----------------------------------------------------------------------------------
    
   
   
   public string compidchanged{get;set;}
   
    // saving guest info after editing record
    public PageReference SaveGuests() {
        user newu = new user();
        newu.firstName = addGuest.First_Name__c;
        newu.lastName = addGuest.Last_Name__c ;
        newu.Email = addGuest.Email__c;
        newu.userName = addGuest.Email__c;
        
        saveLogic(newu,addGuest,new order__c(),gnUser); // In this method user Insertion,company insertion and user role will be done
        
         if(isAttendeesPAge!='Attendee'){
           onchangeEvent();
           ValuesOfseletedorder= new List<BLN_Mytickets_BAL.inncls>();
           ValuesOfseletedorder.add(mapOrdIsWithInner.get(selectedOrder)); 
        } 
       displyAddGuest= false; // closing pop up
       return null;
    }


   // This function is for canceling tikcets in the order item level   
    public PageReference cancelDirectTicket() {
        BLN_Mytickets_BAL bal = new BLN_Mytickets_BAL();
        orid = new SET<id>();
        string orderIdTogetBack ='';
        List<Order_Item__c> ordIt = bal.orderItemWithlineItem(ApexPages.currentPage().getParameters().get('canordItemId'));
        bal.cancelOrderItemValues(ordIt);
         id orderIdforRefreshpop=ordIt[0].order__c;
        if(ordIt.size()>0 ){
        orderIdTogetBack =ordIt[0].order__r.id;
        orid.add(ordIt[0].order__c);
          
           bal.uypdateOrderStatus(orid);
        }
        onchangeEvent();
     
         ValuesOfseletedorder= new List<BLN_Mytickets_BAL.inncls>();
         ValuesOfseletedorder.add(mapOrdIsWithInner.get(orderIdforRefreshpop));
        return null;
    }
 
    
    
   // This function is for canceling tikcet  
     public PageReference  cancelPerticularGuestsTic(){
        List<ticket__c> tickets = new List<ticket__c> ();
        BLN_Mytickets_BAL bal = new BLN_Mytickets_BAL();
        innLineItems = new List<BLN_Mytickets_BAL.Bondbetweenchkandobj>();
        orid = new SET<id>();
        Order_Item__c ordItin = new Order_Item__c();
         string tid = ApexPages.currentPage().getParameters().get('canticId');
         system.debug('XXXXXXXXXXXXXXXQQQQQQQQQQQQ '+tid );
         Ticket__c tc = new ticket__c();
         tc = mapticWithId.get(tid);
         tickets.add(tc);
         id orderIdforRefreshpop= tc.order__c;
         orid.add(tc.order__c);
         ordItin = mapitemWithId.get(tc.order_item__c);
         bal.chengeItemOrderCount(ordItin ,tickets); // decresing amount and quantity of order Item
         bal.cancelTickets(tickets); // cancel selected Tickets
         bal.cloneTickets(tickets); // create new tickets
         bal.uypdateOrderStatus(orid);
         
        if(isAttendeesPAge!='Attendee'){
         onchangeEvent();
         ValuesOfseletedorder= new List<BLN_Mytickets_BAL.inncls>();
         ValuesOfseletedorder.add(mapOrdIsWithInner.get(orderIdforRefreshpop));
        }
      return null;
   } 
    
    // hide cancel popup
    public void closeCan(){
     displayTicForCancel = false;
    }
    
    
 // ----------------------------------------------- popup actions End --------------------------------------------
  
  // This is utill for order edit and ticket edit
  // inserting user,company and uc role and update ticket or update order 
     public void saveLogic(user newu,Ticket__c addGuest,order__c saveord,GN_User__c gnUserEdit){
       BLN_Quick_Registration_BAL quickbal= new BLN_Quick_Registration_BAL();
       String userid=quickbal.checkUser(newu); // Checking user already exists
       string compId ;
       BLN_StatusMessage userMsg;
       
      if(userid==null){ // if not exists calling insert user method
            userMsg=quickbal.insertUser(newu); // inserting user
                  if(userMsg.successBool){
                      userid=userMsg.successId;
                  }
                   gnUserEdit.First_Name__c= newu.firstName;
                   gnUserEdit.Last_Name__c = newu.lastName ;
                   gnUserEdit.Email__c= newu.Email;
                   gnUserEdit.User__c = userid;
                   gnUserEdit.id=null;
                   dataBase.saveResult saver =  DataBase.insert(gnUserEdit,false);
             
           
                 if(!(compidchanged!=null && compidchanged!='')){ // If user picks existing Company
                      if(beforecompany == addGuest.company__c){ // If your change email but not company 
                          if(ucrole!= null){
                            UC_Role__c urolenew = new UC_Role__c ();
                            urolenew = ucrole.clone(false,false,false,false);
                            urolenew.id=null;
                            urolenew.GN_User__c = gnUserEdit.id;
                            dataBase.insert(urolenew,false);
                          }
                      }else{ // If user changes email,company. 
                          company__c comp = new company__c();
                          comp.Name = addGuest.company__c;
                           BLN_StatusMessage CompanyMsg=quickbal.insertCompany(comp ,null); // insert company
                             if(CompanyMsg.Successbool){
                               compId = CompanyMsg.successId;
                              }
                              BLN_UCRole_DAO ucRoleDao = new BLN_UCRole_DAO();
                              system.debug('Uid '+userid +'  Comp id '+compId );
                              BLN_StatusMessage UCRoleMsg = quickbal.insertUCRole(gnUserEdit.id,compId ,'' ,'Company Admin'); // insert user company Role
                            
                             if(!isOrderEdit){      
                               addGuest.Client_Company__c = compId ;
                             }else{
                                saveord.Client_Company__c = compId;
                             }
                       }      
                   }else{
                       if(!isOrderEdit){    
                           addGuest.Client_Company__c = compidchanged;
                       }else{
                            saveord.Client_Company__c = compidchanged;
                         }
                     } 
             system.debug('QQQQQQQQQQ '+gnUserEdit.id +'qqqqqqqqqq '+isOrderEdit);
                if(!isOrderEdit ){
                   addGuest.Client_GN_User__c =gnUserEdit.id;
                }else{
                   saveord.Client_GN_User__c = gnUserEdit.id;
                }
        
            }else{
               // If user does not change his email address and company name
                  if(beforeEditEmail == newu.Email){
                      if(!isOrderEdit){
                          companyName = addGuest.Company__c;
                       }
                      if(companyName != beforecompany){ 
                         if(compidchanged!=null && compidchanged!=''){
                              if(!isOrderEdit ){
                                addGuest.Client_Company__c = compidchanged;
                               }else{
                                saveord.Client_Company__c = compidchanged;
                              }
                          }else{
                              company__c comp = new company__c();
                               if(!isorderEdit){
                                comp.Name = addGuest.company__c;
                               }else{
                                comp.Name = companyName;
                               }
                               BLN_StatusMessage CompanyMsg=quickbal.insertCompany(comp ,null); // insert company
                               if(CompanyMsg.Successbool){
                                  compId = CompanyMsg.successId;
                                     if(!isOrderEdit){
                                        addGuest.Client_Company__c = compId ;
                                       }else{
                                        saveord.Client_Company__c = compId;
                                      }
                                  Gn_User__c gnu = [select first_Name__c,Last_Name__c,Email__c,id from Gn_User__c where Email__c=:newu.Email limit 1];
                                  BLN_UCRole_DAO ucRoleDao = new BLN_UCRole_DAO();
                                  BLN_StatusMessage UCRoleMsg = quickbal.insertUCRole(gnu.id,compId ,'' ,'Company Admin');
                                }
                                
                          }                     
                      }
                  }else{
                           if(compidchanged!=null && compidchanged!=''){
                                 
                              if(!isOrderEdit ){
                               Gn_User__c gnu = [select first_Name__c,Last_Name__c,Email__c,id from Gn_User__c where Email__c=:newu.Email limit 1];
                                addGuest.Client_GN_User__c = gnu.id;
                                addGuest.Client_Company__c = compidchanged;
                               }else{
                                 Gn_User__c gnu = [select first_Name__c,Last_Name__c,Email__c,id from Gn_User__c where Email__c=:newu.Email limit 1];
                                saveord.Client_GN_User__c = gnu.id;
                                saveord.Client_Company__c = compidchanged;
                              }
                       
                       
                          }else{
                               company__c comp = new company__c();
                               if(!isorderEdit){
                                comp.Name = addGuest.company__c;
                               }else{
                                comp.Name = companyName;
                               }
                               BLN_StatusMessage CompanyMsg=quickbal.insertCompany(comp ,null); // insert company
                               if(CompanyMsg.Successbool){
                                  compId = CompanyMsg.successId;
                                    Gn_User__c gnu = [select first_Name__c,Last_Name__c,Email__c,id from Gn_User__c where Email__c=:newu.Email limit 1];
                                
                                      if(!isOrderEdit){
                                         addGuest.Client_Company__c = compId ;
                                         addGuest.Client_GN_User__c = gnu.id;
                                       }else{
                                         saveord.Client_Company__c = compId;
                                         saveord.Client_GN_User__c = gnu.id;
                                      }
                                   BLN_UCRole_DAO ucRoleDao = new BLN_UCRole_DAO();
                                  BLN_StatusMessage UCRoleMsg = quickbal.insertUCRole(gnu.id,compId ,'' ,'Company Admin');
                                }
                           }
                       }
                  }
             
             if(!isOrderEdit){ 
                update addGuest;
             }else{
                update saveord;
               }
        }
    
    // TO DISPLAY THE STATISTICS OF AN EVENT
        public BLN_Mytickets_BAL myTicketsBAL{get; set;}
        public Integer totalTransactions{get; set;}
        public Integer totalAttendees{get; set;}
        public Decimal TotalAmount{get; set;}
        public Decimal AmountThroughCheck{get; set;}
        public Decimal AmountThroughCredit{get; set;}
        public Decimal AmountThroughCash{get; set;}
        public Decimal AmountThroughExtPay{get; set;}
            
        public pagereference statistics(){
            
            myTicketsBAL= new BLN_Mytickets_BAL();
            totalTransactions=0;
            totalAttendees= 0;
            LIST<Order__c> orderList= new LIST<Order__c>();
            orderList= myTicketsBAL.ordersListForSta(selectedEvent);
            totalTransactions= orderList.size();
            totalAttendees= myTicketsBAL.attendeesListForEvent(selectedEvent);
            
            LIST<AggregateResult> PaymentAggregateList= new LIST<AggregateResult>();
            PaymentAggregateList= myTicketsBAL.PaymentsForEvent(selectedEvent);
            TotalAmount=0;
            AmountThroughCheck= 0;
            AmountThroughCredit= 0;
            AmountThroughCash=0;
            AmountThroughExtPay=0;
            TotalAmount= 0;
            paymentTypeInnerList= new LIST<paymentTypeInner>();
            for(AggregateResult payAgg: PaymentAggregateList){
                paymentTypeInnerList.add(new paymentTypeInner(String.valueOf(payAgg.get('mode')), Decimal.valueof(String.valueOf(payAgg.get('amt')))));
                TotalAmount += Decimal.valueof(String.valueOf(payAgg.get('amt')));
                /*
                if(String.valueOf(payAgg.get('mode')) == 'Check'){
                    AmountThroughCheck += Decimal.valueof(String.valueOf(payAgg.get('amt')));
                }
                if(String.valueOf(payAgg.get('mode')) == 'MasterCard' || String.valueOf(payAgg.get('mode')) == 'Visa' || String.valueOf(payAgg.get('mode')) == 'Discover' || String.valueOf(payAgg.get('mode')) == 'Credit Card' || String.valueOf(payAgg.get('mode')) == 'American Express'){
                    AmountThroughCredit += Decimal.valueof(String.valueOf(payAgg.get('amt')));            
                }  
                
                if(String.valueOf(payAgg.get('mode')) == 'Cash'){
                    AmountThroughCash += Decimal.valueof(String.valueOf(payAgg.get('amt')));            
                }  
                */    
            }
            return null;
        }
        
     // Get Company Names
  @RemoteAction
    public static List<Company__c> getCompanies(string searchstr,string emailid){
     SET<id> comids = new SEt<id>();
       for(UC_Role__c uc : [select id,Company__r.name,Company__c,RoleId__r.Name from UC_Role__c where GN_User__r.email__c =:emailid and (RoleId__r.Name='Company Admin' OR RoleId__r.Name='Event Admin' )]){
            comids.add(uc.Company__c);
           
       }
      string v =  searchstr   + '%';  
      return [select id,name from Company__c where id In :comids and name like :v ] ;
   }   
   
    @RemoteAction
    public static List<Company__c> getCompanies1(string searchstr,string emailid){
     SET<id> comids = new SEt<id>();
       for(UC_Role__c uc : [select id,Company__r.name,Company__c,RoleId__r.Name from UC_Role__c where GN_User__r.email__c =:emailid and (RoleId__r.Name='Company Admin' OR RoleId__r.Name='Event Admin' )]){
            comids.add(uc.Company__c);
           
       }
      string v =  searchstr   + '%';  
      return [select id,name from Company__c where id In :comids and name like :v ] ;
   }   
   
   public String naicsCodesString{get; set;}
        public pagereference sendNaicsCodes(){
        
            IF(ApexPages.currentPage().getParameters().get('naicsCodes') != ''){
            naicsCodesString=ApexPages.currentPage().getParameters().get('naicsCodes');
            }ELSE{
                naicsCodesString= NULL;
            
            }
            system.debug(ApexPages.currentPage().getParameters().get('naicsCodes')+' NAICS CODES STRING '+naicsCodesString);
            if(naicsCodesString!= NULL){
                
                LIST<String> naicsCodes= new LIST<String>(naicsCodesString.split('-'));
                system.debug(naicsCodes.size()+' NAICS CODES '+naicsCodes);
                checkNAICSforEdit= '';
                checkNAICSforEdit= '$$$$';
                if(naicsCodes.size() >1){
                    compext.Primary_NAICS_Code__c= naicsCodes[1];
                    checkNAICSforEdit += compext.Primary_NAICS_Code__c;
                    compext.Secondary_NAICS_Code__c= NULL;
                    
                }
                if(naicsCodes.size() >2){
                    compext.Secondary_NAICS_Code__c= naicsCodes[2];
                    checkNAICSforEdit += compext.Secondary_NAICS_Code__c;
                }
                
            }
            system.debug(compext.Primary_NAICS_Code__c+' SELECT NAICS CODES '+compext.Secondary_NAICS_Code__c);
            return null;
        } 
        
        
        public LIST<paymentTypeInner> paymentTypeInnerList{get; set;}
        public Class paymentTypeInner{
        
            public String paymentType{get; set;}
            public Decimal paymentAmount{get; set;}
            
            public paymentTypeInner(String paymentType, Decimal paymentAmount){
                this.paymentType= paymentType;
                this.paymentAmount= paymentAmount;
            }
    
        }
     
}