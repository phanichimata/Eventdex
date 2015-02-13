@istest
public class Test_BLN_Email_Dashboards{
    static testmethod void Testmethod_BLN_Email_Dashboard(){
    
    User U= new User();
    globalForTestClass globalTest= new globalForTestClass();
    U= globalTest.createUser();
    
    system.runas(U){
        
            NAICS_Code__c naicsCodeInfo1= new NAICS_Code__c();
            naicsCodeInfo1= globalTest.createNaicsCode();
            
            NAICS_Code__c naicsCodeInfo2= new NAICS_Code__c();
            naicsCodeInfo2= globalTest.createNaicsCode();
            
            Currency__c currenyInfo= new Currency__c();
            currenyInfo= globalTest.createCurrency();             
          
            Country__c countryInfo= new Country__c();
            countryInfo= globalTest.createCountry(currenyInfo.Id);  
            
            State__c stateInfo= new State__c ();
            stateInfo= globalTest.createState(countryInfo.Id);
            
            Company__c companyInfo= new Company__c();
            companyInfo= globalTest.createCompany(u.Companyname);
            
            Role__c roleInfo= new Role__c();
            roleInfo= globalTest.createRole();
            
            Company_Ext__c companyExtInfo= new Company_Ext__c();
            companyExtInfo= globalTest.createCompanyExt(companyInfo.Id, naicsCodeInfo1.Id, naicsCodeInfo2.Id, countryInfo.Id, stateInfo.Id);             
            
             BLN_Event__c eventInfo= new  BLN_Event__c();
            eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id);        
            
            
            User userForGN= new User();
            userForGN= globalTest.createUserForGNUser();
            
            GN_User__c  gnUser= new GN_User__c();
            gnUser= globalTest.createGNUser(u,countryInfo.Id, Stateinfo.Id);          
       
                       
            Item_Type__c itemType= new Item_Type__c();
            itemType= globalTest.createItemType();
            
            BLN_Track__c trackInfo= new BLN_Track__c();
            trackInfo= globalTest.createTrack(eventInfo.id);
          
          
            Item_Pool__c ItemPool= new Item_Pool__c();
            ItemPool= globalTest.createItemPool(eventInfo.id, itemType.Id, NULL,trackInfo.Id);
            
            BLN_Item__c item= new BLN_Item__c();
            item= globalTest.createItem(ItemPool.Id, itemType.Id, eventInfo.id);
            
            Order__c insertOrder1= new Order__c();
            insertOrder1= globalTest.createOrder(gnUser.Id, userForGN.id, companyInfo.Id, eventInfo.Id, currenyInfo.Id);
            
            Ticket__c ticket= new Ticket__c();
            ticket= globalTest.createTicket(eventInfo.id, item.Id, itemPool.Id, itemType.Id,insertOrder1.Id,gnUser.id);
            
            Hash_Tag__c HTag = new Hash_Tag__c ();
            HTag = globalTest.createHashTag(eventInfo.id);
            
            //ItemPool_Tag_Junction__c Tagjun = new ItemPool_Tag_Junction__c ();
            //Tagjun = globalTest.createtagjunction(itemPool.Id,HTag.id);
            
            EmailTemplate E =[SELECT id,Body,BrandTemplateId,Description,DeveloperName,Encoding,FolderId,HtmlValue,IsActive,LastUsedDate,Markup,Name,NamespacePrefix,OwnerId,Subject,TemplateStyle,TemplateType,TimesUsed FROM EmailTemplate Limit 1];
            string Tid = E.id;
            EmailCampaign__c nwemailcamp = new EmailCampaign__c();
             nwemailcamp.Name = 'sample';
             nwemailcamp.CampEmailTemplate__c = Tid;
             nwemailcamp.CampFromEmailId__c =  'mythilyn@globalnest.com';
             nwemailcamp.CampFromName__c = 'Mythily';
             nwemailcamp.CampSubject__c = 'Hello';
             nwemailcamp.CampType__c = 'Announcement';
             nwemailcamp.Event__c = eventInfo.id;
             nwemailcamp.Template_Type__c = 'Custom';
             nwemailcamp.ToList__c = 'SPONSOR';
             nwemailcamp.auto_schedule_Type__c = 'Days before the event';
             nwemailcamp.Email_Send_Date__c = system.today()-2;
            insert nwemailcamp;
            
            
            EmailCampaign__c nwemailcamp1 = new EmailCampaign__c();
             nwemailcamp1.Name = 'sample';
             nwemailcamp1.CampEmailTemplate__c = Tid;
             nwemailcamp1.CampFromEmailId__c =  'mythilyn@globalnest.com';
             nwemailcamp1.CampFromName__c = 'Mythily';
             nwemailcamp1.CampSubject__c = 'Hello';
             nwemailcamp1.CampType__c = 'Reminder';
             nwemailcamp1.Event__c = eventInfo.id;
             nwemailcamp1.Template_Type__c = 'Custom';
             nwemailcamp1.ToList__c = 'SPONSOR';
             nwemailcamp1.auto_schedule_Type__c = 'Days before the event';
             nwemailcamp1.Email_Send_Date__c = system.today()-2;
            insert nwemailcamp1;
            
            EmailCampaign__c nwemailcamp2 = new EmailCampaign__c();
             nwemailcamp2.Name = 'sample';
             nwemailcamp2.CampEmailTemplate__c = Tid;
             nwemailcamp2.CampFromEmailId__c =  'mythilyn@globalnest.com';
             nwemailcamp2.CampFromName__c = 'Mythily';
             nwemailcamp2.CampSubject__c = 'Hello';
             nwemailcamp2.CampType__c = 'Registration email';
             nwemailcamp2.Event__c = eventInfo.id;
             nwemailcamp2.Template_Type__c = 'Custom';
             nwemailcamp2.ToList__c = 'SPONSOR';
             nwemailcamp2.System_Template_Type__c = 'Order Confirmation';
             nwemailcamp2.auto_schedule_Type__c = 'Days before the event';
             nwemailcamp2.Email_Send_Date__c = system.today()-2;
            insert nwemailcamp2;
            
             cookie  counter = new Cookie('counter',eventInfo.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});
            Apexpages.Currentpage().getparameters().put('editcamid',nwemailcamp2.id);
            Apexpages.Currentpage().getparameters().put('eventid',eventInfo.id);
            
