global without sharing class BLN_RegistrationnewCon {

/***************************************************************************************************************************************************************************************************
*   Author                  : Mahesh Sakunala
*   Date                    : 02/06/2014 
*   Purpose                 : This class is for Registration i.e. User buys tickets through payment gateway, User can also apply promo codes and fill surveys based on the event organizer settings.
*   Last Modified           : Mahesh Sakunala - 10/09/2014
*   Last modified           : Phani 27/10/2014 - Reason : He has to check discount value in Promotion table, Actually he has to check on item promotion table 
*   Last Modified           : Phani 22/12/2014 - reconstructine entire page   
*****************************************************************************************************************************************************************************************************/

//------------------------------------------------------------------------ Variables Declaration Start --------------------------------------------------------------------------------- 
public String itqnty{get;set;}
public String itoldqnty{get;set;}
public String itpoolid{get;set;}
public String itlabel{get;set;}
public string selectedcompany {get ; set ;}
public String checkNAICSforEdit{get; set;}
public Integer EventDaysRemaining{get; set;} // To Calculate Event Days Remaining
public dateTime EventDaysRemainingDT{get; set;} // To Calculate Event Days Remaining
public boolean isDt{get;set;}

public BLN_Event__c registrationEvent{get; set;} // To fetch event details
public Registration_Template__c registrationTemplate{get; set;} // To fetch template details
public LIST<TicketInnerClass> TicketList{get;set;} // To display forms after selection of items
public LIST<BLN_Item__c> EventItems{get; set;} // To fetch list of items
public LIST<ItemInnerClass> ItemList{get; set;} // To display list of items
public LIST<ItemInnerClass> CalcItemList{get; set;}
public List<RegItemInnerClass> RegItemList{get; set;} // To display list of items
public List<RegItemInnerClass> CalcList{get;set;}
public Company_Ext__c  comextnew {get;set;}
public LIST<Company_Ext__c> comext {get ; set ;}
public Company__c compdetails{get ; set ;}


public boolean isTest =false; 

public MAP<String,LIST<ItemInnerClass>> RegistrationItemList{get; set;} // To display list of items based on Tab Settings
public Boolean ShowSecondPage{get; set;} // To Show & Hide forms
public Boolean HideLogin{get; set;} // To Show & Hide Login
public String Promocode{get;set;} //To input promo code
public String Result{get;set;} // To store result
public Decimal TotalAmount{get;set;} // To calculate total amount
public Decimal TotalAmountWithTaxes{get;set;} // To calculate total amount with taxes
public Decimal TaxAmount{get;set;} // To calculate tax amount
public Decimal FeeAmount{get;set;} // To calculate boothleads fee amount
public Decimal DiscountAmount{get;set;} // To calculate discount amount i.e. Promo Discount
public Decimal DiscountedAmount{get;set;} // To calculate differnce i.e. Sub total
public String EmailAddress{get;set;} // Boothleads User Email
public String Password{get;set;} // Boothleads User Password
public Company_Ext__c companydetails{get;set;} // Company_ext Details
public Company__c comp{get;set;} // Company Details
public GN_User__c IndUser{get;set;} // Each Individual User
public User LoggedInUser{get;set;} // Logged In Boothleads User
public GN_User__c LoggedInGNUser{get;set;} // Logged In Boothleads User
public MAP<Id,Id> PromotionIdMap{get;set;} // To Map Promotion & Item
public Integer PromotionCount{get;set;} // To Map Promotion & Item
public Pay_Address__c PayAddress{get;set;}// To store Payment address
public String OrderFirstname{get;set;} // For Buyer Info
public String OrderLastname{get;set;} // For Buyer Info
public String OrderEmail{get;set;} // For Buyer Info
public String PaymentAddress1{get;set;} // For Payment Address
public BLN_UtillDisplayLinks RegistrationLinks{get;set;} // Initialzing Utility class to display menu and side bar in the portal
public MAP<id,LIST<Reg_Setting__c>> RegSettingsMap{get;set;} // To store registration settings for tickets
public MAP<id,LIST<Question__c>> QuestionsMap{get;set;} // To store survey questions for each ticket selected
public LIST<Question__c> EventQuestions{get;set;} // To fetch all event questions
public LIST<UserAnswerInnerClass> UserEventAnswer{get;set;} // Inner Class Instance for Event Survey Questions & Answers
public SET<Id> ItemsSet{get;set;}
public LIST<Ticket__c> RegTickets{get;set;}
public LIST<Reg_Setting__c> DisplaySettings{get;set;}
public Integer SessionTime{get;set;}
public Company_Ext__c CheckAddress{get;set;}
public String PackageInfo{get;set;}
public string selectedCountry{get; set;}
public String selectedState{get; set;}
public LIST<Country__c> country{get; set;}
public LIST<State__c> states{get; set;}
public LIST<SelectOption> countryOptions{get; set;}
public LIST<SelectOption> stateOptions{get; set;}

   
public String naics1 {get ; set ;}
public String naics2 {get ; set ;}
public LIST<NAICS_Code__c> naicscodeslist {get ; set ;}
public LIST<LIST<NAICS_Code__c>> listOfnaicscodes{get; set;}
public LIST<SelectOption> NaicsList { get ; set ;}//To collect all naics codes from naics object 
public LIST<LIST<SelectOption>> NaicsListOfList { get ; set ;}//To collect all naics codes from naics object
    
// Payment Related Fields
public LIST<SelectOption> PaymentGateways{get;set;} // To show payment gateways
public String SelectedPaymentGateway{get;set;} // To store selected payment gateway
public String CreditCardNumber{get; set;}
public String SelectedCardType{get; set;}
public String SelectedMonth{get; set;}
public String SelectedYear{get; set;}
public String CheckNumber{get; set;}
public String CVVNumber{get; set;}
public String ChargeId{get; set;}
public LIST<SelectOption> CreditCardType{get;set;}
public LIST<SelectOption> MonthsList{get;set;}
public LIST<SelectOption> YearsList{get;set;}
public Boolean ShowPaymentError{get; set;} // Represents boolean to show payment errors
public String PaymentErrorString{get; set;} // To Store the error in the payment
public Boolean HideLayout{get; set;} // Represents boolean to switch between registration pages
public String StripeSecret{get;set;} // To store Stripe Secret
public String StripeRefreshToken{get;set;} // To store Stripe Refresh Token
public String ANLoginId{get;set;} // To store Authorize .Net Login Id
public String ANTransactionKey{get;set;} // To store Authorize .Net Transaction Key
public String PayGatewayMode{get;set;} // To store pay gateway mode

//PayPal Parameters
public string ApiUserName{get;set;}
public string Apipassword{get;set;}
public string Apisignature{get;set;}
public string ApiapplicationId{get;set;}
public string Apiipaddress{get;set;}
public string paypalUrl{get;set;}
public String ActionType {get;set;}
public String PaymentType{get;set;}
public String FeesPayer{get;set;}
public String PayeeEmail{get;set;}
public String BoothLeadsEmail{get;set;}
public Boolean FundingTypeEcheck{get;set;}
public Boolean FundingTypeBalance{get;set;}
public Boolean FundingTypeCreditCard{get;set;}
public Boolean IsDisplay{get;set;}
public String APICredentialObjName{get;set;} 
public PPPayResponse PayResponse{get;set;} 
public PPResponseEnvelope RespEnvp{get;set;}
public string SuccessMessage{get;set;}
public String CommonParametersObjName{get;set;}
public string SenderEmail{get;set;} 
public string EventType{get;set;}
public boolean displayButton{get;set;}
public boolean istestmethod{get;set;}
public string Mainmessage{get;set;}
public Decimal eventadminChangedAmount{get;set;}
public string CommnetsByEventadmin{get;set;}
public MAP<id,Event_Price__c> mapItemWithPrice {get;set;}
public MAP<id,Event_Price__c> mapItemWithPriceforpkg{get;set;}
public ID EventId;

public string GNUserforbuyerfirstName{get;set;}
public string GNUserforbuyerlastName {get;set;}
public string GNUserforbuyeremail{get;set;} 


//------------------------------------------------------------------------ Variables Declaration End ------------------------------------------------------------------------------------- 

//---------------------------------------------------------------------------------- Constructor Start ----------------------------------------------------------------------------------- 

public BLN_RegistrationnewCon(){

  try{
      string eventIdasParameter = apexpages.currentpage().getparameters().get('id');
     if(eventIdasParameter !=null && eventIdasParameter !=''){
        onloadmethod(eventIdasParameter);
     }
  }catch(exception es){
  
  }  
  
//fetchNAICSCodes();
  }


public void onloadmethod(string eventIdasParameter){
HideLogin = FALSE;
 boolean isMinQanmore = false;
    ShowSecondPage = FALSE;
    TicketList = new LIST<TicketInnerClass>();
    ItemList = new List<ItemInnerClass>();
    CalcItemList = new List<ItemInnerClass>();
    RegItemList = new List<RegItemInnerClass>();
    CalcList = new List<RegItemInnerClass>();
    comextnew  = new Company_Ext__c  ();
    comext = new LIST<Company_Ext__c>();
    compdetails = new Company__c ();  
    
    RegistrationItemList = new MAP<String,LIST<ItemInnerClass>>();
    EventItems = new LIST<BLN_Item__c>();
    comp = new Company__c();
    companydetails = new Company_Ext__c();
    PromotionIdMap = new MAP<Id,Id>();
    RegTickets = new LIST<Ticket__c>();
    CheckAddress = new Company_Ext__c();
    IndUser = new GN_User__c();
    TotalAmount = 0.00; 
    DiscountAmount = 0.00; 
    DiscountedAmount = 0.00; 
    TaxAmount = 0.00;
    TotalAmountWithTaxes = 0.00;
    PromotionCount = 0;
    istestmethod = TRUE;
    HideLayout = TRUE;
    // Fetching EventId from the page URL i.e. from regular registration  
        EventId = eventIdasParameter; 
    // Fetching EventId from the cookie value i.e. from backdoor registration
  try{  
    Cookie k = ApexPages.currentPage().getCookies().get('counter'); 
    
    if(k !=null && EventId == NULL){
        EventId = k.getValue();
        HideLayout = FALSE;
    }
  }catch(exception rt){
  
  
  }
    // Code to display the menu and side bar in the event admin portal
    RegistrationLinks = new BLN_UtillDisplayLinks();
    RegistrationLinks.isregistrationPage='active';
    RegistrationLinks.isregistrationPageExpand='expand';
    RegistrationLinks.tablabel='Registration iFrame Links';
    RegistrationLinks.eventId=EventId;
    RegistrationLinks.userPermissions(userInfo.getUserId(),EventId);

    // Initializing Quick Registration BAL to perform business logic
    BLN_Quick_Registration_BAL QuickRegBAL = new BLN_Quick_Registration_BAL();
            
  string adminssionid ='';
    if(EventId != NULL){ 
        // Getting Event Details from Event DAO
        registrationEvent = QuickRegBAL.getEventDetails(EventId);   
        
        // Getting List of items selected from Item DAO  
        
        
        mapItemWithPrice = new MAP<id,Event_Price__c>();       
        List<Event_Price__c> listOfeventprices = [SELECT Event_Price__c.Item_type__r.Name,id,Active_Flag__c,BL_Fee_Amount__c,BL_Fee_Level__c,BL_Fee_Percentage__c,Item_Count__c,Item_type__c,Event__c from Event_Price__c where Event__c=:EventId ];
         for(Event_Price__c evp :listOfeventprices  ){
              if(evp.Item_type__r.Name =='Admissions'){
              adminssionid = evp.Item_type__c;
              }
              mapItemWithPrice.put(evp.Item_type__c,evp); 
         }        
         
        EventItems = QuickRegBAL.getEventItems(EventId); 
        EventDaysRemaining = date.today().daysBetween(registrationEvent.End_Date__c);   
        eventdateTodatetimeformat evedate = new eventdateTodatetimeformat();
        EventDaysRemainingDT =evedate.getConvertDateTime(registrationEvent.End_Date__c,registrationEvent.End_Time__c ); 
         
    }
    
    // Getting Registration Template from Registration Template DAO
    if(registrationEvent.Registration_Template__c != NULL){
        registrationTemplate = QuickRegBAL.getRegTempDetails(registrationEvent.Registration_Template__c);
    }else{
        List<Registration_Template__c> regtemp = [SELECT id From Registration_Template__c Where Owner.profile.Name =: 'System Administrator'];
        registrationTemplate = QuickRegBAL.getRegTempDetails(regtemp[0].id);
    }
    
    system.debug(' EVENT ITEMS '+EventItems);
    if(EventItems.size() > 0){
           
        //Fetching Display Settings
        DisplaySettings = new LIST<Reg_Setting__c>();
        BLN_DisplaySettings_BAL DisplaySettingsBAL = new BLN_DisplaySettings_BAL();
        system.debug('   EVENT ID '+RegistrationEvent.id);
        DisplaySettings = DisplaySettingsBAL.getregsettingslist(RegistrationEvent.id);
        system.debug(' DISPLAY SETTINGS '+DisplaySettings);
        for(Reg_Setting__c rs: DisplaySettings){
            if(rs.Column_Name__c == 'Time Out' && rs.Included__c == TRUE && rs.Order__c != NULL){
                SessionTime = Integer.ValueOf(rs.Order__c);
            }
        }
        
          // Caluculating fee for package
        mapItemWithPriceforpkg    = new MAP<id,Event_Price__c>();  
            for(Item_Pool__c itp : [select id,(select id,Addon_Count__c,Item_Pool_Name__c,Item_Type__r.Name,Item_Type__c from Item_Pools__r),Item_Type__c from Item_Pool__c  where Addon_Parent__c=null and Package_Flag__c='P - Package item pool' and Event__c=:EventId ]){
               decimal dfee =0.0;
                decimal dper =0.0;
                
                for(Item_Pool__c itpline :itp.Item_Pools__r ){
                  IF(itpline.Item_Type__r.Name =='Admissions'){
                      dper = dper +  (itpline.Addon_Count__c)*mapItemWithPrice.get(itpline.Item_Type__c).BL_Fee_Percentage__c ;
                        dfee = dfee + (itpline.Addon_Count__c)*mapItemWithPrice.get(itpline.Item_Type__c).BL_Fee_Amount__c;
                    }
                }
              system.debug('111111111111111 '+adminssionid );
              if(dper <=0 && dfee <=0){
                  dper  = mapItemWithPrice.get(adminssionid ).BL_Fee_Percentage__c ;
                   dfee  = mapItemWithPrice.get(adminssionid ).BL_Fee_Amount__c;
              }
              Event_Price__c eveprice = new Event_Price__c(); 
             
                eveprice.BL_Fee_Percentage__c =dper ;
                eveprice.BL_Fee_Amount__c=dfee;
             
              
            mapItemWithPriceforpkg.put(itp.id ,eveprice);     
            }             
        system.debug('WWWWWWWWWWWWWWWWWWWWWWW '+mapItemWithPriceforpkg);   
        
        
               
        // Looping through Event Items to filter them and limit maximum and minimum selection
        for(BLN_Item__c ite: EventItems){
              
        
            if((ite.Visibility__c == TRUE && ite.item_count__c >=1)){                       
                LIST<Selectoption> itemWiseCount = new LIST<Selectoption>();
                
                integer minSelection = 0;
                integer maxSelection = 0; 
                
                if(ite.max_per_order__c != null && ite.max_per_order__c != 0){
                    if( ite.Available_Tickets__c >  ite.max_per_order__c){
                        maxSelection = Integer.valueOf( ite.max_per_order__c);
                    }else{
                        maxSelection = Integer.valueOf( ite.Available_Tickets__c);
                    }
                }else{
                    maxSelection = Integer.valueOf( ite.Available_Tickets__c);
                }
                
                if(ite.min_per_order__c != null && ite.min_per_order__c != 0){
                        
                    if( ite.Available_Tickets__c >  ite.min_per_order__c){
                        minSelection = Integer.valueOf( ite.min_per_order__c);
                    }else{
                        minSelection = Integer.valueOf(ite.Available_Tickets__c);
                    }
                }else{
                    minSelection = 0;
                }
                
                if(minSelection !=0){
                    itemWiseCount.add(new Selectoption('0','0'));
                 //  isMinQanmore = true;
                  }
                
                 
                for(integer i= minSelection; i<= maxSelection ; i++ ){
                    itemWiseCount.add(new Selectoption(string.valueOf(i), string.valueOf(i) ));
                }
                
              
                //Calculating Package Fee
                Decimal FeeAmount = 0.0;
                if(ite.Item_Pool__r.Item_Type__r.Name == 'Package'){  
                            
                    //Fetching AddOnParent ItemPools
                    LIST<String> IPStrings = new LIST<String>();  
                    IPStrings.add(ite.Item_Pool__r.Id);
                    BLN_ItemPool_DAO ItemPoolDAO = new BLN_ItemPool_DAO();
                    LIST<Item_Pool__c> IPList = ItemPoolDAO.getPackageItemPools(IPStrings);
                    PackageInfo ='';
                    for(Item_Pool__c IP: IPList){
                        if(IP.Item_Type__r.BL_Fee_Amt_per_res__c!= NULL){
                           system.debug('Fee Amount For Item Type:'+ IP.Addon_Count__c * IP.Item_Type__r.BL_Fee_Amt_per_res__c);
                           FeeAmount += IP.Addon_Count__c * IP.Item_Type__r.BL_Fee_Amt_per_res__c;
                        }
                        PackageInfo += IP.Addon_Count__c + ' ' + IP.Item_Pool_Name__c + ',';
                        system.debug('Each Package Detail'+PackageInfo );
                    }
                     system.debug('Total Package Detail'+PackageInfo );
                    try{
                        PackageInfo = PackageInfo.substring(0,PackageInfo.length()-1);
                    }
                    catch(Exception e){}
                   
                }
                 system.debug('Package Fee: '+ FeeAmount);
                 if(minSelection !=null && minSelection >0){
                       
                 }else{
                 minSelection =0;
                 }
                ItemList.add(new ItemInnerClass(ite,itemWiseCount,String.valueOf(minSelection),FeeAmount,PackageInfo));   

            } 
            
        }


        //Fetching Event Tags & Registration Tabs
        BLN_Hash_Tag_BAL TagBAL = new BLN_Hash_Tag_BAL();
        LIST<Hash_Tag__c> TagList = TagBAL.getEventTags(registrationEvent.Id);

        //Fetching all Registration tabs enabled in display settings
        MAP<Id,Reg_Setting__c> TagSettingMap = new MAP<Id,Reg_Setting__c>([SELECT ID,Item__c,Table_Name__c,Column_Name__c,Order__c,Included__c FROM Reg_Setting__c WHERE Event__c=:RegistrationEvent.id AND Setting_Type__c=:'Registration Tab' ORDER BY Order__c]);
        System.debug('Tag setting Map '+TagSettingMap);
        //If registration tabs are availble to this event,
        if(TagSettingMap.values().size()>0){
            
               
          LIST<ItemInnerClass> otherList = new LIST<ItemInnerClass>();
           Integer remainingFlag=0;
            //Dividing Items into different registration tabs
           Map<BLN_Item__c,ItemInnerClass> blnitem=new Map<BLN_Item__c,ItemInnerClass>();
            for(ItemInnerClass iic: ItemList){
             for(Reg_Setting__c rs: TagSettingMap.values()){
                LIST<ItemInnerClass> ItemInnerList = new LIST<ItemInnerClass>();
                
                // Checking if the item is having any event tags at all. Enters the loop if it have any.
                             if(rs.item__c==iic.items.id)
                             {
                              
                              
                              if(RegistrationItemList.containsKey(rs.Table_Name__c)){
                                
                                    ItemInnerList =  RegistrationItemList.get(rs.Table_Name__c);
                                    ItemInnerList.add(iic);
                                    RegistrationItemList.put(rs.Table_Name__c,ItemInnerList);
                                    for(RegItemInnerClass ric: RegItemList){ 
                                        if(ric.TabLabel == rs.Table_Name__c){
                                            ric.ItemsList = ItemInnerList;
                                        }
                                    }
                                }
                                else{
                                ItemInnerList.add(iic);
                              RegistrationItemList.put(rs.Table_Name__c,ItemInnerList);
                              RegItemList.add(new RegItemInnerClass(rs.Table_Name__c,rs.Order__c,ItemInnerList));
                                   }
                              
                              
                                //if(blnitem.containskey(iic.items))
                                //blnitem.remove(iic.items);
                                 
                              }
                              else
                              {
                                 blnitem.put(iic.items,iic);
                              }
                        
               }//end if reg tab loop
               }
              integer otherflag=0;
              for(ItemInnerClass iic:blnitem.values())
              {
                  remainingFlag=0;
                 for(List<ItemInnerClass> iiclist:RegistrationItemList.values()){
                 for(ItemInnerClass innicc:iiclist){
                 if(innicc==iic)
                 remainingFlag=1; 
                }
                }
                
                if(remainingFlag==0){
                otherList.add(iic);
                otherflag=1;
                }
              }
              
              if(otherflag==1){
                  
                  RegItemList.add(new RegItemInnerClass('Other',RegistrationItemList.size()+1,otherList));
                  
                  }
                 
                 
              
             }
        // If there are no registration tabs available for the event
        else{
            RegItemList.add(new RegItemInnerClass('All',0,ItemList)); 
        }
        
       //Sort RegItemInnerclass by Order column
       RegItemInnerClass temp;
       for(integer i=1;i<RegItemList.size();i++)
       {
         for(integer j=0;j<i;j++) 
         {
             if(RegItemList[j].TabOrder>RegItemList[i].TabOrder)
             {
                  temp=RegItemList[j];
                  RegItemList[j]=RegItemList[i];
                  RegItemList[i]=temp;
             }
             
         }  
       }
        
        //Fetching Default State and Country
        countryStates();
        statesBasedOnCountry();
        
        //Getting List of payment gateways available for an event
        PaymentGateways = new LIST<SelectOption>();
         LIST<Event_Pay_Gateway__c> EventPayGateWays = new LIST<Event_Pay_Gateway__c>();
            for(Event_Pay_Gateway__c egp  :  QuickRegBAL.getEventPayGateWays(EventId)){
               if(egp.Registration_Type__c=='Online'){ 
                 EventPayGateWays.add(egp  ); 
               }
             }
        
        if(EventPayGateWays.size() > 0){
            for(Event_Pay_Gateway__c epg: EventPayGateWays){
               system.debug('Payment Gateway type: '+epg.Pay_Gateway__r.PGateway_Type__r.Name);
               if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Stripe' || epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Authorize.Net'){
                   PaymentGateways.add(new SelectOption('CreditCard','CreditCard'));
               }else if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Check'){
                  // if(TotalAmount > epg.Pay_Gateway__r.Min_amount_to_accept__c){
                       PaymentGateways.add(new SelectOption(epg.Pay_Gateway__r.PGateway_Type__r.Name,epg.Pay_Gateway__r.PGateway_Type__r.Name));    
                  // }
               }else{
                   PaymentGateways.add(new SelectOption(epg.Pay_Gateway__r.PGateway_Type__r.Name,epg.Pay_Gateway__r.PGateway_Type__r.Name));        
               }
               
               List<Pay_Gateway__c> boothleadspaygate = new List<Pay_Gateway__c>();
                boothleadspaygate = [SELECT id,Company__c,Min_amount_to_accept__c,PGateway_Type__c,PG_Email_Id__c,PG_Pass_Secret__c,PG_Signature__c,PG_User_Key__c,PP_Fee_Payer__c,PP_Payment_Type__c,Service_Fee__c from Pay_Gateway__c where Company__r.Name ='EventdexLive'];
               
               if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'PayPal'){
                   PaymentType = epg.Pay_Gateway__r.PP_Payment_Type__c;
                   feesPayer = epg.Pay_Gateway__r.PP_Fee_Payer__c;
                   PayeeEmail = epg.Pay_Gateway__r.PG_Email_Id__c;
                   if(boothleadspaygate.size()>0){
                    for(Pay_Gateway__c pgat : boothleadspaygate){
                       if(pgat.PGateway_Type__r.Name =='PayPal'){
                        BoothLeadsEmail = pgat.PG_Email_Id__c;
                        }
                     }
                   }
                   system.debug('AAAAAAAA BoothLeadsEmail '+BoothLeadsEmail ); 
                   PayGatewayMode = 'PayPal';
               }
               else if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Stripe'){
                   StripeRefreshToken = epg.Pay_Gateway__r.PG_Pass_Secret__c;
                   if(boothleadspaygate.size()>0){
                    //StripeSecret = epg.Pay_Gateway__r.PGateway_Type__r.BoothLeads_Stripe_Secret__c;
                      StripeSecret = boothleadspaygate[0].PG_Pass_Secret__c;
                   }
                   
                   PayGatewayMode = 'Stripe';
               }
               else if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Authorize.Net'){
                   ANLoginId = epg.Pay_Gateway__r.PG_User_Key__c;
                   ANTransactionKey = epg.Pay_Gateway__r.PG_Signature__c;
                   PayGatewayMode = 'Authorize .Net';
               }
               else if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'TrustCommerce'){
                   ANLoginId = epg.Pay_Gateway__r.PG_User_Key__c;
                   ANTransactionKey = epg.Pay_Gateway__r.PG_Signature__c;
                   PayGatewayMode = 'TrustCommerce';
               }
               else if(epg.Pay_Gateway__r.PGateway_Type__r.Name == 'Check'){
                   PayGatewayMode = 'Check';
               }
            }
        }
          
        //Fetching CheckAddress
        BLN_UCRole_DAO UCRDAO = new BLN_UCRole_DAO();
        BLN_Company_DAO ComDAO = new BLN_Company_DAO();
        
        
       // UC_Role__c EURole = new UC_Role__c ();
        try{
          // EURole  = UCRDAO.fetchEventAdmin(registrationEvent.Id);
        }catch(exception er){}
        
        if(registrationEvent.organizer_id__c!= NULL){
            Company__c CheckCompany = ComDAO.queryCompany(registrationEvent.organizer_id__c);   
            for(Company_Ext__c ce: CheckCompany.Company_Ext__r){
                CheckAddress = ce;
            }
        }
        
        
        //Getting Stripe Related Information
        MonthsList= new LIST<SelectOption>();
        YearsList= new LIST<SelectOption>();
        CreditCardType= new LIST<SelectOption>();
    
        LIST<String> monthstring = new LIST<String>{'01','02','03','04','05','06','07','08','09','10','11','12'};
        LIST<String> yearstring = new LIST<String>{'2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024','2025','2026','2027','2028','2029','2030'};
        LIST<String> cardtypestring = new LIST<String>{'Visa','MasterCard','American Express','Discover'};
        SelectedYear= String.valueOf(system.today().year());
        YearsList.add(new SelectOption(SelectedYear,SelectedYear));
        String y=SelectedYear;
        for(integer l=0; l<= 15; l++){
            y = String.valueof(integer.valueOf(y)+1); 
            YearsList.add(new SelectOption(y,y));           
        }
        
        for(String m: monthstring){
            MonthsList.add(new SelectOption(m,m));
        }
    
        for(String c: cardtypestring){
            CreditCardType.add(new SelectOption(c,c));
        }
    }
    system.debug('Onload checkerrrrrrrrrrrrrrrrrrrrrr '+isMinQanmore );
  
}


