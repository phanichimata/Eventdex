@isTest
public class Test_BLN_PromoCodecon{
    static testmethod void Testmethod_BLN_PromoCodecon(){
    
    User U= new User();
    globalForTestClass globalTest= new globalForTestClass();
    U= globalTest.createUser();
    
    system.runas(U){
            
            User userForGN= new User();
        userForGN= globalTest.createUserForGNUser();
        
        Company__c companyInfo= new Company__c();
        companyInfo= globalTest.createCompany(u.Companyname);
        
        Currency__c currenyInfo= new Currency__c();
        currenyInfo= globalTest.createCurrency();             
        
        Country__c countryInfo= new Country__c();
        countryInfo= globalTest.createCountry(currenyInfo.Id);  
        
        State__c stateInfo= new State__c ();
        stateInfo= globalTest.createState(countryInfo.Id);
        
        GN_User__c  gnUser= new GN_User__c();
        gnUser= globalTest.createGNUser(userForGN,countryInfo.Id, Stateinfo.Id);
        
        BLN_Event__c eventInfo= new  BLN_Event__c();
        eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id); 
        
        Order__c insertOrder1= new Order__c();
        insertOrder1= globalTest.createOrder(gnUser.Id, userForGN.id, companyInfo.Id, eventInfo.Id, currenyInfo.Id);
        
        Item_Type__c itemType= new Item_Type__c();
        itemType= globalTest.createItemType();
        
        BLN_Track__c trck=new BLN_Track__c();
        trck=globalTest.createTrack(eventInfo.Id);
        
        Item_Pool__c ItemPool= new Item_Pool__c();
        ItemPool= globalTest.createItemPool(eventInfo.id, itemType.Id, NULL,trck.id);
        
        Item_Pool__c ItemPool2= new Item_Pool__c();
        ItemPool2= globalTest.createItemPool(eventInfo.id, itemType.Id, ItemPool.Id,trck.id);
        
        BLN_Item__c item= new BLN_Item__c();
        item= globalTest.createItem(ItemPool.Id, itemType.Id, eventInfo.id);
                   
        Order_Item__c orderItem= new Order_Item__c();
        orderItem= globalTest.createOrderItem(item.Id, insertOrder1.Id, null, currenyInfo.Id);
            
            Promotion__c promotion1= new Promotion__c();
            promotion1= globalTest.createPromotion(eventInfo.id, 'Basic Promo1', 'Basic Promo codes', 'Percent');
            promotion1= globalTest.createPromotion(eventInfo.id, 'Basic Promo2', 'Basic Promo codes', 'Amount');
            promotion1= globalTest.createPromotion(eventInfo.id, 'Basic Promo3', 'Basic Promo codes', 'Quantity');
            
            Ticket__c ticket= new Ticket__c();
            ticket= globalTest.createTicket(eventInfo.id, item.Id, itemPool.Id, itemType.Id, insertOrder1.Id, gnUser.Id);
            
            cookie  counter = new Cookie('counter',eventInfo.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});            
            
            BLN_PromoCodecon promoCodeConTest=new BLN_PromoCodecon();
            
            ApexPages.CurrentPage().getParameters().put('chkArray',item.Id);            

            promoCodeConTest.promotionslist.add(new Promotion__c(Promotion_Type__c = 'Basic Promo codes', Name ='Basic Promo Codes Test', Promo_Code__c ='JKH6576GF', Eff_TimeStamp__c =System.today(), Exp_TimeStamp__c=System.today()+4, Condition_Min_No__c=20, Discount_Type__c='Percent'));            
            promoCodeConTest.itempromotionslist.add(new item_Promotion__c(Buy_Item_Quantity__c =2, Item_Discount_Value__c=2));
            promoCodeConTest.savepromotion();
            
            promoCodeConTest.promotionslist.add(new Promotion__c(Promotion_Type__c = 'Buy Something Get Something', Name ='Buy Something Get Something Test', Promo_Code__c ='JKH6576GF', Eff_TimeStamp__c =System.today(), Exp_TimeStamp__c=System.today()+4, Condition_Min_No__c=20, Discount_Type__c='Percent'));            
            promoCodeConTest.itempromotionslist.add(new item_Promotion__c(Buy_Item_Quantity__c =2, Item_Discount_Value__c=2,Free_Item_Quantity__c =1));
            promoCodeConTest.savebuyxgetxpromotion();
            
