/**************************************************
* @author :Arindam Sarkar
* @date 05/11/2014
* @ This class is used for Quick Registration module
****************************************************/

public without sharing class BLN_Quick_Registration_Con {
    public String CheckNumber{get;set;}
    public String SelectedCardType { get; set; }

    public String CVVNumber { get; set; }

    public String SelectedYear { get; set; }

    public String SelectedMonth { get; set; }

    public String CreditCardNumber { get; set; }
public BLN_UtillDisplayLinks myticket { get; set; }

  
  public void displayPermissions(){
Cookie k = ApexPages.currentPage().getCookies().get('counter');
if(k!=null){
event= k.getValue();
}

myticket = new BLN_UtillDisplayLinks();

BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
BLN_Event__c se = new BLN_Event__c ();
try{
se = blneventdetailbal.eventdetails(event);
myticket.EventName=se.Name;
}catch(exception e){}



myticket.isregistrationPageExpand='expand';
myticket.isonsiteRegistrationPage='active';
myticket.isregistrationPage='';
myticket.tablabel='Onsite Registration';
myticket.EventId = event;
myticket.userPermissions(userInfo.getUserId(),event);



}

     
     
     public List<SelectOption> getGetln() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('en','ENGLISH'));
            options.add(new SelectOption('es','SPANISH'));
            return options;
        }

    public String lnsel { get; set; }





   


    public PageReference mergeBadge() {
              //cancel badge
          String idInClause = '(\'';

         for (TicketWrapper tktwrapper: twrap){
               if(tktwrapper.selected == true) 
               idInClause += tktwrapper.tckt.Id+ '\',\'';

           }

         idInClause  = idInClause.substring(0,idInClause.length()-2);
         idInClause += ')';
         
        String q = 'select id,name,badge_label__c,cancel_time__c from Badge__c where ticket_id__c in ' + idInClause +' and cancel_time__c=null and Exp_time__c=null';
        List<Badge__c> badges=Database.query(q);
        For(integer i=0;i<badges.size();i++)
        {
          badges[i].cancel_time__c=System.now();           
        } 
        update badges;
        
        //Create badge for the First Ticket and associate all other tickets with that badge
         q = 'select id,name,badge_label__c,Badge_ID__c from Ticket__c where id in ' + idInClause;        
         List<Ticket__c> tckts=Database.query(q);        
                    Badge__c bg=new Badge__c();
                    bg.badge_label__c=badgelabel;
                    bg.ticket_id__c=tckts[0].id;
                    BLN_Badge_DAO bdgdao=new BLN_Badge_DAO();
                   
        BLN_StatusMessage bdgMsg =  bdgdao.insertbadge(bg);
           
              if(bdgMsg .successBool){
          
                 String badgeid=bdgMsg.successId;
                 for(integer i=1;i<tckts.size();i++)
                 {
                   tckts[i].Badge_ID__c=badgeid;
                 }
                 update tckts;
                              
              }
              
        return null;
    }


    public PageReference getSelected() {
         selectedTickets.clear();
         for(TicketWrapper tktwrapper: twrap) {
            if(tktwrapper.selected == true)
              selectedTickets.add(tktwrapper.tckt); }

            return null;
    }

