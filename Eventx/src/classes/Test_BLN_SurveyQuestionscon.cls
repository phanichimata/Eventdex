@isTest
public class Test_BLN_SurveyQuestionscon{
    static testmethod void Testmethod_BLN_SurveyQuestionscon(){
    
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
        
        Promotion__c promotion2= new Promotion__c();
        promotion2= globalTest.createPromotion(eventInfo.id, 'Multi-Items Discount Promo1', 'Multi-Items Discount', 'Percent');
        promotion2= globalTest.createPromotion(eventInfo.id, 'Multi-Items Discount Promo2', 'Multi-Items Discount', 'Amount');
        promotion2= globalTest.createPromotion(eventInfo.id, 'Multi-Items Discount Promo3', 'Multi-Items Discount', 'Quantity');
        
        Promotion__c promotion3= new Promotion__c();
        promotion3= globalTest.createPromotion(eventInfo.id, 'Buy Something Get Something Promo1', 'Buy Something Get Something', 'Percent');
        promotion3= globalTest.createPromotion(eventInfo.id, 'Buy Something Get Something Promo2', 'Buy Something Get Something', 'Amount');
        promotion3= globalTest.createPromotion(eventInfo.id, 'Buy Something Get Something Promo3', 'Buy Something Get Something', 'Quantity');
        
        Promotion__c promotion4= new Promotion__c();
        promotion4= globalTest.createPromotion(eventInfo.id, 'Spend More Save More Promo1', 'Spend More Save More', 'Percent');
        promotion4= globalTest.createPromotion(eventInfo.id, 'Spend More Save More Promo2', 'Spend More Save More', 'Amount');
        promotion4= globalTest.createPromotion(eventInfo.id, 'Spend More Save More Promo3', 'Spend More Save More', 'Quantity');
        
        Question__c que = new Question__c();
        que=globalTest.createQuestion(eventInfo.id);
        
        Item_Question__c itemQue = new Item_Question__c();
        itemQue =globalTest.createItemQuestion(eventInfo.id,item.Id,que.Id);
        
        Answer__c ans = new Answer__c();
        ans=globalTest.createAnswer(que.Id);
        
        User_Answer__c  usrAns = new User_Answer__c();
        usrAns=globalTest.createUserAnswer(gnUser.id,itemQue.Id, ans.Id);
        
        Ticket__c ticket= new Ticket__c();
        ticket= globalTest.createTicket(eventInfo.id, item.Id, itemPool.Id, itemType.Id, insertOrder1.Id, gnUser.Id);
        
        cookie  counter = new Cookie('counter',eventInfo.id,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{counter});          
        
        BLN_SurveyQuestionscon surveyQueTest=new BLN_SurveyQuestionscon();
        ApexPages.CurrentPage().getParameters().put('editquid',que.Id);
        
        surveyQueTest.questionslist.add(new Question__c(Question_Text__c='Who are you', Answer_Type__c='Text'));
        surveyQueTest.Itemquelist.add(new Item_Question__c(Question_Level__c='Event Level',isRequired__c= True, Visibility__c= True));
        Apexpages.Currentpage().getparameters().put('chkArray', item.Id+'-');
        Apexpages.Currentpage().getparameters().put('chkreqArray', item.Id+'-');
        Apexpages.Currentpage().getparameters().put('chkvisArray', item.Id+'-');
        
        surveyQueTest.savequestion();
        
        surveyQueTest.questionslist.add(new Question__c(Question_Text__c='working', Answer_Type__c='Text'));
        surveyQueTest.Itemquelist.add(new Item_Question__c(Question_Level__c='Event Level',isRequired__c= True, Visibility__c= True));
        surveyQueTest.editquestion();
        
        Apexpages.Currentpage().getparameters().put('answeroptorder',ans.id);
        surveyQueTest.updateanswerslist();
        
        Apexpages.Currentpage().getparameters().put('delquid',itemQue.id);
        Apexpages.Currentpage().getparameters().put('queanscount',string.valueOf(1));
        surveyQueTest.delquestion();
        surveyQueTest.selectedquelevl='Ticket Level';
        surveyQueTest.itemdisplay();
        
        surveyQueTest.displayPermissions();
        surveyQueTest.geteventdetails();
        surveyQueTest.getquestionslist();
        surveyQueTest.getitems();
        surveyQueTest.getquetyps();
        surveyQueTest.getquestionlevel();
        surveyQueTest.Addquestion();
        surveyQueTest.optionslabel();
        surveyQueTest.deleteoptionline();
        surveyQueTest.cancelmethod();
        
        BLN_SurveyQuestionscon surveyQueTest2=new BLN_SurveyQuestionscon();
        surveyQueTest2.selectedtype='Scale';
        surveyQueTest2.optionslabel();
        surveyQueTest2.editquestion();
        
        surveyQueTest2.selectedquelevl='Event Level';
        surveyQueTest2.itemdisplay();
        
        surveyQueTest2.editbool=true;
        surveyQueTest2.failuremessageset = new SET<String>();
        surveyQueTest2.failuremessageset.clear();
        surveyQueTest2.savequestion();
        
        BLN_SurveyQuestionscon surveyQueTest3=new BLN_SurveyQuestionscon();
        surveyQueTest3.selectedtype='Checkboxes';
        surveyQueTest3.optionslabel();
        surveyQueTest3.editquestion();
        
        Apexpages.Currentpage().getparameters().put('editquid',que.id);
        surveyQueTest3.selectedtype='Scale';
        surveyQueTest3.editquestion();
        
        Apexpages.Currentpage().getparameters().put('delquid',que.id);
        Apexpages.Currentpage().getparameters().put('queanscount',string.valueOf(0));
        surveyQueTest3.delquestion();        
        
        }       
        
    }
}