//------------------------------------------------------------------------------------ Constructor End ---------------------------------------------------------------------------------------- 

// -------------------------------------------------------------------------------- Reg Item Inner Class Start --------------------------------------------------------------------------------
public class RegItemInnerClass{

    public String TabLabel{get;set;}
    public Decimal TabOrder{get;set;}
    public LIST<ItemInnerClass> ItemsList{get;set;} 
    
    public RegItemInnerClass(String TabLabel1,Decimal TabOrder1,LIST<ItemInnerClass> ItemsList1){
        
        TabLabel = TabLabel1;
        TabOrder = TabOrder1;
        ItemsList = ItemsList1;
    }
}
// -------------------------------------------------------------------------------- Reg Item Inner Class End ----------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------- Item Inner Class Start ---------------------------------------------------------------------------------


// This Inner Class is used for displaying filtered items
    public class ItemInnerClass{
    
        public BLN_Item__c items{get; set;}
        public LIST<Selectoption> itemSelectOptions{get; set;}
        public String selectedItemQuantity{get; set;}
        public Decimal PackageFee{get;set;}
        public String PackageInfo{get; set;}
        
        public ItemInnerClass(BLN_Item__c ite, LIST<Selectoption> itemWiseOptions, String qty,Decimal PkgFee,String PkgInfo){
        
            items = new BLN_Item__c();
            itemSelectOptions = new LIST<Selectoption>();
            //selectedItemQuantity = '0';
            PackageFee = PkgFee;
            PackageInfo = PkgInfo;
            
            items = ite;
            itemSelectOptions = itemWiseOptions;
            selectedItemQuantity = qty;
            PackageFee = PkgFee;
            PackageInfo = PkgInfo;
        }   
    }