public List<Ticket__c> selectedTickets{get;set;}
  

    public boolean checkboxselected { get; set; }

    public String reason{get;set;}

     //update user
     public PageReference printupdate()
     {
       quickbal.updateExistingBadge(reason,oldbadgelabel,badgelabel,oldASTitle ,ASTitle ,oldASPhone ,ASPhone,oldASFirstName,ASFirstName,oldASLastName,ASLastName,oldASUserEmail,ASUserEmail,oldASCompanyName,ASCompanyName,ticketitems );
       
       string[] ticketidandclientid =new string[]{};
       ticketidandclientid =ticketitems.split(';');
       ticketitems=ticketidandclientid [0];
          
       changebatch();
       return null;
        
     }
   public Decimal ticketamount{get;set;}
   public Decimal onlyticketamount{get;set;}
   public Decimal feeamount{get;set;}
   public String ticketid{get;set;}
   public String clientid{get;set;}
   public String nobadgelabel{get;set;}
    public PageReference finditemdetail() {
    badgelabel='';
        string[] ticketidandclientid =new string[]{};
        if(ticketitems.contains(';')==false){
       // changebatch();
       Ticket__c tc=[select id,name,(select id,name from badges__r),Item_Type__r.Item_Type_Number__c,Item_Pool__r.Item_type__c,Item_Pool__r.Badge_Label__c,Item_Pool__r.Badgable__c,Item_Type__c,Item__r.price__c from Ticket__c where id=:ticketitems];
       Decimal fee=0;
       if(tc.Item_Pool__r.Badgable__c=='N - No Badge')
       {
         nobadgelabel='true';
       }
       else
       nobadgelabel='false';
       
       
       if(tc.Item_Type__r.Item_Type_Number__c=='IT-000005')//for package
       {
          List<String> itemtype=new List<String>();
          Map<String,Decimal> itemqtymap=new Map<String,Decimal>();
          for(Ticket__c ch:[select id,name,(select id,name from badges__r),Item_Pool__r.Item_type__c,Item_Pool__r.Addon_Count__c,Item_Pool__r.Item_Type__r.Item_Type_Number__c,Parent_ID__c,Item_Type__r.Item_Type_Number__c,Item_Pool__r.Badge_Label__c,Item_Type__c,Item__r.price__c from Ticket__c where Parent_ID__c=:ticketitems])
          {
            itemtype.add(ch.Item_Pool__r.Item_type__c);
            if(ch.Item_Pool__r.Item_Type__r.Item_Type_Number__c=='IT-000001'||ch.Item_Pool__r.Item_Type__r.Item_Type_Number__c=='IT-000003'||ch.Item_Pool__r.Item_Type__r.Item_Type_Number__c=='IT-000004'||ch.Item_Pool__r.Item_Type__r.Item_Type_Number__c=='IT-000011'||ch.Item_Pool__r.Item_Type__r.Item_Type_Number__c=='IT-000018'||ch.Item_Pool__r.Item_Type__r.Item_Type_Number__c=='IT-000025')
            {
             if(ch.Item_Pool__r.Badge_Label__c!=null)
            badgelabel=ch.Item_Pool__r.Badge_Label__c;
            }
            itemqtymap.put(ch.Item_Pool__r.Item_type__c,ch.Item_Pool__r.Addon_Count__c);
          } 
          for(Event_Price__c ep:[select id,name,BL_Fee_Amount__c,BL_Fee_Percentage__c,Event__c,Item_type__c,Item_type__r.Item_Type_Number__c from Event_Price__c where Event__c=:event and Item_type__c in:itemtype])
          {
            fee+= (((ep.BL_Fee_Percentage__c*tc.Item__r.price__c)/100) + ep.BL_Fee_Amount__c)*itemqtymap.get(ep.Item_type__c);
             
          }
          if(fee==0){
          try{
          Event_Price__c ep=[select id,name,BL_Fee_Amount__c,BL_Fee_Percentage__c,Event__c,Item_type__c from Event_Price__c where Event__c=:event and Item_type__r.Item_Type_Number__c='IT-000001'];
          fee= ((ep.BL_Fee_Percentage__c*tc.Item__r.price__c)/100) + ep.BL_Fee_Amount__c;
          }catch(Exception e){}
          }
          
           ticketamount=tc.Item__r.price__c+fee;
       onlyticketamount=tc.Item__r.price__c;
       feeamount=fee;
      
       }
       else
       {
       try{
       Event_Price__c ep=[select id,name,BL_Fee_Amount__c,BL_Fee_Percentage__c,Event__c,Item_type__c from Event_Price__c where Event__c=:event and Item_type__c=:tc.Item_Type__c];
       fee= ((ep.BL_Fee_Percentage__c*tc.Item__r.price__c)/100) + ep.BL_Fee_Amount__c;
       }catch(Exception e)
       {}
       ticketamount=tc.Item__r.price__c+fee;
       onlyticketamount=tc.Item__r.price__c;
       feeamount=fee;
       badgelabel=tc.Item_Pool__r.Badge_Label__c;
       } 
        return null;
        }
         ticketidandclientid =ticketitems.split(';');
          ticketid=ticketidandclientid [0];
          clientid=ticketidandclientid [1];
    
    
        Ticket__c tc=quickbal.getItemInfoFrmTicket(ticketid);
        //show Item Client Info and his badge
        oldASUserEmail =ASUserEmail =tc.Email__c;
        oldASLastName =ASLastName =tc.Last_Name__c;
        oldASFirstName =ASFirstName =tc.First_Name__c;
        oldASCompanyName =ASCompanyName =tc.Company__c;
       // oldASTitle =ASTitle =tc.Client_GN_User__r.title__c;
        oldASPhone =ASPhone =tc.Client_GN_User__r.phone__c;
        oldbadgelabel=badgelabel=tc.badges__r.size()!=0?tc.badges__r[0].badge_label__c:tc.badge_id__r.badge_label__c; 
        if(oldbadgelabel==null)
        oldbadgelabel=badgelabel=tc.Badge_Label__c;
         badgeid=quickbal.getBadgeForTicket(tc.id);
    
        return null;
    }


     public String orderno{get;set;}
     public String badgeid{get;set;}
       public String badgelabel { get; set; }
     public String ASUserEmail { get; set; } // user Email
        public String ASLastName { get; set; } // User Last Name
        public String ASFirstName { get; set; } // User First Name
        public String ASPhone { get; set; }
        public String ASTitle { get; set; }
        public String ASCompanyName { get; set; }
        
        //for storing old values
        public String oldASUserEmail { get; set; } // user Email
        public String oldASLastName { get; set; } // User Last Name
        public String oldASFirstName { get; set; } // User First Name
        public String oldASPhone { get; set; }
        public String oldASTitle { get; set; }
        public String oldASCompanyName { get; set; }
        public String oldbadgelabel { get; set; }
        public boolean searchFlag{get;set;}

     
      public void changeBatch()
      {
      if(ticketitems!=null)
        badgeid=quickbal.getBadgeForTicket(ticketitems);
        else
        badgeid='';
      }
      
       /*public class TicketInnerClass{
    
        public String ticketid{get;set;}
       public String qASFirstName{get;set;}
       public String qASLastName{get;set;}
       public String qASUserEmail{get;set;}
       public String qASTitle{get;set;}
       public String qASPhone{get;set;}
       public String qASCompanyName{get;set;}
        }*/
    
  public String completeorder(String qpaymentmethod,String qCheckNumber,String qevent,String qCreditCardNumber,String qselectedMonth,String qselectedyear,String qCVVNumber,Decimal qonlyticketamount,Decimal qfeeamount,Decimal ticketamountplusfee,String qASFirstName,String qASLastName,String qASUserEmail,String qASTitle,String qASPhone,String qASCompanyName,List<String> qticketids)
    {
        BLN_StatusMessage Response = new  BLN_StatusMessage();
        String ChargeId='';
    
        if(qpaymentmethod == 'External Pay Gateway')
            SelectedCardType = 'External Pay Gateway';
        if(qpaymentmethod == 'Cash')
            SelectedCardType = 'Cash';          
        if(qpaymentmethod == 'Check'){
            SelectedCardType = 'Check';
            ChargeId = qCheckNumber;
        }
        
        if(qpaymentmethod == 'CreditCard'){
            BLN_Payments_BAL PaymentsBAL = new BLN_Payments_BAL();
                 
            String ResponseMessage = PaymentsBAL.stripePayments(qevent,qCreditCardNumber,qselectedMonth,qselectedyear,qCVVNumber,qonlyticketamount,qfeeamount,true);
            system.debug('Stripe Response 1:'+ResponseMessage);
            if(ResponseMessage!='Error'){
                ChargeId = ResponseMessage;
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ResponseMessage);
                ApexPages.addMessage(myMsg);  
                error='Transaction Error';                 
                return null;
            }  
        }
 
 
        //insert user process
       /* BLN_Gnuser_DAO gndao=new BLN_Gnuser_DAO();
        String userid=gndao.insertGnUserprocess(qASFirstName,qASLastName,qASUserEmail,qASTitle,qASPhone,null,null,null,null,null,null);
        
   
        
        //insert company process
        BLN_Company_DAO cdao=new BLN_Company_DAO();
        String companyId=cdao.insertcompanyAnducroleprocess(qevent,qASFirstName,qASLastName,qASUserEmail,userid,qASCompanyName,null,null);
    
    
 
        
        //Insert Pay Address
        BLN_Pay_Address_DAO pdao=new BLN_Pay_Address_DAO();
        BLN_StatusMessage PayAddressMessage=pdao.insertPayAddressprocess(qevent,companyId,userid);
        
        LIST<String> UserIds = new LIST<String>();
        LIST<String> CompanyIds = new LIST<String>();
        UserIds.add(userid);
        CompanyIds.add(companyId);
        MAP<Id,Id> PromotionIdMap = new MAP<Id,Id>();
        
    Response=quickbal.updateTickets(UserIds,CompanyIds,qticketids,qevent,userid,ticketamountplusfee,0,qfeeamount,0,ticketamountplusfee,PromotionIdMap,0,'',PayAddressMessage.SuccessId,SelectedCardType,qpaymentmethod,ChargeId,qpaymentmethod); 
  */
  BLN_Item_DAO itdao=new BLN_Item_DAO();
  LIST<BLN_RegistrationnewCon.ItemInnerClass> ItemList= new List<BLN_RegistrationnewCon.ItemInnerClass>();
  Ticket__c maintck=[select id,name,Item__c from Ticket__c where id=:ticketitems];
  BLN_Item__c  BLNItem=itdao.GetItemDetails(' where id=\''+maintck.Item__c+'\'');

