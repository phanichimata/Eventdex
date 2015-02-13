public with sharing class BLN_AttendeesController {

    public PageReference assignTag() {
    BLNUtility blutil=new BLNUtility();
    
    
     for(List<BLN_Attendees_BAL.inncls> tclist:ListOfListAttendees)
      {
          for(BLN_Attendees_BAL.inncls tc:tclist)
          {
              if(tc.selectCheckBox==true)
              { 
               
               blutil.AssignTags(tc.ticket.Id,tagName,selectedEvent,'Ticket__c');
              
           }}}
    
    
    
        PageReference pg= new Pagereference('/apex/BLN_Attendees');
        pg.setRedirect(true);
        return pg;
    }


    public String tagName { get; set; }

    public PageReference CloseGuests() {
      displyAddGuest = false;
        return null;
    }

        //Modified by Thirupathi Pattipaka
      public PageReference createBadgeLabel() {
    BLN_Quick_Registration_BAL qb=new BLN_Quick_Registration_BAL();
   /* system.debug('YYYYYYYYYYYYYYYY '+ApexPages.currentPage().getParaMeters().get('label')+'YYYYYYYYYYYYYYYY '+ApexPages.currentPage().getParaMeters().get('ticketid'));
    String badgeid=qb.getBadgeForTicket(ApexPages.currentPage().getParaMeters().get('ticketid'));
    
    if(badgeid==null)
          qb.generateBadge(ApexPages.currentPage().getParaMeters().get('label'),ApexPages.currentPage().getParaMeters().get('ticketid'));
          else
          {
                 Badge__c bg=new Badge__c();     
                  bg.id=badgeid;
                    bg.Badge_Label__c=ApexPages.currentPage().getParaMeters().get('label');
                    BLN_Badge_DAO bdgdao=new BLN_Badge_DAO();
                    bdgdao.updatebadge(bg);
                    }*/
                    //update the label in ticket
        Ticket__c tc=[select id,name,Badge_Label__c,Tag_No__c from Ticket__c where id=:ApexPages.currentPage().getParaMeters().get('ticketid')];
        tc.Badge_Label__c =ApexPages.currentPage().getParaMeters().get('label');
        update tc;           
        return null;
    }
    
    //Updating seat Number for respective ticket
    public PageReference createSeatNumber() {
        Ticket__c tcTemp=[select id,name,Badge_Label__c,Tag_No__c from Ticket__c where id=:ApexPages.currentPage().getParaMeters().get('ticketid')];
        tcTemp.Tag_No__c = ApexPages.currentPage().getParaMeters().get('Seatnumber');
        update tcTemp;           
        return null;
    }


  
    public BLN_UtillDisplayLinks   myticket { get; set; }
    public string selectedEvent {get ; set ;}
    public BLN_Attendees_BAL attBal{get;set;}
    public MAP<id,ticket__c> mapticWithId{get;set;}
    public MAP<id,GN_User__c> mapguIdWithGNU{get;set;}
    public LIST<BLN_Attendees_BAL.inncls> getTickets{get;set;}
    public SET<id> GnuserList{get;set;}
    public BLN_MyticketsCon myTicketsBal{get;set;}
    public MAP<id,order_item__c> mapitemWithId {get;set;}
    public SET<id> orderItemids {get;set;}
    public LIST<SelectOption> countryOptions{get; set;}
   public LIST<SelectOption> stateOptions{get; set;}
   public string selectedCountry{get; set;}
   public String selectedState{get; set;}
   public LIST<LIST<NAICS_Code__c>> listOfnaicscodes{get; set;}
     public String checkNaicsForEdit{get; set;}
     
    public integer z{get;set;} 
    public BLN_Event__c   se{get;set;}
    public BLN_Mytickets_BAL blnMyticketsBal {get;set;}
     
    public  LIst<List<BLN_Attendees_BAL.inncls>>  ListOfListAttendees{get;set;}
     
     public void displayPermissions(){
       cookie k = ApexPages.currentPage().getcookies().get('counter');
          if(k!=null){
            selectedEvent = k.getValue(); 
          }
     system.debug('WWWWWWWWWWWWWWWWWWWWW '+selectedEvent );
      myticket = new BLN_UtillDisplayLinks();    
     BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
     se = new BLN_Event__c  ();
      try{
      se = blneventdetailbal.eventdetails(selectedEvent );
      myticket.EventName=se.Name;
     }catch(exception e){}
          
      
         myticket.isAttendeesPage='active';
         myticket.tablabel='Attendees';
         myticket.isEventAdmin =true;
         myticket.EventId = selectedEvent ;
         myticket.isAttendeesPageExpand ='expand';
         myticket.userPermissions(userInfo.getUserId(),selectedEvent);
    }
    
   public SET<id> orderIds {get;set;}
    public MAP<id,order__c> mapidWithOrders{get;set;}
    
    public String selectedAttendeeType{get; set;} //for filter criteria
     public LIST<SelectOption> attendeeTypes{get; set;}
   
    public BLN_AttendeesController(){
       // selectedEvent  = ApexPages.currentPage().getParameters().get('counter');
          cookie k = ApexPages.currentPage().getcookies().get('counter');
          if(k!=null){
          selectedEvent = k.getValue();
          }
          //selectedEvent  = 'a0sc00000030kAi';
           system.debug('WWWWWWWWWWWWWWWWWWWWW 22222222222222222'+selectedEvent );
          mapidWithOrders = new MAP<id,order__c>();
         if(selectedEvent !=null && selectedEvent !=''){ 
              mainMethod();
          }
      
      checkNaicsForEdit='';
      
      //Filter criteria
      attendeeTypes= new LIST<SelectOption>();
        attendeeTypes.add(new SelectOption('All Attendees', 'All Attendees'));
        attendeeTypes.add(new SelectOption('Buyers Only', 'Buyers Only'));
      selectedAttendeeType= 'All Attendees';
      
      //default for avery
      bdstyleslist = new  LIST<selectoption> ();
    Bdstyles = new List<BLN_BadgeTemplate_Styles__c> ();
     Bdstyles = [select id,Name,badge_type__c from BLN_BadgeTemplate_Styles__c where Event__r.id =: selectedEvent and badge_type__c='Zebra' and Module__c like '%Attendee Registration%' ];
    for(BLN_BadgeTemplate_Styles__c BTS : Bdstyles ){
    bdstyleslist.add(new selectoption(BTS.Name,BTS.Name));
    System.debug('bbbbbbbbbbbbb:'+bdstyleslist);
    }
    //end
    
    
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
     
     public Map<Id,String> tagsmap{get;set;}
     public Map<Id,String> tickettagsmap{get;set;}
     public SET<Id> statusId{get;set;}
      
     public void mainMethod(){
         tagsmap=new Map<Id,String>();
         tickettagsmap=new Map<Id,String>();
         mapticWithId  = new MAP<id,ticket__c>(); 
         mapitemWithId  = new MAP<id,order_item__c>();
         mapguIdWithGNU = new MAP<id,GN_User__c>();
         BLN_Gnuser_DAO guDAO = new BLN_Gnuser_DAO();
         getTickets= new LIST<BLN_Attendees_BAL.inncls>();
         GnuserList = new SET<id>();
         myTicketsBal = new BLN_MyticketsCon();
         orderItemids  = new SET<id>();
         orderIds = new SET<id>();
         statusId=new SET<id>();
         ListOfListAttendees = new LIst<List<BLN_Attendees_BAL.inncls>>();
         myTicketsBal.isAttendeesPAge = 'Attendee';
         attBal = new BLN_Attendees_BAL();
       
         BLN_OrderItem_DAO orderItemDao = new BLN_OrderItem_DAO();
         BLN_Order_DAO ordDao = new BLN_Order_DAO();
         
         //get all tags
         for(Hash_Tag__c itptj:[select id,name,RowId__c,Tag_Text__c,Event__c,Table_Name__c from Hash_Tag__c where Event__c=:selectedEvent and Table_Name__c='Item_Pool__c'])
         {
            if(tagsmap.containsKey(itptj.RowId__c)){
            String text=tagsmap.get(itptj.RowId__c);
            if(text!=itptj.Tag_Text__c)
            tagsmap.put(itptj.RowId__c,text+' '+itptj.Tag_Text__c);
            }
            else
            tagsmap.put(itptj.RowId__c,itptj.Tag_Text__c);
         }
         //
         //get all tickets tag map
         for(Hash_Tag__c itptj:[select id,name,RowId__c,Tag_Text__c,Event__c,Table_Name__c from Hash_Tag__c where Event__c=:selectedEvent and Table_Name__c='Ticket__c'])
         {
            if(tickettagsmap.containsKey(itptj.RowId__c)){
            String text=tickettagsmap.get(itptj.RowId__c);
            tickettagsmap.put(itptj.RowId__c,text+' '+itptj.Tag_Text__c);
            }
            else
            tickettagsmap.put(itptj.RowId__c,itptj.Tag_Text__c);
         }
         
         List<BLN_Attendees_BAL.inncls>  attendeeList = new List<BLN_Attendees_BAL.inncls>();  
           //userInfo.getUserid()
         getTickets =  attBal.getAllTickets(userInfo.getUserid(),selectedEvent);        
        system.debug('WWWWWWWWWWWWWWWWWWWWWWWWWW  '+getTickets );
         for(BLN_Attendees_BAL.inncls tc :getTickets){
           mapticWithId.put(tc.ticket.id,tc.ticket); // Map tickets with its id  
           GnuserList.add(tc.ticket.Client_GN_User__c);
           orderItemids.add(tc.ticket.order_item__c);
           orderIds.add(tc.ticket.order__c);
           statusId.add(tc.ticket.Tstatus_Id__c);
            attendeeList.add(tc);
           if(attendeeList.size()==900){
              ListOfListAttendees.add(attendeeList);
              attendeeList = new List<BLN_Attendees_BAL.inncls>(); 
            }
           
         }
         ListOfListAttendees.add(attendeeList);
           
              for(order__c ord : ordDao.order(orderIds)){
                  mapidWithOrders.put(ord.id,ord);
              }               
          
     
         for(order_item__c ord : orderItemDao.getTicketsOfperticularOItemList(orderItemids)){
            mapitemWithId.put(ord.id,ord);
         }
         
                  
         for(GN_User__c gnu : guDAO.getGnuserList(GnuserList)){
            mapguIdWithGNU.put(gnu.id,gnu); 
         }
         
        myTicketsBal.mapticWithId = mapticWithId;
        myTicketsBal.mapguIdWithGNU =mapguIdWithGNU;
        system.debug('EEEEEEEEEEEEEEEE '+mapitemWithId );
        myTicketsBal.mapitemWithId =mapitemWithId ;
        countryStates();
        statesBasedOnCountry();
      }
    
     public PageReference SaveGuests() {
       myTicketsBal.SaveGuests();
       mainMethod();
        return null;
    }

    public void deleteAttendee(){
       myTicketsBal.cancelPerticularGuestsTic();
       mainMethod();
    
    }
    
    
    public boolean orddetailbool {get;set;}
    public List<order__c> ValuesOfseletedorder{get;set;}
    
      public PageReference orderDetails() {
         string ordIdva = Apexpages.currentPage().getPArameters().get('orderIdparam');
        
         
         orddetailbool =true;
        ValuesOfseletedorder = new List<order__c>();
        ValuesOfseletedorder.add(mapidWithOrders.get(ordIdva));
        return null;
    }


   public void cancelOrdDetail(){
      orddetailbool =false;
   }
   
   
  
    
    //Arindam code for print
 public BLN_BadgeTemplate_Styles__c btstyle{get;set;}
   public Badge bg{get;set;}
   public List<Style> elems{get;set;}
    public void parseBadge(String bdg)
   {
     system.debug('uuuuunnnnnnn '+bdg);
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
      system.debug('nnnnnniiiiiiii '+elem);
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
//end of code

//Code to print the badge for selected attendees
public Bln_Event__c evlogo{get;set;}
public List<Ticket__c> printtickets{get;set;}

public PageReference genpdf() {



List<String> packageids=new List<String>();
 String idInClause = '(\'';
 BLn_Quick_Registration_BAL qb=new BLn_Quick_Registration_BAL();
      for(List<BLN_Attendees_BAL.inncls> tclist:ListOfListAttendees)
      {
          for(BLN_Attendees_BAL.inncls tc:tclist)
          {
              if(tc.selectCheckBox==true)
              {
                   if(tc.ticket.badges__r.size()==0&&tc.ticket.Badge_ID__c==null&tc.ticket.Item_Type__r.name!='Package')
                   qb.generateBadge(tc.ticket.badge_label__c,tc.ticket.id,'');
                   
                   if(tc.ticket.item_pool__r.item_type__r.Name!='Package')
                   idInClause += tc.ticket.Id+ '\',\'';
                   else
                   {
                     boolean flag=true;
                     for(Ticket__c childtk:[select id,name,Badge_ID__c,Item_Pool__c,Item_Pool__r.Item_type__r.name,Parent_ID__c from Ticket__c where Parent_ID__c=:tc.ticket.Id and Item_Pool__r.Item_type__r.name='Admissions' and Badge_ID__c!=null])
                     {
                         idInClause += childtk.Id+ '\',\'';
                         flag=false;
                     }
                     if(flag==true&&tc.ticket.badges__r.size()==0&&tc.ticket.Badge_ID__c==null){
                     qb.generateBadge(tc.ticket.badge_label__c,tc.ticket.id,'');
                     }
                     if(flag==true)
                     idInClause += tc.ticket.Id+ '\',\'';
                     
                     
                   }
              }
          }
      }
     //if no attendees selected 
     if(idInClause.length()<4)
     return null;
      
      
      
      idInClause  = idInClause.substring(0,idInClause.length()-2);
         idInClause += ')';
         
        String q = 'Select First_Name__c,Last_Name__c,Company__c,order__r.id,item__r.item_Name__c,(select id,name,item__r.item_Name__c,Item_type__r.name,Item_pool__r.Item_Pool_Name__c from badgeparentids__r),Badge_Label__c,Badge_ID__c,Badge_ID__r.name,(select id,name,Badge_Label__c from badges__r where cancel_time__c=null and Exp_time__c=null limit 1),order__r.Name,Client_Company__r.Name,Name,Item_Type__r.Name ,Client_GN_User__c,Client_GN_User__r.user__r.MobilePhone,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Client_GN_User__r.Email__c,Order_Item__c,event__c,Parent_ID__c   From Ticket__c where id in ' + idInClause+' and badgeparentid__c=null';
        printtickets=Database.query(q); 
        
       
  btstyle=[select BadgeName__c,Event__c,FirstRowElement__c,SecondElement__c,ThirdElement__c,FourthElement__c,FifthElement__c,SixthElement__c,SeventhElement__c,EightthElement__c,ninthelement__c from BLN_BadgeTemplate_Styles__c where Event__c=:selectedEvent and name=:selectedbdtemname  limit 1];
  
   evlogo=[select id,name,logo_url__c from Bln_Event__c where id=:selectedEvent];  
      //Arindam code
      //Parse Badge Name
    //if(btstyle.BadgeName__c!=null){    
        String badgename=btstyle.BadgeName__c;
        parseBadge(badgename.substring(0,badgename.length()-1));
    //}else{}
    
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
    if(btstyle.SixthElement__c!=null&&btstyle.SixthElement__c != '')
    parseElement(btstyle.SixthElement__c);
    if(btstyle.SeventhElement__c!=null&&btstyle.SeventhElement__c != '')
    parseElement(btstyle.SeventhElement__c);
    if(btstyle.EightthElement__c!=null&&btstyle.EightthElement__c != '')
    parseElement(btstyle.EightthElement__c);
    if(btstyle.ninthelement__c!=null&&btstyle.ninthelement__c != '')
    parseElement(btstyle.ninthelement__c);
      //end
     
      
      if(selectedprinter=='Avery'){
     pagereference pg = page.BLN_averylabel;
          pg.setredirect(false);
         return pg;}
         else if(selectedprinter=='Zebra'){
      pagereference pg = page.BLN_zebralabel;
          pg.setredirect(false);
         return pg;}
         else if(selectedprinter=='Brother'){
      pagereference pg = page.BLN_brotherlabel;
          pg.setredirect(false);
         return pg;}
         else
         return null;
  
    
 }

  public List<BLN_BadgeTemplate_Styles__c> Bdstyles {get ; set ;}
 public LIST<selectoption> bdstyleslist {get ; set ;}
 public string selectedbdtemname {get;set;}
public PageReference findtemplate() {
     bdstyleslist = new  LIST<selectoption> ();
     if(selectedprinter =='Avery')
     Bdstyles = [select id,Name,badge_type__c,Module__c from BLN_BadgeTemplate_Styles__c where Event__r.id =: selectedEvent and badge_type__c='Zebra' and Module__c like '%Attendee Registration%' ];
     else
     Bdstyles = [select id,Name,badge_type__c,Module__c from BLN_BadgeTemplate_Styles__c where Event__r.id =: selectedEvent and badge_type__c=:selectedprinter and Module__c like '%Attendee Registration%'];
    for(BLN_BadgeTemplate_Styles__c BTS : Bdstyles ){
    bdstyleslist.add(new selectoption(BTS.Name,BTS.Name));
    }
        return null;
    }


    public List < selectoption > getPrinterlist() {
      List < selectoption > Option = new List < selectoption > ();
     Option.add(new selectoption('Avery', 'Avery'));
     Option.add(new selectoption('Zebra', 'Zebra'));
     Option.add(new selectoption('Brother', 'Brother'));
     return option;
    }


    public String selectedprinter { get; set; }
    
    
    //Ticket to merge with options
    
    public String selectedtickets{get;set;}
    public String selectedmergebadgelabel{get;set;}
    public List < selectoption > mergeticketlist{get;set;}
    
   
     public pagereference getTicketToMergeList() {
       
          mergeticketlist= new List < selectoption > ();
         for(List<BLN_Attendees_BAL.inncls> tclist:ListOfListAttendees)
      {
          for(BLN_Attendees_BAL.inncls tc:tclist)
          {
              if(tc.selectCheckBox==true)
              { 
               mergeticketlist.add(new selectoption(tc.ticket.Id,'[Ticket Id: '+tc.ticket.Name+'] [Ticket Name: '+tc.ticket.item__r.item_Name__c+']'));
             }}}
           
          
        return null;
    } 
    
    
    //merge badge
    public PageReference mergeBadge() {
         
        System.debug('selectedtickets '+selectedtickets);  
        
        //cancel badge
          String idInClause = '(\'';

         for(List<BLN_Attendees_BAL.inncls> tclist:ListOfListAttendees)
      {
          for(BLN_Attendees_BAL.inncls tc:tclist)
          {
              if(tc.selectCheckBox==true)
              { 
               idInClause += tc.ticket.Id+ '\',\'';

           }}}

         idInClause  = idInClause.substring(0,idInClause.length()-2);
         idInClause += ')';
         
        String q = 'select id,name,cancel_time__c,Badge_Label__c from Badge__c where ticket_id__c in ' + idInClause +' and cancel_time__c=null and Exp_time__c=null';
        List<Badge__c> badges=Database.query(q);
        For(integer i=0;i<badges.size();i++)
        {
          badges[i].cancel_time__c=System.now();           
        } 
        update badges;
        
        //Create badge for the First Ticket and associate all other tickets with that badge
         q = 'select id,name,Badge_Label__c,Badge_ID__c from Ticket__c where id in ' + idInClause+' and id!=\''+selectedtickets+'\'';        
         List<Ticket__c> tckts=Database.query(q);        
                    Badge__c bg=new Badge__c();
                    //bg.badge_label__c=tckts[0].badge_label__c;
                    bg.ticket_id__c=selectedtickets;
                    BLN_Badge_DAO bdgdao=new BLN_Badge_DAO();
                   
        BLN_StatusMessage bdgMsg =  bdgdao.insertbadge(bg);
           
              if(bdgMsg .successBool){
          
                 String badgeid=bdgMsg.successId;
                 for(integer i=0;i<tckts.size();i++)
                 {
                   tckts[i].badgeparentid__c=selectedtickets;
                 }
                 update tckts;
                              
              }
              return null;
    }
    
    
    
     public String selectedunmergetickets { get; set; }
    public PageReference cancelBadge() {
     
         
        String q = 'select id,name,cancel_time__c,Badge_Label__c from Badge__c where ticket_id__c =\'' + selectedunmergetickets +'\' and cancel_time__c=null and Exp_time__c=null';
        List<Badge__c> badges=Database.query(q);
       
        
        For(integer i=0;i<badges.size();i++)
        {
          badges[i].cancel_time__c=System.now();           
        } 
                update badges;
        
        BLN_Quick_Registration_BAL qb=new BLN_Quick_Registration_BAL();
        
        List<Ticket__c> nullbadgeparentid=new List<Ticket__c>();
        
        for(Ticket__c tc:[Select id,name,(select id,name,badgeparentid__c,Badge_Label__c,item__r.item_Name__c from badgeparentids__r),Badge_Label__c,Badge_ID__c from Ticket__c where id=:selectedunmergetickets])
        {
        qb.generateBadge(tc.Badge_Label__c,tc.id,'');
           
           for(integer i=0;i<tc.badgeparentids__r.size();i++)
           {
               qb.generateBadge(tc.badgeparentids__r[i].Badge_Label__c,tc.badgeparentids__r[i].id,'');
              
               nullbadgeparentid.add(new Ticket__c(id=tc.badgeparentids__r[i].id,badgeparentid__c=null));
               
           }
        
        }
        
        update nullbadgeparentid;
        
       return null;
    }
    
    public List<selectoption> unmergelist{get;set;}
    public PageReference getMergeList() {
           unmergelist= new List < selectoption > ();
         for(List<BLN_Attendees_BAL.inncls> tclist:ListOfListAttendees)
      {
          for(BLN_Attendees_BAL.inncls tc:tclist)
          {
              if(tc.ticket.badgeparentid__c==null&&tc.ticket.badgeparentids__r.size()!=0)
              { 
               unmergelist.add(new selectoption(tc.ticket.Id,tc.ticket.Name));
               

           }}}
           return null;
    }
    
    
    public List<selectoption> packagelist{get;set;}
    public String selectedpackagetickets { get; set; }
     public PageReference getPackageList() {
         packagelist= new List < selectoption > ();
         for(List<BLN_Attendees_BAL.inncls> tclist:ListOfListAttendees)
      {
          for(BLN_Attendees_BAL.inncls tc:tclist)
          {
              if(tc.ticket.item_pool__r.item_type__r.Name=='Package')
              { 
               packagelist.add(new selectoption(tc.ticket.Id+';'+tc.ticket.item_pool__c,'[Ticket Id: '+tc.ticket.Name+'] [Ticket Name: '+tc.ticket.item__r.item_Name__c+']'));
               

           }}}
           return null;
    }

    
    public PageReference splitpackage() {
            BLN_Quick_Registration_BAL qb=new BLN_Quick_Registration_BAL();
            
    LIST<string> ticketidandpoolid= selectedpackagetickets.split(';');
    String ticketid=ticketidandpoolid[0];
    String poolid=ticketidandpoolid[1];
    System.debug('Split package'+ticketidandpoolid[0]+' '+ticketidandpoolid[1]);
    //Get all the admission tickets
    List<Ticket__c> admticket=[select id,name,Badge_Label__c,Item_Pool__c,Item_Pool__r.Item_type__r.name,Parent_ID__c from Ticket__c where Parent_ID__c=:ticketidandpoolid[0] and Item_Pool__r.Item_type__r.name='Admissions'];
    //Generate badges for admission tickets
    for(integer i=0;i<admticket.size();i++)
           {
               qb.generateBadge(admticket[i].Badge_Label__c,admticket[i].id,'');
               }
               
     //Get all the line items pool except admission
    List<Item_Pool__c> otherpool=[select id,name,Addon_Parent__c,Item_Count__c,Item_type__r.name from Item_Pool__c where Addon_Parent__c=:ticketidandpoolid[1] and Item_type__r.name!='Admissions'];
    for(integer i=0;i<otherpool.size();i++)
           {
                //get addontickets for that pool
                List<Ticket__c> child=[select id,name,badgeparentid__c,Parent_ID__c,Item_Pool__c from Ticket__c where Parent_ID__c=:ticketidandpoolid[0] and Item_Pool__c=:otherpool[i].id];
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
    
    
        return null;
    }

public class packagebreak
{
  public String Ticket{get;set;}
   public List<String> LineItems{get;set;}
   
} 
 public List<packagebreak> pbs{get;set;}
 public PageReference previewpackage()
 {
 BLN_Quick_Registration_BAL qb=new BLN_Quick_Registration_BAL();
 pbs=new List<packagebreak>();
            
    LIST<string> ticketidandpoolid= selectedpackagetickets.split(';');
    String ticketid=ticketidandpoolid[0];
    String poolid=ticketidandpoolid[1];
   
    //Get all the admission tickets
    List<Ticket__c> admticket=[select id,name,item__r.item_Name__c,Badge_Label__c,Item_Pool__c,Item_Pool__r.Item_type__r.name,Parent_ID__c from Ticket__c where Parent_ID__c=:ticketidandpoolid[0] and Item_Pool__r.Item_type__r.name='Admissions'];
   for(integer i=0;i<admticket.size();i++)
           {
              packagebreak p=new packagebreak();
              p.Ticket=admticket[i].Item_Pool__r.Item_type__r.name;
              p.LineItems=new List<String>();
               pbs.add(p);
               }
               
     //Get all the line items pool except admission
    List<Item_Pool__c> otherpool=[select id,name,Addon_Parent__c,Item_Count__c,Item_type__r.name from Item_Pool__c where Addon_Parent__c=:ticketidandpoolid[1] and Item_type__r.name!='Admissions'];
    
    for(integer i=0;i<otherpool.size();i++)
           {
                //get addontickets for that pool
                List<Ticket__c> child=[select id,name,badgeparentid__c,Parent_ID__c,Item_Pool__c,Item_Pool__r.Item_Pool_Name__c from Ticket__c where Parent_ID__c=:ticketidandpoolid[0] and Item_Pool__c=:otherpool[i].id];
                Integer j=0;
                for(;j<child.size();j++)
                {
                    if(j==admticket.size())
                    break;
                   child[j].badgeparentid__c=admticket[j].id;
                  
                   pbs[j].LineItems.add(child[j].Item_Pool__r.Item_Pool_Name__c);
                  
                   
                }
                for(Integer rem=j;rem<child.size();rem++)
                {
                   child[rem].badgeparentid__c=admticket[admticket.size()-1].id;
                   pbs[admticket.size()-1].LineItems.add(child[rem].Item_Pool__r.Item_Pool_Name__c);
                }
                
               
               }
    
    System.debug('pbs '+pbs);
    return null;
   }
   
   // ----------------------------------------- Actions on order details popup --------------------------------------   
  public Ticket__c addGuest{get;set;}
  public boolean displyAddGuest{get;set;} 
  public string companyName {get;set;}
  public GN_User__c gnUser{get;set;}
  public Company__c comp {get;set;}
  public Company_Ext__c compext {get;set;}
  public MAP<id,List<Reg_Setting__c>> settingsForbuyerMAp{get;set;}
  public  List<Reg_Setting__c> settingsForbuyer{get;set;} //To display buyer settings
  public UC_Role__c ucrole{get;set;}
   public List<surveyCls> ticketLevelQuestions {get;set;}
  public  List<surveyCls> eventLevelQuestions {get;set;}
  
  
    // disply edit guest  pop up
    public PageReference editTicket(){
      gnUser = new GN_User__c();
      addGuest = new Ticket__c ();
      ucrole = new UC_Role__c();
      checkNAICSforEdit='';
      
      settingsForbuyerMAp = new MAP<id,List<Reg_Setting__c>>();
      settingsForbuyer = new List<Reg_Setting__c>();
      
       string ticketId = Apexpages.currentPage().getParameters().get('TicketIdparam');
       addGuest=  mapticWithId.get(ticketId);
       gnUser = mapguIdWithGNU.get(addGuest.Client_GN_User__c);
       BLN_RegistrationSettings_BAL RegSettingsBAL = new BLN_RegistrationSettings_BAL();
      
          
        SET<id> ticketIdsset = new SET<id>();
        RegSettingsBAL = new BLN_RegistrationSettings_BAL();
        ticketIdsset.add(addGuest.item__c);
        
      if(ticketIdsset.size() >0){  
     
        settingsForbuyerMAp= RegSettingsBAL.getTicketSettings(ticketIdsset,selectedEvent);
        
        system.debug('YYYYYYYYYYYY  '+settingsForbuyerMAp);
          if(settingsForbuyerMap.size()>0){
             settingsForbuyer.addAll(settingsForbuyerMap.get(addGuest.item__c));
            }
       }  
       
       
       comp = new Company__c(); 
       compext = new Company_Ext__c();
       string compid = '';
       try{
       compid = [select id,company__c,Client_Company__c,Client_GN_User__c from Ticket__c where id=:ticketId].Client_Company__c;
       }catch(exception ed){}
       
     if(compid!=''){
       try{
       comp =[select id,name,Description__c,Website_URL__c From Company__c Where Id=:compid];
       compext  = [select id,Blog_URL__c,Business_Address1__c,Business_Address2__c,Business_City__c,BLN_Business_Country__c,BLN_Business_State__c,Business_Zipcode__c,Company__c,Duns_Number__c,
       Established_Date__c,Keywords__c,Number_Of_Employees__c,Primary_Business_Category__c,Primary_NAICS_Code__c,Revenue__c,Secondary_Business_Category__c,Secondary_NAICS_Code__c,Tax_Id__c,Work_Phone__c from Company_Ext__c where company__c=:compid];
       companyName = addGuest.Client_company__r.Name;    
       
       checkNAICSforEdit= '';
                checkNAICSforEdit= '$$$$';
       if(compext.Primary_NAICS_Code__c != NULL){
           checkNAICSforEdit += compext.Primary_NAICS_Code__c;
       }
       if(compext.Secondary_NAICS_Code__c != NULL){
           checkNAICSforEdit += compext.Secondary_NAICS_Code__c;
       } 
       
       
       }catch(exception er){}
     }
     
     
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
    system.debug('  CHECK NAICS CODE EDIT  '+checkNAICSforEdit);
      return null;
    }
  
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
  
    public void closeGuest(){
    displyAddGuest= false;
     
    }
    
     // ------------------------------------------------------------------------------------- States & Countries Start ----------------------------------------------------------------------------------    
   
   public LIST<Country__c> country{get; set;}
   public LIST<State__c> states{get; set;}
    public void countryStates(){ 
        country = new LIST<Country__c>();
        countryOptions= new LIST<SelectOption>();
        //string ticketId = Apexpages.currentPage().getParameters().get('TicketIdparam');
        //String cmnyID=[select id,company__c,Client_Company__c,Client_GN_User__c from Ticket__c].Client_Company__c;
        for(Country__c c: [SELECT ID, NAME, Short_Name__c, Long_Name__c, Order__c FROM Country__c ORDER BY Order__c]){
            countryOptions.add(new SelectOption(c.id, c.Long_Name__c));
            if(c.Short_Name__c == 'US'){
                selectedCountry = c.id;
            }
        }
        StateOptions = new LIST<SelectOption> ();   
    }

    public void statesBasedOnCountry(){
        system.debug('Selected Country '+selectedCountry);
        stateOptions= new LIST<SelectOption> ();   
    
        for(State__c s: [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c, Order__c FROM State__c WHERE Country__c =: selectedCountry]){
            stateOptions.add(new SelectOption(s.id,s.Long_Name__c));
        }
        //return stateOptions;
    }
// --------------------------------------------------------------------------------------- States & Countries End ----------------------------------------------------------------------------------
    
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
}