            Apexpages.Currentpage().getparameters().put('promo',promotion1.id );
            
            
            promoCodeConTest.promotionslist.add(new Promotion__c(Promotion_Type__c = 'Basic Promo codes', Name ='Basic Promo Codes Test', Promo_Code__c ='JKH6576GF', Eff_TimeStamp__c =System.today(), Exp_TimeStamp__c=System.today()+4, Condition_Min_No__c=20, Discount_Type__c='Percent'));            
            promoCodeConTest.itempromotionslist.add(new item_Promotion__c(Buy_Item_Quantity__c =2, Item_Discount_Value__c=2));
            promoCodeConTest.savepromotion();
            
            promoCodeConTest.saveorderpromotion();
            
            promoCodeConTest.itempromotionslist.add(new item_Promotion__c(Promotion__c=promotion1.Id,Buy_Item__c=item.Id,Buy_Item_Quantity__c =2, Item_Discount_Value__c=2,Free_Item_Quantity__c =1,Item_Discount_Type__c='Parcent',Free_Item__c=item.id));
            //promoCodeConTest.itempromotionslist.add(new item_Promotion__c(Promotion__c=promotionslist[0].Id,Buy_Item__c=item.Id,Buy_Item_Quantity__c =2, Item_Discount_Value__c=2,Free_Item_Quantity__c =1,Item_Discount_Type__c='Parcent',Free_Item__c=item.id));
            
            Apexpages.Currentpage().getparameters().put('promoid',promotion1.Promo_Code__c);
            promoCodeConTest.editpromo();
            
            Apexpages.Currentpage().getparameters().put('promoid',promotion1.Promo_Code__c );
            Apexpages.Currentpage().getparameters().put('promousedcount',string.valueOf(1));
            promoCodeConTest.DeletePromotion();
            
            promoCodeConTest.gettypeoptions();
            promoCodeConTest.getstatusoptions();
            promoCodeConTest.promotionslist();
            promoCodeConTest.getpromotionslist();
            promoCodeConTest.discountmenu();            
            promoCodeConTest.getitems();
            promoCodeConTest.geteventdetails();
            promoCodeConTest.createbasicpromotion();
            promoCodeConTest.createbuyxgetypromotion();
            
            promoCodeConTest.additems();            
            
            promoCodeConTest.addgetitems();
            promoCodeConTest.Addrangemethod();
            promoCodeConTest.deleteitempromoline();
            promoCodeConTest.deletefreeitempromoline();
            promoCodeConTest.deletespendmoreline();
            
            promoCodeConTest.cancelmethod();
            promoCodeConTest.createpromotion();
            promoCodeConTest.createorderpromotion();
            
            BLN_PromoCodecon promoCodeConTest2=new BLN_PromoCodecon();
                        
            Apexpages.Currentpage().getparameters().put('promoid',promotion1.Promo_Code__c );
            Apexpages.Currentpage().getparameters().put('promousedcount',string.valueOf(4));
            promoCodeConTest2.promousedcount=0;
            promoCodeConTest2.DeletePromotion();
            
            promoCodeConTest2.failuremessageset=new Set<String>();
            promoCodeConTest2.failuremessageset.clear();
            promoCodeConTest2.additems();
            
            promoCodeConTest2.failuremessageset=new Set<String>();
            promoCodeConTest2.failuremessageset.clear();
            promoCodeConTest2.addgetitems();
            
            promoCodeConTest2.editPromobool=true;
            promoCodeConTest2.saveorderpromotion();
            
            promoCodeConTest2.gettypeoptions();
            promoCodeConTest2.getstatusoptions();
            promoCodeConTest2.promotionslist();
            promoCodeConTest2.getpromotionslist();
            promoCodeConTest2.discountmenu();
            
            promoCodeConTest2.selectedeventid=eventinfo.id;
            promoCodeConTest2.getitems();            
            
            promoCodeConTest2.geteventdetails();
            promoCodeConTest2.createbasicpromotion();
            promoCodeConTest2.createbuyxgetypromotion();
            
            promoCodeConTest2.editpromobool=true;
            promoCodeConTest2.cancelmethod(); 
            