// ----------------------------------------------------------------------------------- Item Inner Class End ------------------------------------------------------------------------------------ 
public Set<Id> selectedTicketIds{get;set;} 
public MAP<id,integer> mapTicWithQuan{get;set;}
public MAP<id,integer> mapItemWithQuan{get;set;}
public MAP<id,ItemInnerClass> napIdwithObj{get;set;}
public decimal eventdexamount {get;set;}
public boolean disablepromobutton{get;set;}
public MAP<id,decimal> mapitemWithFee {get;set;}
public MAP<id,decimal> mapitemWithDiscount{get;set;}
// ------------------------------------------------------------------------------- Apply Promo Code Method Start ---------------------------------------------------------------------------------- 
// This method is fired when user clicks on apply promo code / when user picks quantity for an item
    public PageReference applyPromocode(){
    
    disablepromobutton = false;
    mapitemWithFee = new MAP<id,decimal>();
    System.debug('CalcItemList '+CalcItemList);
    System.debug('QQQQQQQQQQQQQQ   '+CalcItemList.size());
    napIdwithObj = new MAP<id,ItemInnerClass>();
    
    System.debug('***'+itqnty+';'+itpoolid+';'+itlabel+'itoldqnty '+itoldqnty);
    decimal TotalamountBefore =0.0;
    TotalamountBefore = TotalAmount-DiscountAmount;
    System.debug('AAAAAAAAAAAAAAAAAAAAA '+RegItemList.size());
    mapItemWithQuan = new MAP<id,integer>();
    for(Integer i=0;i<RegItemList.size();i++){
       if(RegItemList[i].TabLabel==itlabel){
        if(RegItemList[i].ItemsList.size()>0){ // iterate selected tickets
            for(Integer j=0;j<RegItemList[i].ItemsList.size();j++){
              if(RegItemList[i].ItemsList[j].items.id==itpoolid){ // Previous itpoolid has it pool id i(phani) changed it to item id if error comes change back to itempool id 
               integer flag=0;
               system.debug('SSSSSSSSSSSSS WWWWWWWWWWW '+CalcItemList.size());
               for(integer k=0;k<CalcItemList.size();k++){
                 if(CalcItemList[k].items.id==itpoolid){
                  flag=1;
                  system.debug('SSSSSSSSSSSSS 11111'+CalcItemList[k].selectedItemQuantity);
                 CalcItemList[k].selectedItemQuantity=String.valueOf(Integer.valueOf(CalcItemList[k].selectedItemQuantity)+Integer.valueOf(itqnty)-Integer.valueOf(itoldqnty));
                 //CalcItemList[k].selectedItemQuantity=String.valueOf(Integer.valueOf(CalcItemList[k].selectedItemQuantity)+Integer.valueOf(itqnty)-Integer.valueOf(itoldqnty))
                  system.debug('Selected Quantity '+CalcItemList[k].selectedItemQuantity);
                 break;
                 } 
              }
              if(flag==0){
                RegItemList[i].ItemsList[j].selectedItemQuantity=itqnty;
                CalcItemList.add(RegItemList[i].ItemsList[j]);
              }
              }
              
            }
       }// checking selected list End      
            
            }
            
         }   
         System.debug('CalcItemList '+CalcItemList);
        //SET<id> ticketIdsForActQuan =new set<id>();
        TotalAmount = 0.00; 
        DiscountAmount = 0.00; 
        DiscountedAmount = 0.00;
        eventadminChangedAmount =0.00; 
        FeeAmount = 0.00;
        TaxAmount = 0.00;
        TotalAmountwithTaxes = 0.00;
        eventdexamount = 0.0;
        // Intialising Promo code BAL
        BLN_PromoCode_BAL PromotionBAL = new BLN_PromoCode_BAL();
        mapTicWithQuan = new MAP<id,integer>();
        selectedTicketIds = new Set<id>();
          
           
            
          for(ItemInnerClass iic: CalcItemList){
              integer ih = 0;
               if(null != iic.selectedItemQuantity){
                 ih = Integer.valueOf(iic.selectedItemQuantity);
              }
             mapItemWithQuan.put(iic.items.id,ih);
             napIdwithObj.put(iic.items.id,iic);
           }  
            
          decimal feecalind =0;
           for(ItemInnerClass iic: CalcItemList){
            System.debug('iic item'+iic);
            System.debug('iic.selectedItemQuantity '+iic.selectedItemQuantity);
               if(iic.selectedItemQuantity != null){
                 if(Integer.valueOf(iic.selectedItemQuantity) >=1){
                     feecalind =0;
                       selectedTicketIds.add(iic.items.id);
                       mapTicWithQuan.put(iic.items.id,Integer.valueOf(iic.selectedItemQuantity));
                       TotalAmount += Integer.ValueOf(iic.selectedItemQuantity) * (iic.items.price__c);    
                                            
                        if(iic.items.Payment__c != 'Free' && iic.items.price__c > 0 && (iic.items.service_fee__c == 'Add Booth Leads fee on top of the total ticket price')){
                            if(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Amount__c>0){
                               FeeAmount+=Integer.valueOf(iic.selectedItemQuantity)*( mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Amount__c);
                               feecalind += Integer.valueOf(iic.selectedItemQuantity)*( mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Amount__c);
                            }else{
                               if(iic.items.Item_Type__r.Name=='Package'){
                                   FeeAmount+=Integer.valueOf(iic.selectedItemQuantity)*( mapItemWithPriceforpkg.get(iic.items.Item_Pool__c).BL_Fee_Amount__c);
                                   feecalind += Integer.valueOf(iic.selectedItemQuantity)*( mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Amount__c);
                                }
                            }
                            if(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Percentage__c > 0){
                               FeeAmount+=  Integer.valueOf(iic.selectedItemQuantity)*(iic.items.price__c*(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Percentage__c/100));
                               feecalind +=  Integer.valueOf(iic.selectedItemQuantity)*(iic.items.price__c*(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Percentage__c/100));
                                
                            }else{
                               if(iic.items.Item_Type__r.Name=='Package'){
                                    FeeAmount+=  Integer.valueOf(iic.selectedItemQuantity)*(iic.items.price__c*(mapItemWithPriceforpkg.get(iic.items.Item_Pool__c).BL_Fee_Percentage__c/100));
                                    feecalind +=Integer.valueOf(iic.selectedItemQuantity)*(iic.items.price__c*(mapItemWithPriceforpkg.get(iic.items.Item_Pool__c).BL_Fee_Percentage__c/100));
                                      
                             } 
                           }
                            eventdexamount+=FeeAmount;
                         }else if(iic.items.price__c>0 && iic.items.service_fee__c =='Include the Booth Leads fee in to the total ticket price'){
                           if(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Amount__c>0){  
                               eventdexamount+=Integer.valueOf(iic.selectedItemQuantity)*mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Amount__c;
                              }else{
                               if(iic.items.Item_Type__r.Name=='Package'){
                                   eventdexamount+=Integer.valueOf(iic.selectedItemQuantity)*( mapItemWithPriceforpkg.get(iic.items.Item_Pool__c).BL_Fee_Amount__c);
                               }
                            }
                               if(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Percentage__c > 0){
                               eventdexamount+=Integer.valueOf(iic.selectedItemQuantity)*(iic.items.price__c*(mapItemWithPrice.get(iic.items.Item_Type__r.id).BL_Fee_Percentage__c/100));
                              } else{
                               if(iic.items.Item_Type__r.Name=='Package'){
                                    eventdexamount+=  Integer.valueOf(iic.selectedItemQuantity)*(iic.items.price__c*(mapItemWithPriceforpkg.get(iic.items.Item_Pool__c).BL_Fee_Percentage__c/100));
                         
                               } 
                            }
                         }
                         mapitemWithFee.put(iic.items.id,feecalind);
                         
                       }
                    }
                 }
                    TotalAmount+= FeeAmount;
            
                     if(registrationEvent.Accept_Tax_Rate__c == TRUE && registrationEvent.Tax_Rate__c != NULL){
                            TaxAmount = TotalAmount * (registrationEvent.Tax_Rate__c/100);
                            TotalAmountwithTaxes = TotalAmount + TaxAmount;
                            TaxAmount = TaxAmount.setscale(2);
                            TotalAmountwithTaxes = TotalAmountwithTaxes.setscale(2);
                       } 
                       TotalAmount = TotalAmount.setscale(2);
                       DiscountAmount = DiscountAmount.setscale(2);
                       DiscountedAmount = DiscountedAmount.setscale(2);
            
            
        
        system.debug('Fee Values  '+FeeAmount +' Total Amount '+TotalAmount );
        itqnty= '0';itlabel='';itoldqnty='0';
        //System.debug('***'+itqnty+';'+itpoolid+';'+itlabel+'itoldqnty '+itoldqnty);
        return null;
    }
