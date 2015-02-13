public without sharing class BLN_SignUpCon{
/***********************************************************************************************
*   Controller Name : BLN_SignUpCon 
*   Date            : 07/05/2014
*   Author          : Phani Kumar Ch
*   Purpose         : This class is for Login And Sign Up for User
*   Change History  : 07/05/2014 

*   Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*   07/05/2014         Phani Kumar Ch                  To Create Page 
**************************************************************************************************/
   
    public String ASUserEmail { get; set; } // user Email
    public String ASLastName { get; set; } // User Last Name
    public String ASFirstName { get; set; } // User First Name
    public String ASCompanyName { get; set; } // User Company
    public string password {get;set;} // Password

    public string loginName{get;set;} // login user name
    public string loginPassword{get;set;} // login user 
   
   
    public boolean Successbool { get; set; } // To display Success message after sign up
    public string error{get;set;} // Error Message
    public boolean forDisplayError{get;set;} // boolean to render error
    public string successMSG{get;set;}
   
    public PageReference BLS_SignUpUser(){
         BLN_User_SignUP_BAL BLNuserSignupbal = new BLN_User_SignUP_BAL();
         IF((ASCompanyName!=NULL && ASCompanyName !='')){
            
         }
         
         successMSG = BLNuserSignupbal.CheckUserEmailExists( ASFirstName ,ASLastName , ASUserEmail , ASCompanyName, password  );
       
        Successbool = false;
       
       if( successMSG != null){
            if(successMSG.toLowerCase()  == 'success'){
                Successbool = true;
                sendEmail();
                forDisplayError =false;
            }else{
                Successbool = false;
                forDisplayError =true;
                error = successMSG ;
            }
       }     
       return null;
    }
    
    
    
    
    public PageReference signUpLogin(){
         ASUserEmail = ASUserEmail.trim();
        password= password.trim();
        return  Site.login(ASUserEmail , password, '/apex/BLN_UserEvents'); 
    }
    
    public pageReference login(){
        forDisplayError = false;
        loginName = loginName.trim();
        loginPassword = loginPassword.trim();
        pageReference pg =Site.login(loginName,loginPassword ,'/apex/BLN_UserEvents');
         if(pg !=null){
            return   pg;
        }
        else{
            error='Your login attempt has failed. Make sure the username and password are correct.';
            forDisplayError = true;
            return null;
        }
    }
    
    public void sendEmail(){
     OrgWideEmailAddress Org =  [select id from OrgWideEmailAddress WHERE address='support@boothleads.com'];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('Welcome to eventdex- Your registration was successful');
          
         List<Messaging.SingleEmailMessage> EmailsList = new List<Messaging.SingleEmailMessage>();
   
         if( Org != null){  
            LIST<String> toAddresses = new LIST<String>();  
             toAddresses.add(ASUserEmail);
             email.setToAddresses(toAddresses);
             
               EmailTemplate E = new EmailTemplate();
            
                try{ 
                  E = [select Body,Subject,HtmlValue,Markup from EmailTemplate Where Name = 'EventDex Signup']; 
                }catch(exception fr){}
               
             
             
              String ReplaceContactName = E.HtmlValue;
              String replacedname ;
              
              
              try{
              replacedname = ReplaceContactName.Replace('{!userName}',ASFirstName  +' '+ASLastName );
             }catch(exception ed){}  
             
              email.setHtmlBody(replacedname);            
              EmailsList.add(email); 
             if(EmailsList.size()>0){
                try{
                    Messaging.sendEmail(EmailsList);
                }catch(exception ecd){
                
                }
             }
         }
    
    }

}