LIST<Selectoption> itemWiseCount = new LIST<Selectoption>();
itemWiseCount.add(new Selectoption(string.valueOf(1), string.valueOf(1) ));


 ItemList.add(new BLN_RegistrationnewCon.ItemInnerClass(BLNItem,itemWiseCount,String.valueOf(1),qfeeamount,''));
  
  
    
   BLN_Ticket_DAO TicketDAO = new BLN_Ticket_DAO();
List<Ticket__c> tckt = TicketDAO.getTickets('id,name,Item__r.Payment__c,Item__r.Event__c,Item__r.price__c,Item__r.item_name__c,Item_Type__r.name,item__r.Ticket_Settings__c,Ticket_Status__c,Parent_ID__c,Item_Pool__r.Badgable__c,Item_Pool__r.Ticket_Settings__c,Event__c,Item__c','Event__c=\''+event +'\' AND (id=\''+ticketitems+'\' OR Parent_ID__c=\''+ticketitems+'\')'); 



LIST<BLN_RegistrationnewCon.TicketInnerClass> TicketList= new LIST<BLN_RegistrationnewCon.TicketInnerClass>();
GN_User__c LoggedInGNUser = new GN_User__c();
Company__c GNbuyerCompany=new Company__c();
GNbuyerCompany.Name=qASCompanyName;
for(integer i=0;i<tckt.size();i++)
{
//BLNItem=itdao.GetItemDetails(' where id=\''+tckt[i].Item__c+'\'');


 //List<Ticket__c> RegTickets = quickbal.getTicketDetail(BLNItem,1); 
 
 LoggedInGNUser.First_Name__c = qASFirstName;
 LoggedInGNUser.Last_Name__c = qASLastName;
 LoggedInGNUser.Email__c = qASUserEmail;
 LoggedInGNUser.Phone__c = qASPhone;
 
// LoggedInGNUser.Company_Name__c = qASCompanyName;
 //LoggedInGNUser.Title__c=qASTitle;
 TicketList.add(new BLN_RegistrationnewCon.TicketInnerClass(tckt[i],1,LoggedInGNUser,1,BLNItem,null,null,null,false));
 }
 
 
 string ordstatus =quickbal.insertingTotalorder(ItemList, TicketList,LoggedInGNUser,null,new Company_Ext__c(),ticketamountplusfee, 0, qfeeamount,0, ticketamountplusfee, null,null,null, SelectedCardType, qpaymentmethod,ChargeId, qpaymentmethod,new pay_address__c(),GNbuyerCompany,new List<BLN_RegistrationnewCon.UserAnswerInnerClass>(),'Onsite');
   
    
   if(ordstatus=='Success'){ 
    
    try{
        //Sending email
       BLN_SuccessController blsuc=new BLN_SuccessController(); 
       System.debug('quickbal.orderId '+quickbal.orderId);
       blsuc.eventId=event;
       blsuc.orderId=quickbal.orderId;
       blsuc.sendMail(); 
    }
    catch(Exception e)
    {
       
    }
      }
    return ordstatus;
    
    }
    public String error{get;set;}
    public PageReference order() {
    //BLN_StatusMessage Response = new  BLN_StatusMessage();
    String Response=null;
    String response1='';
    List<String> ticketids=new List<String>();
        ticketids.add(ticketitems);
    Response =completeorder(paymentmethod,CheckNumber,event,CreditCardNumber,selectedMonth,selectedyear,CVVNumber,onlyticketamount,feeamount,ticketamount,ASFirstName,ASLastName,ASUserEmail,ASTitle,ASPhone,ASCompanyName,ticketids);
    if(Response==null)
    {
       badgeid='';
       return null;
    }
    
   
    

     Ticket__c tc=[select id,name,Item_Pool__c,Item_Pool__r.Badgable__c,Item_Type__r.Name from Ticket__c where id=:ticketitems];
     if(tc.Item_Pool__r.Badgable__c=='N - No Badge'&&tc.Item_Type__r.Name!='Package')
     {
        error='N - No Badge';
         badgeid='';
       return null;
     }
     if(tc.Item_Type__r.Name!='Package'){
     
      String succesbdgMsg=quickbal.generateBadge(badgelabel,ticketitems,'');
      changebatch();
      }
      else
      {
            //Get all the admission tickets
    List<Ticket__c> admticket=[select id,name,Badge_Label__c,Item_Pool__c,Item_Pool__r.Item_type__r.name,Parent_ID__c from Ticket__c where Parent_ID__c=:ticketitems and Item_Pool__r.Item_type__r.name='Admissions'];
    error='N - No Badge';
    badgeid='';
               
     //Get all the line items pool except admission
    List<Item_Pool__c> otherpool=[select id,name,Addon_Parent__c,Item_Count__c,Item_type__r.name from Item_Pool__c where Addon_Parent__c=:tc.Item_Pool__c and Item_type__r.name!='Admissions'];
    for(integer i=0;i<otherpool.size();i++)
           {
                //get addontickets for that pool
                List<Ticket__c> child=[select id,name,badgeparentid__c,Parent_ID__c,Item_Pool__c from Ticket__c where Parent_ID__c=:ticketitems and Item_Pool__c=:otherpool[i].id];
                Integer j=0;
                for(;j<child.size();j++)
                {
                    if(j==admticket.size())
                    break;
                   child[j].badgeparentid__c=admticket[j].id;
                   
                }
                for(Integer rem=j;rem<child.size();rem++)
                {
                   child[rem].badgeparentid__c=admticket[admticket.size()-1].id;
                }
                  update child;
               
               }
      }
     
      return null;


    }

      public BLN_Quick_Registration_BAL quickbal = new BLN_Quick_Registration_BAL ();
        public string[] emaiiandid{get;set;}
        public string email{get;set;}
        public string eventid{get;set;}
        public string event{get;set;}
        public BLN_Event__c eventdetails {get;set;}
        
        public List<Ticket__c> eventChosenTickets{get;set;}
        public String paymentmethod{get;set;}//holds the values of the selected checkboxes
    public list<selectOption> paymentmethoditems{get;set;}
    
    
    public list<selectOption> MonthsList{get;set;}
    public list<selectOption> YearsList{get;set;}
    public list<selectOption> CreditCardType{get;set;}
   
        
        public  BLN_Quick_Registration_Con ()
        {
         
          event= Apexpages.currentPage().getParameters().get('id');
          
          //displayPermissions(); 
          eventdetails =quickbal.getEventDetails(event);  
          
         if(eventdetails==null){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Event does not Exist');
            ApexPages.addMessage(myMsg);
         return;
         }  
                
    //Getting Items to book
            List<BLN_Item__c> items=quickbal.getEventItems(event);
           
       
     myitems = new list<selectOption>();
     if(ApexPages.currentPage().getParameters().get('tab')!=null&&ApexPages.currentPage().getParameters().get('tab')!='attendee'){
     
        myitems=quickbal.getAvailableTickets(items);
     
     }
    searchFlag=false;
    
    paymentmethoditems=new List<selectOption>();
    paymentmethoditems.add(new selectOption('','Select One'));
    for(integer i=0;i<eventdetails.Event_Pay_Gateway__r.size();i++)
    {
      if(eventdetails.Event_Pay_Gateway__r[i].Registration_Type__c =='Onsite')
      paymentmethoditems.add(new selectOption(eventdetails.Event_Pay_Gateway__r[i].Pay_Gateway__r.PGateway_Type__r.Name,eventdetails.Event_Pay_Gateway__r[i].Pay_Gateway__r.PGateway_Type__r.Name)); 
    }
    
   
    //paymentmethoditems.add(new selectOption('CreditCard','CreditCard'));
    
    //search in chosen
   // eventChosenTickets=quickbal.getBookedTickets(event);

    //Getting Stripe Related Information
        MonthsList= new LIST<SelectOption>();
        YearsList= new LIST<SelectOption>();
        CreditCardType= new LIST<SelectOption>();
    
        LIST<String> monthstring = new LIST<String>{'01','02','03','04','05','06','07','08','09','10','11','12'};
        LIST<String> yearstring = new LIST<String>{'2014','2015','2016','2017','2018','2019','2020','2021','2022','2023','2024','2025','2026','2027','2028','2029','2030'};
        LIST<String> cardtypestring = new LIST<String>{'Visa','MasterCard','American Express','Discover'};
        String SelectedYear= String.valueOf(system.today().year());
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
         
         
         

        
    public String ticketitems{get;set;}//holds the values of the selected checkboxes
    public list<selectOption> myitems{get;set;}
    public List<Ticket__c> ordtckt{get;set;}
    public List<TicketWrapper> twrap{get;set;}
   public pagereference getOrderDetails()
   {
   selectedTickets=new List<Ticket__c>();
   twrap=new List<TicketWrapper>();
   if(eventdetails==null)
     {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Event does not Exist');
            ApexPages.addMessage(myMsg);
         return null;
         } 
      ordtckt=quickbal.getClientTicketsbasedonOrderOrEmail(event,orderno);
       
      if(ordtckt.size()!=0)
      {
         myitems = new list<selectOption>();
         for(Ticket__c tc:ordtckt)
         {
          myitems.add(new selectOption(tc.id+';'+tc.Client_GN_User__c,tc.Order_Item__r.Item__r.item_name__c+'--'+tc.Client_GN_User__r.First_Name__c));   
          twrap.add(new TicketWrapper(tc)); 
         }
         
         //loading first record
         ticketitems=ordtckt[0].id+';'+ordtckt[0].Client_GN_User__c;
         finditemdetail();
         searchFlag=true;
      }
      else
      {
      
        ordtckt=new List<Ticket__c>();
        myitems = new list<selectOption>();
        if(ApexPages.currentPage().getParameters().get('tab')!=null&&ApexPages.currentPage().getParameters().get('tab')!='attendee'){
        List<BLN_Item__c> items=quickbal.getEventItems(event);
        
        myitems=quickbal.getAvailableTickets(items);
        
        }
        ASUserEmail ='';
        ASLastName ='';
        ASFirstName ='';
        ASCompanyName ='';
        badgeid='';
        ASTitle='';
        ASPhone ='';
        badgelabel='';
        searchFlag=false;
      }
      return null;
   }
   
   
    public PageReference processEmail() {

    User u=quickbal.getExistingUser(ASUserEmail);
    if(u.id!=null){
    ASLastName =u.LastName;
    ASFirstName=u.FirstName;
    ASPhone=u.Phone;
    ASTitle=u.title;
    ASCompanyName =u.CompanyName;
    }

        return null;
    }
    
   
   //checkbox logic
   
   public class TicketWrapper
    {
        public Ticket__c tckt{get; set;}
        public Boolean selected {get; set;}
        public TicketWrapper(Ticket__c tc)
        {
            tckt= tc;
            selected = false;
        }
    }
   
   //Avery Print Badge
   public BLN_BadgeTemplate_Styles__c btstyle{get;set;}
   public Badge bg{get;set;}
   public List<Style> elems{get;set;}
       public PageReference printAvery() {
       try
       {
        btstyle=[select BadgeName__c,FirstRowElement__c,SecondElement__c,ThirdElement__c,FourthElement__c,FifthElement__c from BLN_BadgeTemplate_Styles__c where Event__c=:event limit 1];
    //Parse Badge Name
    String badgename=btstyle.BadgeName__c;
    parseBadge(badgename.substring(0,badgename.length()-1));
    elems=new List<Style>(); 
    //Parse Elements
     if(btstyle.FirstRowElement__c!=null&&btstyle.FirstRowElement__c != '')
    parseElement(btstyle.FirstRowElement__c);
     if(btstyle.SecondElement__c!=null&&btstyle.SecondElement__c != '')
    parseElement(btstyle.SecondElement__c);
     if(btstyle.ThirdElement__c!=null&&btstyle.ThirdElement__c != '')
    parseElement(btstyle.ThirdElement__c);
     if(btstyle.FourthElement__c!=null&&btstyle.FourthElement__c != '')
    parseElement(btstyle.FourthElement__c);
    if(btstyle.FifthElement__c!=null&&btstyle.FifthElement__c != '')
    parseElement(btstyle.FifthElement__c );
    
  getSelected();
        Pagereference pg=new PageReference('/apex/AveryBadge');
        pg.setRedirect(false);
        return pg;
        }catch(Exception e)
        {
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please design an Custom Template LINK:/BL_BadgeTool?eventid='+event);
            ApexPages.addMessage(myMsg);
        return null;  
        }
    }
    
    
    public void parseBadge(String bdg)
   {

     // Parse entire JSON response.
    JSONParser parser = JSON.createParser(bdg);
    while (parser.nextToken() != null) {
        // Start at the array of invoices.
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
                // Advance to the start object marker to
                //  find next invoice statement object.
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    // Read entire invoice object, including its array of line items.
                    bg= (Badge)parser.readValueAs(Badge.class);
                  
                

                }
            }
        }
    }
    
   }
   
   public void parseElement(String elem)
   {
     
    // Parse entire JSON response.
    JSONParser parser = JSON.createParser(elem);
    while (parser.nextToken() != null) {
        // Start at the array of invoices.
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
                // Advance to the start object marker to
                //  find next invoice statement object.
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    // Read entire invoice object, including its array of line items.
                    Style st= (Style)parser.readValueAs(Style.class);
                  elems.add(st);

                }
            }
        }
    }
      
   }
   
  
  
  
  
  public class Style{
  public String id{get;set;}
  public String height{get;set;}
  public String width{get;set;}
  public String positionTop{get;set;}
  public String positionLeft{get;set;}
  public String marginTop{get;set;}
  public String marginRight{get;set;}
  public String marginBottom{get;set;}
  public String marginLeft{get;set;}
  public String paddingTop{get;set;}
  public String paddingRight{get;set;} 
  public String paddingBottom{get;set;} 
  public String paddingLeft{get;set;} 
  public String textAlign{get;set;} 
  public String fontSize{get;set;} 
  public String fontFamily{get;set;} 
  public String textTransform{get;set;} 
  public String contentText{get;set;}   
  public String backgroundColor{get;set;}
  public String opacity{get;set;}
  public String textColor{get;set;}  
  public String qrUrlResult{get;set;}
  public String urlResult{get;set;}
    public Style(String id,String height,String width,String positionTop,String positionLeft,String marginTop,String marginRight,
    String marginBottom,String marginLeft,String paddingTop,String paddingRight,String paddingBottom,String paddingLeft,
    String textAlign,String fontSize,String fontFamily,String textTransform,String contentText,
    String backgroundColor,String opacity,String textColor,String qrUrlResult,String urlResult){
        id=this.id;
        height=this.height;
        width=this.width;
        positionTop=this.positionTop;
        positionLeft=this.positionLeft;
        marginTop=this.marginTop;
        marginRight=this.marginRight;
        marginBottom=this.marginBottom;
        marginLeft=this.marginLeft;
        paddingTop=this.paddingTop;
        paddingRight=this.paddingRight; 
        paddingBottom=this.paddingBottom; 
        paddingLeft=this.paddingLeft; 
        textAlign=this.textAlign; 
        fontSize=this.fontSize; 
        fontFamily=this.fontFamily; 
        textTransform=this.textTransform; 
        contentText=this.contentText; 
        backgroundColor=this.backgroundColor;
        opacity=this.opacity;
        textColor=this.textColor;  
        qrUrlResult=this.qrUrlResult;
        urlResult=this.urlResult;
    }
}


