@istest
public class Test_BLN_Email_Templatecon{
    static testmethod void Testmethod_BLN_Email_Templatecon(){
    
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
            
            cookie  counter = new Cookie('counter',eventInfo.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});
            
            BLN_Email_Templatecon betc= new BLN_Email_Templatecon();
            betc.alltemplates();
            betc.edittemp();
            }
            }
            }