/**
 Author : By Phani 
 Purpose : Test class for registration page
 Date : 28/01/2015 
 */
 
@isTest
private class Test_BLN_Registrationnew {

    static testMethod void myUnitTest() {
        Test_BLN_ReUse_EventsEditCon tcon = new Test_BLN_ReUse_EventsEditCon();
        Test_BLN_ReUse_EventsEditCon.Testmethod_BLN_ReUse_EventsEditCon();
        system.debug('AAAAAAAAAAAAAAAAAAAAa '+Test_BLN_ReUse_EventsEditCon.eventid);
          string eventid =  Test_BLN_ReUse_EventsEditCon.eventid;
           
        // Inserting item type with admission
        Item_Type__c insertItemType= new Item_Type__c();
        insertItemType.Name= 'Admissions';
        insertItemType.Badge_Label__c= 'BadgeLabel';
        insertItemType.Order__c=1;
        insertItemType.Add_On__c= False;
        insertItemType.Unlimited__c=false;
        insertItemType.Badgable__c = 'B - Badge';
        
        insert insertItemType;
        
        // inserting pool for admission ticket 
        Item_Pool__c insertItemPool= new Item_Pool__c();
        insertItemPool.Event__c= eventid;
        insertItemPool.Item_Pool_Name__c= 'Admission';
        insertItemPool.item_type__c= insertItemType.id;
        insertItemPool.Item_Count__c= 12;
       // insertItemPool.Addon_Parent__c= insertItemType.id;
        insertItemPool.Addon_Count__c= 0;
        insertItemPool.Ticket_Settings__c   = 'Collect info from Buyers only';
        insert insertItemPool;
        
       // Inserting item
        BLN_Item__c insertItem= new BLN_Item__c();
        insertItem.item_name__c= 'Admission';
        insertItem.Item_Pool__c= insertItemPool.id;
        insertItem.item_type__c= insertItemType.id;
        insertItem.Visibility__c  =true;
        insertItem.Event__c= eventId;
        insertItem.price__c= 22.50;
        insertItem.Payment__c= 'Paid';
        insertItem.item_count__c= 12;
        insertItem.Taxable__c = false;
        insertItem.sale_start__c=System.today()-1;
        insertItem.sale_end__c=System.today()+2;
        insertItem.Ticket_Settings__c   = 'Collect info from Buyers only';
        insert insertItem;
        
       // insert promotion
        Promotion__c pro = new Promotion__c();
        pro.Promo_Code__c = 'Basic';
        pro.Promotion_Type__c = 'Basic Promo codes';
        pro.Condition_Type__c ='Quantity Threshold';
        pro.Discount_Type__c ='Percent';
        pro.Discount_Value__c =0.0;
        pro.Eff_TimeStamp__c = system.today();
        pro.Event__c = eventid;
        pro.Exp_TimeStamp__c =system.today()+1;
        pro.I_Max_Count__c =12;
        pro.Status__c ='active';
        pro.T_Max_Count__c  =12;
        pro.T_Used_Count__c =0;
        pro.Type__c = 'Promo code';
        insert pro;
        
         PGateway_Type__c ptype = new PGateway_Type__c();
		ptype.Online_Flag__c = true;
		ptype.Onsite_Flag__c =true;
		ptype.Name = 'Cash';
		insert ptype;
        
        Pay_Gateway__c paygatecom = new Pay_Gateway__c();
        paygatecom.Company__c = Test_BLN_ReUse_EventsEditCon.CompanyInfo.id;
        paygatecom.PGateway_Type__c = ptype.id;
        insert paygatecom;
        
        Event_Pay_Gateway__c epay = new Event_Pay_Gateway__c();
        epay.Events__c = eventid;
        epay.Pay_Gateway__c = paygatecom.id;
        epay.Registration_Type__c = 'Online';
        insert epay;
        
        
        
       // insert item promocode
       Item_Promotion__c itp = new Item_Promotion__c();
       itp.Buy_Item__c = insertItem.id;
       itp.Item_Discount_Type__c = 'Percent';
       itp.Item_Discount_Value__c = 50;
       itp.Promotion__c = pro.id;
       insert itp;  
         
        
         
                 
         
        pageReference pageRef = page.BLN_Registrationnew;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', Test_BLN_ReUse_EventsEditCon.eventid);
        BLN_Registrationnewcon regcon = new BLN_RegistrationnewCon();
        regcon.itqnty = '1';
        regcon.itpoolid=insertItemPool.id;
        regcon.itlabel = 'All';
        regcon.itoldqnty ='0';  
        regcon.applyPromocode();
        regcon.promocode = 'Basic';
        regcon.RegItemList[0].TabLabel  ='All';
        
        regcon.applyPromocodenew();
        regcon.orderNow();
        
        //regcon.completeRegistration();
    }
}