// -------------------------------------------------------------------------------- Apply Promo Code Method End ----------------------------------------------------------------------------------- 




public string errorpromo{get;set;}
public Promotion__c PromotionOb{get;set;}

public pagereference applyPromocodenew(){
    system.debug('PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPpp '+promocode);
 Decimal DiscountAmountafpromo =0.0;
 Decimal dicountedamtdum = 0.0;
 mapitemWithDiscount = new MAP<id,decimal>();
 PromotionOb = new Promotion__c();
   BLN_PromoCode_BAL PromotionBAL = new BLN_PromoCode_BAL();
          // Checking Promo Code details in Promotions table
            List<Promotion__c> Promotion = new List<Promotion__c>();
          try{ 
            Promotion  = PromotionBAL.getPromotionDetails(registrationEvent.Id,promocode);
            system.debug('Promotion Details are: '+Promotion);
            if(Promotion.size()>0){
                PromotionOb = Promotion[0];
            }
           }catch(exception ed){
              return null;
           } 
             errorpromo ='';
              if(Promotion==null ){
                 return null;
              }
             
             //Checking validate promotion 
              for(Promotion__c  pro : Promotion){
              
                if((pro.Exp_TimeStamp__c).date().daysBetween(system.now().date())>0){
                  errorpromo = 'Promo code expired';
                  system.debug('QQQQQQQ '+(pro.Exp_TimeStamp__c).format() +'AAAAAAAAAA '+system.now().format());
                  return null;
                }else if(pro.Status__c != 'Active and Enable for online registrations'){
                   errorpromo = 'Promo code is not for portal users';
                   return null;
                }
              }
           
           
           
            // If promocode is Spend More Save More
             
              for(Promotion__c  prosp : Promotion){
                 if(Promotion!= NULL && prosp.T_Used_Count__c < prosp.T_Max_Count__c){
                      if(prosp.Promotion_Type__c =='Spend More Save More'){
                         if(TotalAmount >=prosp.Condition_Min_No__c && TotalAmount<= prosp.Condition_Max_No__c){
                           if(prosp.Discount_Type__c=='Percent'){
                               dicountedamtdum=TotalAmount*((prosp.Discount_Value__c)/100);
                               TotalAmount = (TotalAmount-dicountedamtdum).setscale(2); 
                               DiscountAmount = TotalAmount;  
                               DiscountedAmount =dicountedamtdum.setscale(2);  
                          }else{
                               dicountedamtdum=prosp.Discount_Value__c;
                               TotalAmount = (TotalAmount-dicountedamtdum).setscale(2); 
                               DiscountAmount = TotalAmount; 
                               DiscountedAmount =dicountedamtdum;
                          }
                             TaxAmount =0.0;
                             TaxAmount = (TotalAmount * (registrationEvent.Tax_Rate__c/100)).setscale(2);
                             TotalAmountwithTaxes =0.0;
                             TotalAmountwithTaxes = (TotalAmount + TaxAmount).setscale(2);
                          
                      }
                       return null;  
                   }   
                 }
                 
              }
           
           system.debug('SSSSSSSSSSSSSSSSSSSs '+Promotion[0].T_Used_Count__c+'EEEEEEEEEEEEE '+Promotion[0].T_Max_Count__c);
           
            // Checking Item Promotions details in Item Promotions table
            MAP<Id,Item_Promotion__c> ItemMap = new MAP<Id,Item_Promotion__c >();
              string promocodestring= '';
              
            if(Promotion!= NULL && Promotion[0].T_Used_Count__c < Promotion[0].T_Max_Count__c){
                LIST<Item_Promotion__c> ItemPromotions = PromotionBAL.getItemPromotions(Promotion[0].Id);
                system.debug('Item Promotions List: '+ItemPromotions);
             if(ItemPromotions.size()>0){
                    for(Item_Promotion__c IP: ItemPromotions){
                       if(IP.Buy_Item__c!=null){
                           ItemMap.put(IP.Buy_Item__c,IP);
                       } 
                       
                       if(IP.Free_Item__c!=null){
                        ItemMap.put(IP.Free_Item__c,IP);
                       }
                    }
                  }
               }
        
         MAP<id,ItemInnerClass > mapselQuaninpromo = new MAP<id,ItemInnerClass >();
         
         if(promocode!='' && promocode!=null){
             for(ItemInnerClass iic: CalcItemList){
              if(iic.selectedItemQuantity != null){
               if(Integer.valueOf(iic.selectedItemQuantity) >=1){
                     if(ItemMap.keyset().contains(iic.items.id)){
                        mapselQuaninpromo.put(iic.items.id,iic);
                     }
                 }
               }
            }
         }
        system.debug('PPPPPPPPPPPPPPPP '+ItemMap.size());
       
        
        system.debug('PPPPPPPPPPPPPPPP '+mapselQuaninpromo.size());
         boolean boo = true; 
        
       if(Promotion[0].Promotion_Type__c !='Basic Promo codes' ){ 
         for(id itid : ItemMap.keySet()){
           if(mapselQuaninpromo.keyset().contains(itid)){      
            ItemInnerClass iic3 = mapselQuaninpromo.get(itid);
               if(ItemMap.get(itid).Free_Item__c!= null){
                 system.debug('$$$$$$$$$$$$ '+iic3.selectedItemQuantity + 'Z&&&&&&&&&& '+ItemMap.get(itid).Free_Item_Quantity__c);
                if(integer.valueOf(iic3.selectedItemQuantity) < ItemMap.get(itid).Free_Item_Quantity__c){
                    boo = false;
                   break;
                }
              }else{
                 system.debug('############ '+iic3.selectedItemQuantity + '@@@@@@@@@@@@@ '+ItemMap.get(itid).Buy_Item_Quantity__c);
                if(integer.valueOf(iic3.selectedItemQuantity) < ItemMap.get(itid).Buy_Item_Quantity__c ){
                   boo = false;
                   break;
                  }
              
              }
            }else{
                 boo = false;
                   break;
            
            }  
           } 
        } 
        
         
       if(boo){
           for(string itidfinal : mapselQuaninpromo.keySet()){
              ItemInnerClass iic1 = mapselQuaninpromo.get(itidfinal);
              
               system.debug('############ '+integer.valueOf(iic1.selectedItemQuantity) + '@@@@@@@@@@@@@ '+ ItemMap.get(itidfinal).Buy_Item_Quantity__c+'<<<<<<<<<<< '+ItemMap.get(itidfinal).Free_Item_Quantity__c);
              
                     if((integer.valueOf(iic1.selectedItemQuantity) >= ItemMap.get(itidfinal).Buy_Item_Quantity__c) || (Promotion[0].Promotion_Type__c !='Basic Promo codes' && (integer.valueOf(iic1.selectedItemQuantity) >= ItemMap.get(itidfinal).Free_Item_Quantity__c))){
                     Decimal discountindval = 0;
                      if(ItemMap.get(itidfinal).Item_Discount_Type__c =='Percent'){
                        if(ItemMap.get(itidfinal).Free_Item__c!= null ){
                           dicountedamtdum += ((ItemMap.get(iic1.items.id).Free_Item_Quantity__c *(iic1.items.price__c))*(ItemMap.get(iic1.items.id).Item_Discount_Value__c/100));
                           discountindval+= ((ItemMap.get(iic1.items.id).Free_Item_Quantity__c *(iic1.items.price__c))*(ItemMap.get(iic1.items.id).Item_Discount_Value__c/100));
                         }else{
                          dicountedamtdum += ((Integer.valueOf(iic1.selectedItemQuantity)*(iic1.items.price__c))*(ItemMap.get(iic1.items.id).Item_Discount_Value__c/100));
                          discountindval+=((Integer.valueOf(iic1.selectedItemQuantity)*(iic1.items.price__c))*(ItemMap.get(iic1.items.id).Item_Discount_Value__c/100));
                        } 
                         disablepromobutton =true;
                      }else if(ItemMap.get(itidfinal).Item_Discount_Type__c =='Amount'){
                         dicountedamtdum +=  ItemMap.get(iic1.items.id).Item_Discount_Value__c;
                         discountindval+=  ItemMap.get(iic1.items.id).Item_Discount_Value__c;
                         disablepromobutton =true;
                      }
                     mapitemWithDiscount.put(iic1.items.id,discountindval); 
                      
              }
          }  
                TotalAmount = (TotalAmount-dicountedamtdum).setscale(2);
                DiscountAmount = (TotalAmount-dicountedamtdum).setscale(2);
                DiscountedAmount = dicountedamtdum.setscale(2);
                TaxAmount =0.0;
                 if(null != registrationEvent.Tax_Rate__c){
                    TaxAmount = (TotalAmount * (registrationEvent.Tax_Rate__c/100)).setscale(2);
                 }
                
                
                TotalAmountwithTaxes =0.0;
                TotalAmountwithTaxes = (TotalAmount + TaxAmount).setscale(2); 
            }
           
          return null;  
     }





  