            promoCodeConTest2.promotionslist.add(new Promotion__c(Promotion_Type__c = 'Multi-Items Discount', Name ='Basic Promo Codes Test', Promo_Code__c ='JKH6576GF', Eff_TimeStamp__c =System.today(), Exp_TimeStamp__c=System.today()+4, Condition_Min_No__c=20, Discount_Type__c='Percent'));            
            promoCodeConTest2.itempromotionslist.add(new item_Promotion__c(Buy_Item_Quantity__c =2, Item_Discount_Value__c=2));
            //promoCodeConTest2.promotionslist[0].Promotion_Type__c ='Multi-Items Discount';
            Promotion__c promotion2= new Promotion__c();
            promotion2= globalTest.createPromotion(eventInfo.id, 'Multi-Items Discount Promo1', 'Multi-Items Discount', 'Percent');
            promotion2= globalTest.createPromotion(eventInfo.id, 'Multi-Items Discount Promo2', 'Multi-Items Discount', 'Amount');
            promotion2= globalTest.createPromotion(eventInfo.id, 'Multi-Items Discount Promo3', 'Multi-Items Discount', 'Quantity');
            Apexpages.Currentpage().getparameters().put('promo',promotion2.id );
            Apexpages.Currentpage().getparameters().put('promoid',promotion2.Promo_Code__c);
            promoCodeConTest2.editpromo();
            
            BLN_PromoCodecon promoCodeConTest3=new BLN_PromoCodecon();
            promoCodeConTest3.promotionslist.add(new Promotion__c(Promotion_Type__c = 'Spend More Save More', Name ='Basic Promo Codes Test', Promo_Code__c ='JKH6576GF', Eff_TimeStamp__c =System.today(), Exp_TimeStamp__c=System.today()+4, Condition_Min_No__c=20, Discount_Type__c='Percent'));            
            promoCodeConTest3.itempromotionslist.add(new item_Promotion__c(Buy_Item_Quantity__c =2, Item_Discount_Value__c=2));
            //promoCodeConTest3.promotionslist[0].Promotion_Type__c ='Spend More Save More'; 
            
            Promotion__c promotion3= new Promotion__c();
            promotion3= globalTest.createPromotion(eventInfo.id, 'Buy Something Get Something Promo1', 'Buy Something Get Something', 'Percent');
            promotion3= globalTest.createPromotion(eventInfo.id, 'Buy Something Get Something Promo2', 'Buy Something Get Something', 'Amount');
            promotion3= globalTest.createPromotion(eventInfo.id, 'Buy Something Get Something Promo3', 'Buy Something Get Something', 'Quantity');
            Apexpages.Currentpage().getparameters().put('promo',promotion3.id );
            Apexpages.Currentpage().getparameters().put('promoid',promotion3.Promo_Code__c);
            promoCodeConTest3.editpromo();
                 
            BLN_PromoCodecon promoCodeConTest4=new BLN_PromoCodecon();
            promoCodeConTest4.promotionslist.add(new Promotion__c(Promotion_Type__c = 'Buy Something Get Something', Name ='Basic Promo Codes Test', Promo_Code__c ='JKH6576GF', Eff_TimeStamp__c =System.today(), Exp_TimeStamp__c=System.today()+4, Condition_Min_No__c=20, Discount_Type__c='Percent'));            
            promoCodeConTest4.itempromotionslist.add(new item_Promotion__c(Buy_Item_Quantity__c =2, Item_Discount_Value__c=2));
            //promoCodeConTest4.promotionslist[0].Promotion_Type__c ='Buy Something Get Something';
            
            Promotion__c promotion4= new Promotion__c();
            promotion4= globalTest.createPromotion(eventInfo.id, 'Spend More Save More Promo1', 'Spend More Save More', 'Percent');
            promotion4= globalTest.createPromotion(eventInfo.id, 'Spend More Save More Promo2', 'Spend More Save More', 'Amount');
            promotion4= globalTest.createPromotion(eventInfo.id, 'Spend More Save More Promo3', 'Spend More Save More', 'Quantity');
            
            Apexpages.Currentpage().getparameters().put('promo',promotion4.id );
            Apexpages.Currentpage().getparameters().put('promoid',promotion4.Promo_Code__c);
            promoCodeConTest4.editpromo(); 
            
            promoCodeConTest4.editpromobool=true;
            promoCodeConTest4.promotionslist=new List<Promotion__c>();
            promoCodeConTest4.itempromotionslist=new List<item_Promotion__c>();
            promoCodeConTest4.freeitempromotionslist=new List<item_Promotion__c>();
            promoCodeConTest4.promotionslist.clear();
            promoCodeConTest4.itempromotionslist.clear();
            promoCodeConTest4.freeitempromotionslist.clear();
            promoCodeConTest4.savebuyxgetxpromotion();
            
            Apexpages.Currentpage().getparameters().put('promousedcount',string.valueOf(0));
            promoCodeConTest4.DeletePromotion(); 
            
                
        } 
    }
}