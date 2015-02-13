@istest
public class Test_BLN_CreateUser_BAL{
    static testmethod void Testmethod_BLN_CreateUser_BAL(){
    User U= new User();
        globalForTestClass globalTest= new globalForTestClass();
        U= globalTest.createUser();
        system.runas(U){
            User userForGN= new User();
            userForGN= globalTest.createUserForGNUser();
            Company__c companyInfo= new Company__c();
            
            companyInfo= globalTest.createCompany(u.Companyname);
               BLN_User_DAO blnuserDao = new BLN_User_DAO();
            Currency__c currenyInfo= new Currency__c();
            currenyInfo= globalTest.createCurrency();  
            Company_Ext__c cec = new Company_Ext__c(); 
            
       BLN_CreateUser_BAL bl = new BLN_CreateUser_BAL();  
            bl.CheckUserEmailExists(U,companyInfo,cec);
            
            contact Con = new Contact();
            Con.Lastname = u.FirstName;
            Con.Firstname =u.LastName; 
            con.email = u.email;
                      
            Profile P = [SELECT Id,Name FROM Profile WHERE Name = 'Event Admin'];
            U.Alias = 'EAdmin';
            U.ProfileID = P.id;
            
            U.CommunityNickname = String.valueOf(math.random());
            U.LocaleSidKey = 'en_US';
            U.LanguageLocaleKey = 'en_US';
            U.TimeZoneSidKey = 'America/Los_Angeles';
            U.EmailEncodingKey='UTF-8';
            U.Username = u.email;
            U.Email = u.Email;
             
            BLN_CreateUser_BAL.updateUserStatus(U.id,'pass');       
            }
            }
            }