public List<Reg_Setting__c> RegistrationSettingsForBuyer{get;set;}
public  List<Reg_Setting__c> settingsForbuyer{get;set;} //To display buyer settings
public  SET<string> groupNames; // To check group is there or not      
public GN_user__c GNUserforbuyer {get;set;}
//public user_Ext__c GNUserextforbuyer {get;set;}
public Company__c GNbuyerCompany {get;set;}
public Company_Ext__c GNbuyerCompanyDetails{get;set;}
public Pay_Address__c BillingAddressForbuyer{get;set;}


  
  
   
   
//----------------------------------------------------------------------------------- Order Now Method Start ----------------------------------------------------------------------------------- 
// This method is fired when user clicks on Order Now button

    public void orderNow(){
        isDt=false;
        ShowSecondPage = TRUE;
        HideLogin = FALSE;
        integer i = 1;
        BLN_Quick_Registration_BAL QuickRegBAL = new BLN_Quick_Registration_BAL();
        PayAddress = new Pay_Address__c();
        PayAddress.BLN_Country__c= selectedCountry;
        system.debug('Item list Size: '+ItemList.size());

        //For fetching Registration & Survey settings
        fetchSettings();
        SET<id> ticketsWithBuyerinfo = new SET<id>();
        
        Integer ItemQuantity;
        RegistrationSettingsForBuyer = new List<Reg_Setting__c>();
        List<Ticket__c> abandonedList = new List<Ticket__c>();
        
        // Iterating through items seleceted
        for(ItemInnerClass iic: ItemList){
           
           system.debug('Item Id: ' + iic.items.id+'Item price: '+iic.items.price__c);
           system.debug('Selected Quantity: ' + iic.selectedItemQuantity);
           
           
           if(iic.selectedItemQuantity != null){
               if(Integer.valueOf(iic.selectedItemQuantity) >=1 ){ 
                   BLN_Item__c BLNItem = new BLN_Item__c();
                   BLNItem = iic.items;
                   if(iic.items.Ticket_Settings__c == 'Collect info from Buyers only'){
                     if(iic.items.Item_Type__r.Name != 'Package'){
                       RegTickets = QuickRegBAL.getTicketDetail(iic.items,Integer.valueOf(iic.selectedItemQuantity));
                      }else{
                         iic.items.Ticket_Settings__c = 'Collect info from All Attendees';
                         RegTickets = QuickRegBAL.getTicketDetail(iic.items, Integer.valueOf(iic.selectedItemQuantity));
                      }
                       ItemQuantity = Integer.valueOf(iic.selectedItemQuantity);
                       RegistrationSettingsForBuyer.addAll(RegSettingsMap.get(iic.items.id));
                         
                   }
                    else if(iic.items.Ticket_Settings__c == 'Collect info from All Attendees'){
                       RegTickets = QuickRegBAL.getTicketDetail(iic.items, Integer.valueOf(iic.selectedItemQuantity));    
                       system.debug('Fetched Tickets:'+RegTickets);
                       ItemQuantity = 1;
                   }
                    
                   for(Ticket__c t: RegTickets){
                      t.Ticket_Status__c='Abandoned';
                      abandonedList.add(t);
                      
                       
                      if((t.Item_Pool__r.Ticket_Settings__c == 'Collect info from All Attendees' && t.Item_Type__r.name == 'Package' ) || (t.Item__r.Ticket_Settings__c == 'Collect info from All Attendees' && t.Item_Type__r.name != 'Package')){
                        if(t.Parent_ID__c==null){
                          TicketList.add(new TicketInnerClass(t,i++,new GN_User__c(),ItemQuantity,BLNItem,RegSettingsMap,QuestionsMap,SelectedCountry,true));
                         }else{
                            TicketList.add(new TicketInnerClass(t,i++,new GN_User__c(),ItemQuantity,BLNItem,RegSettingsMap,QuestionsMap,SelectedCountry,false));
                         }
                        
                      }else{
                         if(t.Item_Pool__r.Ticket_Settings__c != 'Collect info from All Attendees' && t.Item_Type__r.name != 'Package' && t.Parent_ID__c!=null){  
                            boolean tcvalueQuestions = true;
                            if(ticketsWithBuyerinfo.contains(iic.items.id)){
                                 QuestionsMap = new MAP<id,LIST<Question__c>>();
                                 tcvalueQuestions = false;
                               }
                              ticketsWithBuyerinfo.add(t.Item__r.id);
                              TicketList.add(new TicketInnerClass(t,0,new GN_User__c(),ItemQuantity,BLNItem,RegSettingsMap,QuestionsMap,SelectedCountry,tcvalueQuestions));
                          
                           }else{
                             system.debug('9999999999999 '+t);
                             TicketList.add(new TicketInnerClass(t,0,new GN_User__c(),ItemQuantity,BLNItem,RegSettingsMap,QuestionsMap,SelectedCountry,true));
                          }
                       }
                   }
               }
           }
        }
        
        
        DataBase.update(abandonedList,false);
        
        
        
        
      system.debug('TicketList Tlist '+TicketList.size());  
      settingsForbuyer = new List<Reg_Setting__c>(); 
      groupNames = new SET<string>(); 
      GNUserforbuyer = new GN_user__c();
      GNbuyerCompany = new Company__c();
      GNbuyerCompanyDetails= new Company_Ext__c();
      
      //GNUserextforbuyer = new user_Ext__c ();
      BillingAddressForbuyer = new Pay_Address__c();
         
      SET<string>   regstable = new SET<string>(); 
      SET<string>   regscolumn = new SET<string>();
    // Written By Phani, This is for summarise the settings for buyer    
        for(Reg_Setting__c regBuyer :RegistrationSettingsForBuyer){
         Reg_Setting__c regSet = new Reg_Setting__c();
          if(regstable.contains(regBuyer.Table_Name__c) && regscolumn.contains(regBuyer.Column_Name__c)){
            
          }else{
               system.debug('XXXXXXXXXXXXXXXX '+regBuyer);
                regSet.Included__c = regBuyer.Included__c;
                regSet.Required__c = regBuyer.Required__c;
                regSet.Label_Name__c= regBuyer.Label_Name__c; 
                 regSet.Group_Name__c = regBuyer.Group_Name__c;
                 regSet.Table_Name__c = regBuyer.Table_Name__c;
                 regSet.Column_Name__c =regBuyer.Column_Name__c;
                 regstable.add(regSet.Table_Name__c); regscolumn.add(regSet.Column_Name__c);
          }
           
           if(regSet.Included__c!=false || regSet.Required__c!=false){ 
           
               groupNames.add(regBuyer.Group_Name__c);
                settingsForbuyer.add(regSet);
            }
        }
        
        //Fetching Event Level Survey Questions
        UserEventAnswer = new LIST<UserAnswerInnerClass>();
        LIST<SelectOption> Answers;
        
        system.debug('Event Level Questions'+EventQuestions);
        
        
        for(Question__c q: EventQuestions){
            Boolean isRequired;
            Answers = new LIST<SelectOption>();
            system.debug('UUUUUUUUUUU '+q.Answer_Type__c);
            if(q.Answer_Type__c=='Choose from a list' || q.Answer_Type__c=='Single Selection' || q.Answer_Type__c=='Checkboxes' || q.Answer_Type__c=='Scale'){
                for(Answer__c a: q.Answers__r){
                    Answers.add(new SelectOption(a.id,a.Answer_Text__c));
                }
            }
            for(Item_Question__c iq: q.Item_Question__r){
                if(iq.isRequired__c == TRUE){
                    isRequired = TRUE;
                }
            }
            UserEventAnswer.add(new UserAnswerInnerClass(q,q.Answers__r,Answers,isRequired));        
        }
        //fetching NAICS code for multiple tickets
        fetchNAICSCodes();
    }

//----------------------------------------------------------------------------------- Order Now Method End -------------------------------------------------------------------------------------- 


