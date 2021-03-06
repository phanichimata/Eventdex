@isTest(SeeAllData= true)
public class Test_BLN_AttendeeReportCon_BAL {
    static testmethod void Testmethod_BLN_AttendeeReportCon_BAL (){
        
      
        globalForTestClass globalTest= new globalForTestClass();
       // U= globalTest.createUser();
        Profile p = [select id from profile where name='System Administrator'];
         userRole r=[SELECT ID FROM userRole WHERE name =: 'CEO'];   
         // ------------------ Eventadmin Insert ---------------------

         User u = new User(alias = 'Test', email='testcode@noemail.com',
                           emailencodingkey='UTF-8',profileid = p.Id,lastname='codeTesting', Firstname='codeTesting', languagelocalekey='en_US',
                           localesidkey='en_US',country='United States Of America', userRoleId= r.id, CompanyName= 'GlobalNest',
                           timezonesidkey='America/Los_Angeles', username='testcode@noemail.com');
         database.insert(u,false);
        
        
        system.runas(u){
              Currency__c currenyInfo= new Currency__c();
            currenyInfo= globalTest.createCurrency();             
            
            Country__c countryInfo= new Country__c();
            countryInfo= globalTest.createCountry(currenyInfo.Id);  
            
            State__c stateInfo= new State__c ();
            stateInfo= globalTest.createState(countryInfo.Id);     
             
           GN_User__c  userForGN = new GN_User__c();
           userForGN = globalTest.createGNUser(u, countryInfo.Id, stateInfo.Id);
                       
            NAICS_Code__c naicsCodeInfo1= new NAICS_Code__c();
            naicsCodeInfo1= globalTest.createNaicsCode();
            
            NAICS_Code__c naicsCodeInfo2= new NAICS_Code__c();
            naicsCodeInfo2= globalTest.createNaicsCode();
            
            Company__c companyInfo= new Company__c();
            companyInfo= globalTest.createCompany(u.Companyname);
            
            Company_Ext__c companyExtInfo= new Company_Ext__c();
            companyExtInfo= globalTest.createCompanyExt(companyInfo.Id, naicsCodeInfo1.Id, naicsCodeInfo2.Id,countryInfo.Id, stateInfo.Id);            
                 
            
            BLN_Event__c eventInfo= new  BLN_Event__c();
           eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id);            
            
            EmailCampaign__c emailCampaignInfo= new EmailCampaign__c();
            emailCampaignInfo= globalTest.createEmailCampaign(eventInfo);           
                       
            Item_Type__c itemType= new Item_Type__c();
            itemType= globalTest.createItemType();
            
            BLN_Track__c trackInfo= new BLN_Track__c();
            trackInfo= globalTest.createTrack(eventInfo.Id);
            
            Item_Pool__c ItemPool= new Item_Pool__c();
            ItemPool= globalTest.createItemPool(eventInfo.id, itemType.Id, NULL, trackInfo.Id);
            
            BLN_Item__c item= new BLN_Item__c();
            item= globalTest.createItem(ItemPool.Id, itemType.Id, eventInfo.id);
            
            
            Reg_Setting__c regSettingsInfo1= new Reg_Setting__c();
            regSettingsInfo1= globalTest.createRegSettings(eventInfo.Id, ItemPool.Id, item.id, NULL, NULL, 'Display', 'Sales Message');
                        
            Reg_Setting__c regSettingsInfo2= new Reg_Setting__c();
            regSettingsInfo2= globalTest.createRegSettings(eventInfo.Id, ItemPool.Id, item.id, NULL, NULL, 'Event Staff','Sales Message');
            
            BLN_AttendeeReportCon_BAL blnarc= new BLN_AttendeeReportCon_BAL();
            
            
            }
            }
            }