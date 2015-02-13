@isTest
public class Test_BLN_UserEvents{
    static testmethod void Testmethod_BLN_UserEvents(){
        
       // User U= new User();
        globalForTestClass globalTest= new globalForTestClass();
        //U= globalTest.createUserForGNUser();        
        Profile p = [select id from profile where name='System Administrator'];
         userRole r=[SELECT ID FROM userRole WHERE name =: 'CEO'];   
         // ------------------ Eventadmin Insert ---------------------

         User u = new User(alias = 'Test', email='testcodefd@noemail.com',
                           emailencodingkey='UTF-8',profileid = p.Id,lastname='codeTesting', Firstname='codeTesting', languagelocalekey='en_US',
                           localesidkey='en_US',country='United States Of America', userRoleId= r.id, CompanyName= 'GlobalNest',
                           timezonesidkey='America/Los_Angeles', username='testcodefd@noemail.com');
         database.insert(u,false);
         
        system.runas(U){
        
               
            Company__c companyInfo= new Company__c();
            companyInfo= globalTest.createCompany(u.Companyname);
            
            Currency__c currenyInfo= new Currency__c();
            currenyInfo= globalTest.createCurrency();             
            
            Country__c countryInfo= new Country__c();
            countryInfo= globalTest.createCountry(currenyInfo.Id);  
            
            State__c stateInfo= new State__c ();
            stateInfo= globalTest.createState(countryInfo.Id);     
            
            GN_User__c  gnUserInfo= new GN_User__c();
            gnUserInfo= globalTest.createGNUser(U, countryInfo.Id, stateInfo.Id);
       
            BLN_Event__c eventInfo= new  BLN_Event__c();
            eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id);     
            
            Role__c roleInfo= new Role__c();
            roleInfo= globalTest.createRole();
            
            UC_Role__c ucRoleInfo= new UC_Role__c();
            ucRoleInfo= globalTest.createUCRole(companyInfo.Id, eventInfo.Id, gnUserInfo.id, u.Id, roleInfo.id);  
            
           
            BLN_UserEvents userEvents= new BLN_UserEvents();
            
            userEvents.noevent();
            ApexPages.CurrentPage().getParameters().put('EventName',eventInfo.Id); 
            userEvents.manageEvent();
            
            ApexPages.CurrentPage().getParameters().put('EventName',eventInfo.Id);             
            userEvents.Editevent();
            userEvents.UpdateEvent();
             userEvents.deleteparamval();
            ApexPages.CurrentPage().getParameters().put('EventName',eventInfo.Id);             
            userEvents.deleteEvent(eventInfo.Id);
           
            userEvents.cancel();
            ApexPages.CurrentPage().getParameters().put('EventName',eventInfo.Id);                         
            userEvents.myTickets();
            
            BLN_UserEvents userEvents1= new BLN_UserEvents();
            userEvents1.EventsList.clear();
            //Userinfo.getProfileId() = '00eF000000146R4IAI';
             userEvents1.noevent();
              
         
        }
    }
    
}