// ----------------------------------------------------------------------------------- Ticket Inner Class Start -------------------------------------------------------------------------------- 
// This Inner Class is used for Showing Input forms based on item selection

    public class TicketInnerClass{
    
        public Integer OrderNo{get;set;}
        public Ticket__c Ticket{get;set;}
        public GN_User__c EachUser{get;set;}
        //public User_Ext__c EachUserExt{get;set;}
        public Company__c EachCompany{get;set;}
        public Company_ext__c EachCompanyExt{get;set;}
        public Pay_Address__c BillingAddress{get;set;}
        public Integer selectedQuantity{get;set;}
        public BLN_Item__c BLNItem{get;set;}
        public MAP<Id,LIST<Reg_Setting__c>> RegSettingMap{get;set;} // MAP containing Registration Settings i.e. Key as Item Id and Values are List of Registration Settings
        public MAP<Id,LIST<Question__c>> QuestionMap{get;set;} // MAP containing Survey Questions i.e. Key as Item Id and Values are List of Questions
        public LIST<UserAnswerInnerClass> UserAnswer{get;set;} // Inner Class Instance for Item Survey Questions & Answers
         public string selectedCompnay{get;set;}
       public boolean surveys{get;set;}

         public TicketInnerClass(){
            EachUser = new GN_User__c();
            //EachUserExt = new User_Ext__c();
            EachCompanyExt = new Company_ext__c();
            BillingAddress = new Pay_Address__c();
         }


        public TicketInnerClass(Ticket__c Tkt, Integer ONo, GN_User__c U,Integer sQuantity,BLN_Item__c Item,MAP<Id,LIST<Reg_Setting__c>> RSMap,MAP<Id,LIST<Question__c>> QMap,String selectedCountry,boolean surveys){
           
            Ticket = Tkt;
            OrderNo = ONo;
            EachUser = new GN_User__c();
           // EachUserExt = new User_Ext__c();
           // EachUserExt.Country__c = selectedCountry;
            EachCompany = new Company__c();
            EachCompanyExt = new Company_ext__c();
            EachCompanyExt.BLN_Business_Country__c = selectedCountry;
            BillingAddress = new Pay_Address__c();
            BillingAddress.BLN_Country__c = selectedCountry;
            selectedQuantity = sQuantity;
            BLNItem = Item;
            RegSettingMap = RSMap;
            QuestionMap = QMap;
            this.surveys = surveys;
            UserAnswer = new LIST<UserAnswerInnerClass>();
            
            LIST<SelectOption> AnswerOptions;
            try{
            if(surveys){
            for(Question__c q: QuestionMap.get(BLNItem.Id)){
                Boolean isRequired;
                AnswerOptions = new LIST<SelectOption>();
                if(q.Answer_Type__c=='Choose from a list' || q.Answer_Type__c=='Multiple choice' || q.Answer_Type__c=='Checkboxes' || q.Answer_Type__c=='Scale'){
                    for(Answer__c a: q.Answers__r){
                        AnswerOptions.add(new SelectOption(a.id,a.Answer_Text__c));
                    }
                }
                for(Item_Question__c iq: q.Item_Question__r){
                    if(iq.Item__r.Id == BLNItem.Id && iq.isRequired__c == TRUE){
                        isRequired = TRUE;
                    }
                }
                UserAnswer.add(new UserAnswerInnerClass(q,q.Answers__r,AnswerOptions,isRequired));        
              }
            }
         }catch(exception e){}   
            Ticket = Tkt;
            OrderNo = ONo;
            EachUser = U;
           // EachUserExt = new User_Ext__c();
           // EachUserExt.Country__c = selectedCountry;
            EachCompany = new Company__c();
            EachCompanyExt = new Company_ext__c();
            EachCompanyExt.BLN_Business_Country__c = selectedCountry;
            BillingAddress = new Pay_Address__c();
            BillingAddress.BLN_Country__c = selectedCountry;
            selectedQuantity = sQuantity;
            BLNItem = Item;
            RegSettingMap = RSMap;
            QuestionMap = QMap;
            UserAnswer = new LIST<UserAnswerInnerClass>();
            LIST<SelectOption> AnswerOptions1;
            
          try{  
            if(surveys){
            for(Question__c q: QuestionMap.get(BLNItem.Id)){
                Boolean isRequired;
                AnswerOptions1 = new LIST<SelectOption>();
                if(q.Answer_Type__c=='Choose from a list' || q.Answer_Type__c=='Single Selection' || q.Answer_Type__c=='Checkboxes' || q.Answer_Type__c=='Scale'){
                    for(Answer__c a: q.Answers__r){
                        AnswerOptions1.add(new SelectOption(a.id,a.Answer_Text__c));
                    }
                }
                for(Item_Question__c iq: q.Item_Question__r){
                    if(iq.Item__r.Id == BLNItem.Id && iq.isRequired__c == TRUE){
                        isRequired = TRUE;
                    }
                }
                UserAnswer.add(new UserAnswerInnerClass(q,q.Answers__r,AnswerOptions1,isRequired));        
             }
            }
          }catch(exception r){}
        }
    }
// ----------------------------------------------------------------------------------- Ticket Inner Class End ---------------------------------------------------------------------------------- 

// ----------------------------------------------------------------------------------- Survey Questions Inner Class Start ----------------------------------------------------------------------
//This inner class is for showing survey questions along with tickets

global class UserAnswerInnerClass{
    public Question__c Question{get;set;}
    public LIST<Answer__c> ItemAnswer{get;set;}
    public LIST<SelectOption> Answers{get;set;}
    public Boolean isRequired{get;set;}
    public String SelectedAnswer{get;set;}
    
    public String[] SelectedAnswerCheck = new String[]{};
    public String[] getSelectedAnswerCheck() {
        return SelectedAnswerCheck;
    }
    public void setSelectedAnswerCheck(String[] SelectedAnswerCheck) {
        this.SelectedAnswerCheck = SelectedAnswerCheck;
    }
    
    public UserAnswerInnerClass(Question__c Ques,LIST<Answer__c> IAnswer,LIST<SelectOption> Ans,Boolean RequiredBool){
        Question = Ques; 
        ItemAnswer = IAnswer; 
        Answers = Ans;  
        isRequired = RequiredBool;  
    }
}
// ----------------------------------------------------------------------------------- Survey Questions Inner Class End ----------------------------------------------------------------------

public string encodedCipherText{get;set;}
public string eventidAfterEncoding{get;set;}
//------------------------------------------------------------------------------- Validating Payment Method Start -------------------------------------------------------------------------------
    public pagereference validatePayment(){
         system.debug('ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ   ');
        ChargeId ='';
        
        pagereference pg;

        Decimal TotalAmountDue;
        if(registrationEvent.Accept_Tax_Rate__c == TRUE && registrationEvent.Tax_Rate__c != NULL){
            TotalAmountDue = TotalAmountwithTaxes;
        }
        else{
            TotalAmountDue = TotalAmount;
        }
        
        
        if(TotalAmount <= 0){
             pg = completeRegistration();
            return pg;
        }
        
        system.debug('Stripe Refresh Token '+StripeRefreshToken );
        
        // Stripe Payment
        if(SelectedPaymentGateway == 'CreditCard' && StripeRefreshToken != NULL){
            system.debug('Stripe'+CreditCardNumber);
             if(string.isBlank(CreditCardNumber)){
                 PaymentErrorString='Please Enter Credit Card Number';
                 return null;
             }else if(!string.isBlank(CreditCardNumber) && ! CreditCardNumber.isNumeric()){
                 PaymentErrorString='Please Enter Numbers only';
                 return null;
             }else if(CreditCardNumber.length() != 16 && SelectedCardType != 'American Express'){
                 PaymentErrorString='Please Enter 16 digit Number';
                 return null;
             }
             else if(CreditCardNumber.length() != 15 && SelectedCardType == 'American Express'){
                 PaymentErrorString='Please Enter 15 digit Number';
                 return null;
             }
             else if(integer.valueof(selectedyear) == system.today().year() && integer.valueof(selectedMonth) < system.today().month()){
                 PaymentErrorString='Please Select Valid Expiry Date';
                 return null;
             }else if(string.isBlank(CVVNumber)){
                 PaymentErrorString='Please Enter CVV Number';
                 return null;
             }else if(!string.isBlank(CVVNumber) && ! CVVNumber.isNumeric()){
                 PaymentErrorString='Please Enter Numbers only';
                 return null;
             }else if((CVVNumber != NULL || CVVNumber != '') && CVVNumber.length() < 3 && SelectedCardType != 'American Express'){
                 PaymentErrorString='Please Enter 3 Digit Number';
                 return null; 
             }
             else if((CVVNumber != NULL || CVVNumber != '') && CVVNumber.length() != 4 && SelectedCardType == 'American Express'){
                 PaymentErrorString='Please Enter 4 Digit Number';
                 return null; 
             }
             else{
                 BLN_Payments_BAL PaymentsBAL = new BLN_Payments_BAL();
                 
                 String ResponseMessage = PaymentsBAL.stripePayments(registrationEvent.Id,CreditCardNumber,selectedMonth,selectedyear,CVVNumber,TotalAmountDue-FeeAmount,FeeAmount,true);
                 system.debug('Stripe Response 1:'+ResponseMessage);
                 if(ResponseMessage!='Error'){
                    system.debug('Stripe Response 2:'+ResponseMessage);
                    showPaymentError= FALSE;
                    ChargeId = ResponseMessage;
                    pg = completeRegistration();
                 }
                 else{
                    ShowPaymentError= TRUE;
                    PaymentErrorString=ResponseMessage;
                    return null;
                 }      
             } 

         } 
         
         // Authorize .Net Payment
         if(SelectedPaymentGateway == 'CreditCard' && ANLoginId != NULL && ANTransactionKey != NULL){
            system.debug('Authorize .Net'+CreditCardNumber);
            AuthorizeDotNet ath = new AuthorizeDotNet(true,ANLoginId,ANTransactionKey);
            ath.transaction(CreditCardNumber, selectedMonth+selectedyear, String.valueOf(TotalAmountDue), CVVNumber,'','');  
            ath.setParameter('x_device_type','1');  
            ath.setParameter('x_first_name',GNUserforbuyer.First_Name__c);  
            ath.setParameter('x_last_name',GNUserforbuyer.Last_Name__c);  
            if(PayAddress.Street1_Address__c!=null){
               ath.setParameter('x_address',PayAddress.Street1_Address__c);  
            }else{
            ath.setParameter('x_address','');
            }
            if(PayAddress.BLN_State__c!=null){
             ath.setParameter('x_state',PayAddress.BLN_State__c);  
           }else{
            ath.setParameter('x_state','');  
           }
            ath.setParameter('x_response_format','1');  
            if(PayAddress.Zip__c!=null){
             ath.setParameter('x_zip',PayAddress.Zip__c);
           }else{
             ath.setParameter('x_zip','');
           }
            try{
                ath.process(3);
            }catch(Exception ex){

            }
            
            if(ath.isApproved()){
                String responsetext = ath.getResponseText();
                String transactionid = ath.getTransactionID();
                showPaymentError= FALSE;
                ChargeId = transactionid;
                pg = completeRegistration();
            }
            else if(ath.isDeclined()){
                ShowPaymentError = TRUE;
                PaymentErrorString = ath.getResponseText();
                return null; 
            }
            else{
                ShowPaymentError = TRUE;
                PaymentErrorString = ath.getResponseText();
                return null; 
            }
         }
         // Check Payment
         else if(SelectedPaymentGateway == 'Check'){ 

                 system.debug('Check Number: '+CheckNumber);
                 if(string.isBlank(CheckNumber)){
                     ShowPaymentError=TRUE;
                     PaymentErrorString='Please Enter Check Number'; 
                     return null;
                 }else if(!string.isBlank(CheckNumber) && ! CheckNumber.isNumeric()){
                     ShowPaymentError=TRUE;
                     PaymentErrorString=' Please enter the valid check number';    
                     return null;
                 }else{
                     ShowPaymentError=FALSE;
                     SelectedCardType = 'Check';
                     ChargeId = CheckNumber;
                     pg= completeRegistration();
                 }

         }
         else if(SelectedPaymentGateway == 'Cash'){
            ShowPaymentError=FALSE;
            SelectedCardType = 'Cash';
            pg = completeRegistration();
            return pg;
         }
         // PayPal Payment
         else if(SelectedPaymentGateway == 'PayPal'){
        
            CommonParametersObjName='MyRequestParams';
            APICredentialObjName ='SandboxCert';
            
            ActionType='PAY';
            
            FundingTypeEcheck = false;
            FundingTypeBalance = false;
            FundingTypeCreditCard = false;
            PPPayRequest request;
            try{
                // create request envelope and set the common request parameters
                
                request = new PPPayRequest(CommonParametersObjName, SenderEmail);   
                
                // set actionType
                request.ActionType = ActionType;  
            }catch(exception ed){
                request = new PPPayRequest();
            }
            
            // Set success and cancel urls
         //   Savepoint sp = Database.setSavepoint();
           //   completeRegistration();   
           
            String host = ApexPages.currentPage().getHeaders().get('Host');
             blob eveuyE = Blob.valueOf(registrationEvent.Id);
             eventidAfterEncoding = EncodingUtil.base64Encode(eveuyE );
              
            
            
            
            request.CancelUrl = 'http://' + host + '/apex/BLN_Registration?MainMessage=cancel&id='+registrationEvent.Id;
            request.ReturnUrl = 'http://' + host + '/apex/BLN_Success?id='+eventidAfterEncoding ;
            
            // Set a note associated with the payment        
            request.Memo = RegistrationEvent.Name;  
            // set receiver info in the request
            List<PPReceiver> receiverList = new List<PPReceiver>();
            
            try{

                PPReceiver rv = new PPReceiver();
                
                rv.Email =PayeeEmail;
                
                if(PaymentType!='Simple'){
                    rv.Amount = TotalAmountDue;
                    rv.primary = TRUE;
                }else{
                    rv.Amount = TotalAmountDue;
                }

                ActionType ='PAY';
                receiverList.add(rv); 
                
                if(PaymentType!='Simple'){
                    PPReceiver rv1 = new PPReceiver();
                    rv1.Email = BoothLeadsEmail;
                    ActionType ='PAY'; 
                    rv1.Amount = FeeAmount;
                    receiverList.add(rv1);
                }
            
            }catch(exception e){}
            
            
            request.receiverList = receiverList;
            // set FeesPayer
            request.FeesPayer = FeesPayer;
            if (FundingTypeEcheck) {
                PPFundingTypeInfo info = new PPFundingTypeInfo();
                info.FundingType = 'ECHECK';
                request.FundingTypeList.add(info);
            }
            if (FundingTypeBalance) {
                PPFundingTypeInfo info = new PPFundingTypeInfo();
                info.FundingType = 'BALANCE';
                request.FundingTypeList.add(info);
            }
            
            if (FundingTypeCreditCard) {
                PPFundingTypeInfo info = new PPFundingTypeInfo();
                info.FundingType = 'CREDITCARD';
                request.FundingTypeList.add(info);
            }
            
            IsDisplay = false;
            
            // create the Adaptive Toolkit object instance w/ API Credentials
            
            PPAdaptiveToolkit toolkit;
            if(istestmethod){
                toolkit = new PPAdaptiveToolkit(APICredentialObjName);
            }
            
            try {
                System.Debug(Logginglevel.INFO, '==>Request' + request);
                
                
                if(istestmethod){
                    PayResponse = toolkit.Pay(request);
                }else{
                
                }
                
                System.debug(PayResponse);          
                IsDisplay = true;
                RespEnvp = PayResponse.ResponseEnvelope;

                
                if(PayResponse.PaymentExecStatus.equalsIgnoreCase('Created')){
                
                    ApiUserName= toolkit.BaseAPIProfile.APIUsername;
                    Apipassword =toolkit.BaseAPIProfile.APIPassword;
                    Apisignature =toolkit.BaseAPIProfile.APISignature;
                    ApiapplicationId = toolkit.BaseAPIProfile.ApplicationID;
                    Apiipaddress =request.ClientDetails.IpAddress;
                    paypalUrl= toolkit.BaseAPIProfile.getPayPalLoginPage(); 

                    try{
                        setPaymentOptions(PayResponse.payKey);
                    }catch(exception ex){
                    
                    }
                    ChargeId = PayResponse.payKey;
                    ShowPaymentError = FALSE;
                    SelectedCardType = 'PayPal';
                    completeRegistration();  
                        
                     if(encodedCipherText   !='' && encodedCipherText != null){   
                       Cookie orderIdvalue= ApexPages.currentPage().getCookies().get('OrderId');
                       if (orderIdvalue == null) {
                            orderIdvalue = new Cookie('OrderId',encodedCipherText,null,-1,false);
                        }
                        
                       ApexPages.currentPage().setCookies(new Cookie[]{orderIdvalue });  
                     }               
                        
                         
                      
                      
                      
                    pg = new pageReference(toolkit.BaseAPIProfile.getPayPalLoginPage()+'_ap-payment&paykey='+PayResponse.payKey);
                    return pg;

                }
                else if(PayResponse.PaymentExecStatus.equalsIgnoreCase('Completed')){
                    SuccessMessage = 'Payment Completed - payKey - ' + PayResponse.payKey; 
                }
                else{
                    IsDisplay = true;
                    RespEnvp = PayResponse.getResponseEnvelope();
                    MainMessage = 'Payment Execution Status returned from server is - ' + PayResponse.PaymentExecStatus;
                }
            
            }
            catch(PPFaultMessageException ex) {
           // Database.rollback( sp );
                System.debug('PPFaultMessageException =>' + ex);
                IsDisplay = true;
                
                RespEnvp = ex.ResponseEnvelope;
                List<PPErrorData> errList = ex.ErrorList;
                for(PPErrorData err: errList ){
                    MainMessage += err.ErrorId + ' : ' + err.Message ;
                }
            
            }
            catch(System.Exception e){
                System.debug('System.Exception =>' + e);
                MainMessage = e.getMessage();
            } 

         }
          else if(SelectedPaymentGateway == 'TrustCommerce'){
          Http h = new Http();
        HttpRequest req = new HttpRequest();
        String url = 'https://vault.trustcommerce.com/trustee/token.php?custid='+ANLoginId+'&password='+ANTransactionKey;
  
  
  req.setEndpoint(url);
  req.setMethod('POST');
 
  HttpResponse res = h.send(req);
  String xml = res.getBody();
  //String ticket=eventAdminEvent[0].Psignature__c;
  
  //Payments
  ChargeId = xml;
                    ShowPaymentError = FALSE;
                    SelectedCardType = 'TrustCommerce';
                    BLN_Quick_Registration_BAL Quickbal = new BLN_Quick_Registration_BAL();
                    string ordstatus=Quickbal.insertingTotalorder(ItemList,TicketList,GNUserforbuyer,null,GNbuyerCompanyDetails,totalAmount + DiscountedAmount,DiscountedAmount,FeeAmount,TaxAmount,totalAmount,mapitemWithFee,mapitemWithDiscount,PromotionOb,SelectedCardType,SelectedPaymentGateway,ChargeId,PayGatewayMode,BillingAddressForbuyer,GNbuyerCompany,UserEventAnswer,'Online');    
                   if(ordstatus=='Success'){
             Blob key = Blob.valueOf(Quickbal.orderId);
               encodedCipherText = EncodingUtil.base64Encode(key);     
                     if(encodedCipherText   !='' && encodedCipherText != null){   
                       Cookie orderIdvalue= ApexPages.currentPage().getCookies().get('OrderId');
                       if (orderIdvalue == null) {
                            orderIdvalue = new Cookie('OrderId',encodedCipherText,null,-1,false);
                        }
                        
                       ApexPages.currentPage().setCookies(new Cookie[]{orderIdvalue });  
                     }               
                  }      
  
  
   pg = new PageReference('/apex/TRUSTCOMMERCEPROCESS');
   pg.getParameters().put('token', xml);
  pg.getParameters().put('amount', String.valueOf(TotalAmountDue));
   //newPage.getParameters().put('name', 'TESTPERSON');
   pg.getParameters().put('desc', 'Boothleads');
   //newPage.getParameters().put('ticket', ticket);
   pg.setRedirect(true);
            
          }
         return pg;
    }