public class Badge{
public String width{get;set;}
public String height{get;set;}
public String backgroundColor{get;set;}

public Badge(String width,String height,String backgroundColor)
{
  this.width=width;
  this.height=height;
  this.backgroundColor=backgroundColor;
  
}
}

  
          
          
          
          
           //autocomplete search code for company----Arindam Sarkar
    
    public Object selectValue{get; set;}
   
     public String searchValue {get; set;}
    public Integer maxHeights {get; set;}
    public Integer height {get; set;}
    public List<SelectOption> results {get; set;}
    public Boolean showList {get; set;}
    Map<String,String> resultsMap;
 
    //This is our seach method that is called every time a character is entered
    public void search(){
  
        showList = true;
        results = new List<SelectOption>();
        resultsMap = new Map<String,String>();
 
        //Using dynamic SOQL we pass the object and the search value
        if(orderno.length() > 0){
            String entry = '%' + orderno + '%';
            //Search by First Name
            String queryString = 'Select id,name,Client_GN_User__c,Client_GN_User__r.First_Name__c from Ticket__c where Event__c=\''+event+'\' and Ticket_Status__c=\'Booked\' and Item_Pool__r.Badgable__c=\'B - Badge\' and (Client_GN_User__r.First_Name__c like :entry)';
            
          List<Ticket__c> listc=Database.query(queryString);
          Set<String> lists=new  Set<String>();
            for(Ticket__c o : listc){
                   lists.add(o.Client_GN_User__r.First_Name__c);            
            }
            
            if(listc.size()==0)
            {
                queryString = 'Select id,name,Client_GN_User__c,Client_GN_User__r.Last_Name__c from Ticket__c where Event__c=\''+event+'\' and Ticket_Status__c=\'Booked\' and Item_Pool__r.Badgable__c=\'B - Badge\' and (Client_GN_User__r.Last_Name__c like :entry)';
            
          listc=Database.query(queryString);
          lists=new  Set<String>();
            for(Ticket__c o : listc){
                   lists.add(o.Client_GN_User__r.Last_Name__c);            
            }
            }
            
            if(listc.size()==0)
            {
                queryString = 'Select id,name,Client_GN_User__c,Client_GN_User__r.Email__c from Ticket__c where Event__c=\''+event+'\' and Ticket_Status__c=\'Booked\' and Item_Pool__r.Badgable__c=\'B - Badge\' and (Client_GN_User__r.Email__c like :entry)';
            
          listc=Database.query(queryString);
          lists=new  Set<String>();
            for(Ticket__c o : listc){
                   lists.add(o.Client_GN_User__r.Email__c);            
            }
            }
            
            if(listc.size()==0)
            {
                queryString = 'Select id,name,Client_GN_User__c,Client_Company__r.name from Ticket__c where Event__c=\''+event+'\' and Ticket_Status__c=\'Booked\' and Item_Pool__r.Badgable__c=\'B - Badge\' and (Client_Company__r.name like :entry)';
            
          listc=Database.query(queryString);
          lists=new  Set<String>();
            for(Ticket__c o : listc){
                   lists.add(o.Client_Company__r.name);            
            }
            }
            
            
            if(listc.size()==0)
            {
                queryString = 'Select id,name,Client_GN_User__c,Order__r.name from Ticket__c where Event__c=\''+event+'\' and Ticket_Status__c=\'Booked\' and Item_Pool__r.Badgable__c=\'B - Badge\' and (Order__r.name like :entry)';
            
          listc=Database.query(queryString);
          lists=new  Set<String>();
            for(Ticket__c o : listc){
                   lists.add(o.Order__r.name);            
            }
            }
            
            
            /*Next we add the results to our list of selectOptions. We also add the values to a map so that when a value
            is selected we can auto fill the search box with the selected value */
            for(String o : lists){
                results.add(new SelectOption(o,o));
                resultsMap.put(o,o);
            }
        }
 
        //Next we inspect the results to set the height and contents of the selectList
        if(orderno.length() == 0){
            showList = false;
        }else if(results.size() == 0 && orderno.length() != 0){
            results.add(new SelectOption('','No matches found'));
            height = 2;
        }else if(results.size() == 1){
            height = 2;
        }else if(results.size() > maxHeights){
            height = maxHeights;
        }else{
            height = results.size();
        }
    }
 
    public String thisval{get;set;}
    //When a value is selected we will auto complete the searchValue
    public void selectValue(){
        showList = false;
        orderno= resultsMap.get((string)thisval);
        
    }
 
    //simply hides the list of resultsyo
    public void hideResults(){
        showList = false;
        
    }

    //end of autocomplete search code
          
    
    
}