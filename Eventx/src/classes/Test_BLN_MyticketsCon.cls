@isTest
public class Test_BLN_MyticketsCon{
    static testmethod void Testmethod_BLN_MyticketsCon(){
        
      //  User U= new User();
        globalForTestClass globalTest= new globalForTestClass();
        //U= globalTest.createUserForGNUser();        
        
        Account acc= new Account(Name='Globalnest');
         insert acc;
    
        contact con = new contact(firstname='gn',lastname='user',AccountId=acc.id);
        insert con;
        Profile p = [select id from profile where name='Event Admin'];
        //userRole r=[SELECT ID FROM userRole WHERE name =: 'Custom Role'];   userRoleId= r.id,
        User U= new User(alias = 'gn', email='gnuser12@noemail.com', firstname= 'fngn', Phone= '9878654345',ContactId= con.Id,
                                  emailencodingkey='UTF-8',profileid = p.Id,lastname='gnuser', languagelocalekey='en_US',
                                  localesidkey='en_US',country='United States Of America', CompanyName= 'GlobalNest',
                                  timezonesidkey='America/Los_Angeles', username='gnuser12@noemail.com', Title= 'SFDC Developer');
        insert U;
            
        
        
        
        
        Currency__c currenyInfo= new Currency__c();
        currenyInfo= globalTest.createCurrency();             
            
        Country__c countryInfo= new Country__c();
        countryInfo= globalTest.createCountry(currenyInfo.Id);  
            
        State__c stateInfo= new State__c ();
        stateInfo= globalTest.createState(countryInfo.Id);
            
        GN_User__c  gnUser= new GN_User__c();
        gnUser= globalTest.createGNUser(u,countryInfo.Id, Stateinfo.Id);
             
        system.runas(U){
        
            
            Company__c companyInfo= new Company__c();
            companyInfo= globalTest.createCompany(u.Companyname);
            
            
            BLN_Event__c eventInfo= new  BLN_Event__c();
            eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id); 
            
            Order__c insertOrder1= new Order__c();
            insertOrder1= globalTest.createOrder(gnUser.Id, u.id, companyInfo.Id, eventInfo.id, currenyInfo.Id);
            
            Item_Type__c itemType= new Item_Type__c();
            itemType= globalTest.createItemType();
            
            BLN_Track__c trackInfo= new BLN_Track__c();
            trackInfo= globalTest.createTrack(eventInfo.id);
            
            Item_Pool__c ItemPool= new Item_Pool__c();
            ItemPool= globalTest.createItemPool(eventInfo.id, itemType.Id, NULL, trackInfo.id);
            
            Item_Pool__c ItemPool2= new Item_Pool__c();
            ItemPool2= globalTest.createItemPool(eventInfo.id, itemType.Id, ItemPool.Id, trackInfo.id);
            
            BLN_Item__c item= new BLN_Item__c();
            item= globalTest.createItem(ItemPool.Id, itemType.Id, eventInfo.id);
            
            Order_Item__c orderItem= new Order_Item__c();
            orderItem= globalTest.createOrderItem(item.Id, insertOrder1.Id, null, currenyInfo.Id);
        
            Promotion__c promotion= new Promotion__c();
            promotion= globalTest.createPromotion(eventInfo.id, 'promotionName', 'Basic Promo Codes', 'Percent');
            
            Item_Promotion__c itemPromotion= new Item_Promotion__c();
            itemPromotion= globalTest.createItemPromotion(item.Id, promotion.Id, 'Percent');
            
            Ticket__c ticket= new Ticket__c();
            ticket= globalTest.createTicket(eventInfo.id, item.Id, itemPool.Id, itemType.Id, insertOrder1.Id, gnUser.id);
            NAICS_Code__c nac= new NAICS_Code__c();
            nac=globalTest.createNaicsCode();
            
             PGateway_Type__c pgt= new PGateway_Type__c();
    insert pgt;
    
     Pay_Gateway__c pw= new Pay_Gateway__c(PGateway_Type__c=pgt.id,Company__c=companyinfo.id);
      insert pw;
    
    Event_Pay_Gateway__c epg= new Event_Pay_Gateway__c(Events__c =eventInfo.id,Pay_Gateway__c=pw.id,Registration_Type__c='Online');
    insert epg;
          
            cookie  counter = new Cookie('counter',eventInfo.id,null,-1,false);
           ApexPages.currentPage().setCookies(new Cookie[]{counter});
            PageReference pageRef2 = Page.BLN_Mytickets;
            Test.setCurrentPage(pageRef2);
              
            BLN_MyticketsCon myTicketRepTest= new BLN_MyticketsCon();
            myTicketRepTest.displayPermissions();
            myTicketRepTest.getRecordsForExport();
            myTicketRepTest.setRecordsForExport('Manasa');
            myTicketRepTest.onchangeEvent();
            ApexPages.CurrentPage().getParameters().put('guestindex','0');            
            myTicketRepTest.renderDetails();
            
            ApexPages.CurrentPage().getParameters().put('edform',insertOrder1.Id); 
            myTicketRepTest.displayorderEditform();
            myTicketRepTest.Saveord();
            myTicketRepTest.CloseGuests();
            myTicketRepTest.cancelTotalorder();
            myTicketRepTest.exportOrders();
            myTicketRepTest.inncurrentTickets[0].selectCheckBox= TRUE;
            myTicketRepTest.userSelectPerticularToExport();
            myTicketRepTest.renderDetailsfororder();
            myTicketRepTest.cancelOrdDetail();
            
            ApexPages.CurrentPage().getParameters().put('TicketIdparam',ticket.Id);            
            myTicketRepTest.editTicket();
           
            myTicketRepTest.SaveGuests();
            
            ApexPages.CurrentPage().getParameters().put('canordItemId',orderItem.Id);             
            myTicketRepTest.cancelDirectTicket();
            
            ApexPages.CurrentPage().getParameters().put('canticId',ticket.Id);            
           //  myTicketRepTest.cancelPerticularGuestsTic();
            myTicketRepTest.closeCan();
             myTicketRepTest.saveLogic(new user(), ticket, insertOrder1, gnUser);
             myTicketRepTest.selectedEvent = eventInfo.id;
             myTicketRepTest.statistics();

            // BLN_MyticketsCon.getCompanies('raj','rajendra.yentrapragada@globalnest');
            // BLN_MyticketsCon.getCompanies1('b','test@gmail.com');
             ApexPages.CurrentPage().getParameters().put('naicsCodes',nac.Id);             
              
               myTicketRepTest.sendNaicsCodes();
               //myTicketRepTest.paymentTypeInner();
                
                 
        }  
  
    }
}