//-------------------------------------------------------------------------------- Validating Payment Method End ---------------------------------------------------------------------------------

// --------------------------------------------------------------------------- For Setting PayPal Company Name Method Start ----------------------------------------------------------------------
public void setPaymentOptions(string payval){
    System.debug('PPPPPPPP:'+payval);
    try{
        Http h = new Http();
        HttpRequest req = new HttpRequest();   

        string NameofCompany  = RegistrationEvent.Name;


        if(string.isNotEmpty(NameofCompany)){ 
            NameofCompany = NameofCompany.ReplaceAll(' ','+');
        }

        req.setHeader('X-PAYPAL-SECURITY-USERID',ApiUserName);
        req.setHeader('X-PAYPAL-SECURITY-PASSWORD',Apipassword );      
        req.setHeader('X-PAYPAL-SECURITY-SIGNATURE',Apisignature );      
        req.setHeader('X-PAYPAL-DEVICE-IPADDRESS',Apiipaddress);
        req.setHeader('X-PAYPAL-REQUEST-DATA-FORMAT','NV');
        req.setHeader('X-PAYPAL-RESPONSE-DATA-FORMAT','NV');
        req.setHeader('X-PAYPAL-APPLICATION-ID',ApiapplicationId );
        string sandboxvalue='';
        if(paypalUrl.contains('sandbox')){
            sandboxvalue='sandbox.';
        }

        string endpoint = 'https://svcs.'+sandboxvalue+'paypal.com/AdaptivePayments/SetPaymentOptions?method=SetPaymentOptions&requestEnvelope.errorLanguage=en_US&payKey='+payval+'&displayOptions.businessName='+NameofCompany;

        req.setEndpoint(endpoint);
        req.setMethod('GET'); 
        if(istestmethod){
            HTTPResponse res = h.send(req);
            system.debug('Name on PayPal Login '+ res.getBody());
        }
    }catch(exception ex){

    }        
}

// --------------------------------------------------------------------------- For Setting PayPal Company Name Method End ----------------------------------------------------------------------

public void toalDiscountAfterallApp(){
 //selectedTicketIds 
 eventadminChangedAmount =0.00;
  BLN_Quick_Registration_BAL QuickRegBAL1 = new BLN_Quick_Registration_BAL();  
 for(BLN_Item__c blntc : QuickRegBAL1.getEventItems(registrationEvent.id)){
   if(mapTicWithQuan.keySET().contains(blntc.id)){
     eventadminChangedAmount += mapTicWithQuan.get(blntc.id)*(blntc.price__c);
    }
 }
 eventadminChangedAmount=eventadminChangedAmount+FeeAmount;
   system.debug('PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP '+eventadminChangedAmount);
 }

public string gnbuyercomp{get;set;}
public string errorvalidateion{get;set;}
//------------------------------------------------------------------------------ Complete Registration Method Start ----------------------------------------------------------------------------- 
// This method is fired when complete registration button is clicked
 
     public PageReference completeRegistration(){
     isDt=true;
      errorvalidateion = '';
      BLN_Quick_Registration_BAL Quickbal = new BLN_Quick_Registration_BAL();
         
          for(BLN_RegistrationnewCon.TicketInnerClass tinn :TicketList){
            if((tinn.Ticket.Item__r.Ticket_Settings__c != 'Collect info from All Attendees' && tinn.Ticket.Item_Type__r.name != 'Package')  || (tinn.Ticket.Item_Pool__r.Ticket_Settings__c != 'Collect info from All Attendees' && tinn.Ticket.Item_Type__r.name == 'Package')){
              
            }else{
               if(tinn.EachUser.Email__c!=null ){
                     errorvalidateion = validateData(tinn.EachUser.Email__c);     
                     if(errorvalidateion =='Invalid email address!'){
                        return null;
                     }         
                  }
               } 
            }           
        if(GNUserforbuyer.Email__c!=null){
                    errorvalidateion = validateData(GNUserforbuyer.Email__c);     
                     if(errorvalidateion =='Invalid email address!'){
                        return null;
                     }
        }
        
        
        
        
       if(naicsCodesString != NULL){
                
        LIST<String> naicsCodes= new LIST<String>(naicsCodesString.split('-'));
        system.debug(naicsCodes.size()+' NAICS CODES '+naicsCodes);
        if(naicsCodes.size() >1){
            GNbuyerCompanyDetails.Primary_NAICS_Code__c= naicsCodes[1];
            GNbuyerCompanyDetails.Secondary_NAICS_Code__c= NULL;
            
        }
        if(naicsCodes.size() >2){
            GNbuyerCompanyDetails.Secondary_NAICS_Code__c= naicsCodes[2];
            
        }
                
      }
      
        system.debug('  COMPANT EXT DETAILS '+GNbuyerCompanyDetails);
      string ordstatus=Quickbal.insertingTotalorder(ItemList,TicketList,GNUserforbuyer,null,GNbuyerCompanyDetails,totalAmount + DiscountedAmount,DiscountedAmount,FeeAmount,TaxAmount,totalAmount,mapitemWithFee,mapitemWithDiscount,PromotionOb,SelectedCardType,SelectedPaymentGateway,ChargeId,PayGatewayMode,BillingAddressForbuyer,GNbuyerCompany,UserEventAnswer,'Online');    
     System.debug('SSSSSSS::'+ordstatus);
     if(ordstatus=='Success'){
             Blob key = Blob.valueOf(Quickbal.orderId);
               encodedCipherText = EncodingUtil.base64Encode(key);
                blob eveuy = Blob.valueOf(registrationEvent.Id);
                string sty = EncodingUtil.base64Encode(eveuy );
               PageReference pg = new PageReference('/apex/BLN_Success?id='+sty +'&OrdId='+encodedCipherText );
                return pg; 
    }else{
         return null;
    }
            
  }
  
  public string validateData(string emailvalid){
    Pattern p = Pattern.compile( '([a-zA-Z0-9_\\-\\.]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))');
    Matcher m = p.matcher(emailvalid);
      if (m.matches()) {
        return 'Valid';
     } else {
       return 'Invalid email address!';
    }
  }