            Apexpages.Currentpage().getparameters().put('campname','sample');
            Apexpages.Currentpage().getparameters().put('frmname','Mythily');
            Apexpages.Currentpage().getparameters().put('reciepients','SPONSOR');
            Apexpages.Currentpage().getparameters().put('updatestandardtemp','');
            
             Apexpages.Currentpage().getparameters().put('updatestandardtemp','hai');
            Apexpages.Currentpage().getparameters().put('newtemp','sample1');
            
            Apexpages.Currentpage().getparameters().put('active',nwemailcamp2.id);
            
            BLN_Email_Dashboardscon Emaildashboard = new BLN_Email_Dashboardscon();
            
            Emaildashboard.displayPermissions();
            Emaildashboard.getemailcampslist();
            Emaildashboard.selectedfield = 'First Name';
            Emaildashboard.fetchingfieldval();
            Emaildashboard.selectedfield = 'Last Name';
            Emaildashboard.fetchingfieldval();
            Emaildashboard.selectedfield = 'Company Name';
            Emaildashboard.fetchingfieldval();
            Emaildashboard.selectedfield = 'Event Name';
            Emaildashboard.fetchingfieldval();
            Emaildashboard.selectedfield = 'Event Logo';
            Emaildashboard.fetchingfieldval();
            Emaildashboard.createcampaign();
            Emaildashboard.editcamp();
            Emaildashboard.geteventdetails();
            Emaildashboard.cancelmethod();
            string camid = nwemailcamp1.id;
            string evid = eventInfo.id;
            //Emaildashboard.forinsertcampaign('sample',camid,'mythily@globalnest.com','mythily','hello','custom',evid,'SPONSOR','SPONSOR','Order Confirmation');
            //Emaildashboard.campname = 'sample';
            Emaildashboard.updatetemp();
            Emaildashboard.campaignslist();
            Emaildashboard.selectedRadio = 'Days before the event';
            Emaildashboard.autoschedule();
            Emaildashboard.sendnow();
            Emaildashboard.daysbefore = '2';
            Emaildashboard.addingschedule();
            Emaildashboard.creatingnewtemplate();
            Emaildashboard.inputvalue=E.id;
            Emaildashboard.savenewcampaign();
            
            Emaildashboard.activatetemp();
            Emaildashboard.selectradiobool();
           //Emaildashboard.getcampaigninfo();
           //Emaildashboard.getemailtempopts();
            
          }
          
     }  
            
 }