//------------------------------------------------------------------------------- Complete Registration Method End ------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------- Login User Method Start ----------------------------------------------------------------------------------- 
    @RemoteAction
    public static GN_User__c login(String EmailAddress, String Password){

        // Getting User Details from User DAO
        BLN_User_DAO UserDAO = new BLN_User_DAO();
        User LoggedInUser = new User();
        system.debug('@@@@@@@@@@ '+EmailAddress+'############### '+Password);
        LoggedInUser = UserDAO.checkLoggedInUser(EmailAddress,Password);
        system.debug('   EXISTTTTTTTTTTTTT   '+LoggedInUser);
        GN_User__c GNUserforbuyer = new GN_User__c();
        if(LoggedInUser != NULL){
            BLN_Gnuser_DAO  gnuserdao = new BLN_Gnuser_DAO();
                 
                  GNUserforbuyer = gnuserdao.existingGnuser(LoggedInUser.UserName);        
                  system.debug('Ticket List: '+GNUserforbuyer);
                  
                return GNUserforbuyer;
            
            }                 
        system.debug('UUUUUUUUU  '+GNUserforbuyer);
        return GNUserforbuyer ;
    }

// ------------------------------------------------------------------------------------ Login User Method End -------------------------------------------------------------------------------------- 


// ------------------------------------------------------------------------------------ Logout User Method Start ----------------------------------------------------------------------------------- 
    public void logout(){
        TicketList = new LIST<TicketInnerClass>();
        LoggedInGNUser = new GN_User__c();
        GNUserforbuyer= new GN_User__c();
        LoggedInUser = new User();
        HideLogin = FALSE;
        EmailAddress='';
        orderNow();

    }
// ------------------------------------------------------------------------------------ Logout User Method End ------------------------------------------------------------------------------------- 

// ------------------------------------------------------------------------------------ Fetch NAICS Codes Method Start ----------------------------------------------------------------------------
    public void fetchNAICSCodes(){
        NaicsList = new LIST<SelectOption> ();
        NaicsListOfList = new LIST<LIST<SelectOption>> ();
        listOfnaicscodes= new LIST<LIST<NAICS_Code__c>>();
        naicscodeslist = new List<NAICS_Code__c>();
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
        for(LIST<NAICS_Code__c> na : listOfnaicscodes){
            for(NAICS_Code__c na1 : na){
                NaicsList.add(new selectoption(na1.Name , na1.Name));
                if(NaicsList.size() == 999){
                    NaicsListOfList.add(NaicsList);
                    NaicsList  = new LIST<selectoption> ();
                }
            }
        }
        checkNAICSforEdit= '$$$$';
        if(NaicsList.size() != 0){
            NaicsListOfList.add(NaicsList);
        }
    }
// ------------------------------------------------------------------------------------ Fetch NAICS Codes Method End ------------------------------------------------------------------------------
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
        system.debug('CCCCCCCCC1'+countryOptions);
        stateOptions = new LIST<SelectOption> ();   
    }

    public LIST<SelectOption> statesBasedOnCountry(){
        system.debug('Selected Country '+selectedCountry);
        stateOptions= new LIST<SelectOption> ();   
    
        for(State__c s: [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c, Order__c FROM State__c WHERE Country__c =: selectedCountry]){
            stateOptions.add(new SelectOption(s.id,s.Long_Name__c));
        }
        return stateOptions;
    }
// --------------------------------------------------------------------------------------- States & Countries End ----------------------------------------------------------------------------------
    
    
// ----------------------------------------------------------------------------------------- Registration Settings Start ---------------------------------------------------------------------------
    public void fetchSettings(){
        LIST<Id> Itemslist = new LIST<Id>();
        ItemsSet = new SET<Id>();
        
        for(ItemInnerClass iic: ItemList){  
            if(iic.selectedItemQuantity != null){     
                if(Integer.valueOf(iic.selectedItemQuantity) >=1){  
                    Itemslist.add(iic.items.id);
                    if(iic.items.Item_Type__r.name == 'Package'){
                        Itemslist.add(iic.items.Item_Pool__c);
                    }
                }
            }
        }
        ItemsSet.addAll(Itemslist);
        
        // Getting Registration Settings
        BLN_RegistrationSettings_BAL RegSettingsBAL = new BLN_RegistrationSettings_BAL();
        RegSettingsMap = RegSettingsBAL.regsettings(ItemsSet,RegistrationEvent.id);
        
        for(Id ItemReg: Itemslist){
            LIST<Reg_Setting__c> RSList = RegSettingsMap.get(ItemReg);
        }
        
        // Getting Survey Questions
        BLN_SurveyQuestions_BAL SurveyBAL = new BLN_SurveyQuestions_BAL();
        
        // Getting Item Level Survey Questions
        QuestionsMap = SurveyBAL.getItemQuestions(ItemsSet,RegistrationEvent.id);
        
        // Getting Event Level Survey Questions
        EventQuestions = SurveyBAL.getEventQuestions(RegistrationEvent.id);
    }
// ----------------------------------------------------------------------------------------- Registration Settings End ----------------------------------------------------------------------------   

 // Get Company Names
  @RemoteAction
    public static List<Company__c> getCompanies(string searchstr,string emailid){
     SET<id> comids = new SEt<id>();
       for(UC_Role__c uc : [select id,Company__r.name,Company__c,name from UC_Role__c where GN_User__r.email__c =:emailid]){
            comids.add(uc.Company__c);
           
       }
      string v =  searchstr   + '%';  
      return [select id,name from Company__c where id In :comids and name like :v ] ;
   }
   
    public string checkCompany(string cname){
                 
              LIST<Company__c> UCRoleList = new List<Company__c>();
              
              if(cname!='' && cname!=null){
                 UCRoleList = [SELECT id from Company__c where id=:cname];
              }
    
              if(UCRoleList.size()>0){
                return UCRoleList[0].id;
              }else{
                 return '';
              }
        
            }
      public string checkPersonalAccount(string uEmail){
            LIST<UC_Role__c> UCRoleList = [SELECT id,Company__c,Company__r.id FROM UC_Role__c WHERE GN_User__r.Email__c =:uEmail and User_Type__c='Personal'];
            if(UCRoleList.size()>0){
                return UCRoleList[0].Company__r.id;
              }else{
                 return '';
              }
          }
          
        //Methods to mutli pick Naics Code, written by thirupathi
        public String naicsCodesString{get; set;}
        public pagereference sendNaicsCodes(){
        
            IF(ApexPages.currentPage().getParameters().get('naicsCodes') != ''){
            naicsCodesString=ApexPages.currentPage().getParameters().get('naicsCodes');
            }ELSE{
                naicsCodesString= NULL;
            
            }
            system.debug(ApexPages.currentPage().getParameters().get('naicsCodes')+' NAICS CODES STRING '+naicsCodesString);
            return null;
        } 
        

       
        public String buyerNaicsCodesString{get; set;}
        public pagereference sendBuyerNaicsCodes(){
        
            IF(ApexPages.currentPage().getParameters().get('naicsCodes') != ''){
                buyerNaicsCodesString=ApexPages.currentPage().getParameters().get('naicsCodes');
            }ELSE{
                buyerNaicsCodesString= NULL;
            
            }
            

            if(buyerNaicsCodesString != NULL){
                
                LIST<String> naicsCodes= new LIST<String>(buyerNaicsCodesString.split('-'));
                system.debug(naicsCodes.size()+' NAICS CODES '+naicsCodes);
                if(naicsCodes.size() >1){
                    GNbuyerCompanyDetails.Primary_NAICS_Code__c= naicsCodes[1];
                    GNbuyerCompanyDetails.Secondary_NAICS_Code__c= NULL;
                    
                }
                if(naicsCodes.size() >2){
                    GNbuyerCompanyDetails.Secondary_NAICS_Code__c= naicsCodes[2];
                    
                }
                
            }
            

            system.debug(GNbuyerCompanyDetails.Primary_NAICS_Code__c+' NAICS CODES STRING FOR BUYERS '+GNbuyerCompanyDetails.Secondary_NAICS_Code__c);
            return null;
        } 
    
        
        public boolean detailsbool {get ; set ;}
        public void cpmdetails(){
        
            if(selectedcompany != 'none'){
            detailsbool =  true;}
            else{
            detailsbool =  false;
            }
            comextnew  = new Company_Ext__c  ();
            system.debug('ssssssssssssssssssssssssssssss'+selectedcompany);
            comext = new LIST<Company_Ext__c>();
            compdetails = new Company__c ();
            comext = [SELECT ID, NAME, Business_Address1__c, Business_Address2__c, Business_City__c, BLN_Business_Country__c, BLN_Business_Country__r.Short_Name__c, BLN_Business_State__c,BLN_Business_State__r.Short_Name__c, Business_Zipcode__c, Work_Phone__c,Company__c,Duns_Number__c,
                                                 Established_Date__c,Keywords__c,Number_Of_Employees__c,Primary_NAICS_Code__c,Revenue__c,Secondary_NAICS_Code__c,Tax_Id__c FROM Company_Ext__c where Company__c =: selectedcompany];
            if(comext.size() > 0){
             comextnew  =comext[0]; 
            
            if(comext[0].Primary_NAICS_Code__c != NULL){
                    checkNAICSforEdit += comextnew.Primary_NAICS_Code__c;
            }
            if(comext[0].Secondary_NAICS_Code__c != NULL){
                checkNAICSforEdit += comextnew.Secondary_NAICS_Code__c;
            }
           
            countryStates();
        
        }
        
        try{
            if(selectedcompany != null && selectedcompany != ''){
                compdetails = [select  ID, NAME,Website_URL__c,Description__c, Company_Logo__c from Company__c where id =: selectedcompany];
            }else{
                compdetails = new Company__c();
            }
        
        }catch(exception ex){}
        
        
        }     
        
   }