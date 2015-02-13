/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public with sharing class CommunitiesSelfRegController {

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public string ASCompanyName{get;set;}
    public string successMSG {get;set;}
  //  public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    //public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    
    public CommunitiesSelfRegController(){}
    
    

    public PageReference registerUser() {
    
           // it's okay if password is null - we'll send the user a random password in that case
        /*if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }    
   */
        String profileId = null; // To be filled in by customer.
        String roleEnum = null; // To be filled in by customer.
        String accountId = ''; // To be filled in by customer.
        
        String userName = email;
         BLN_User_SignUP_BAL BLNuserSignupbal = new BLN_User_SignUP_BAL();
       successMSG = BLNuserSignupbal.CheckUserEmailExists( firstName ,lastName , email , ASCompanyName, password );
         if( successMSG != null){
            if(successMSG.toLowerCase()  == 'success'){
            return Site.login(email , password, ApexPages.currentPage().getParameters().get('startURL'));
            }else{
            system.debug('WWWWWWWWWW ' +successMSG );
               return null;
            }
       } else{
          return null;
       }   
    }

      /*  User u = new User();
        u.Username = userName;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CommunityNickname = communityNickname;
        u.ProfileId = profileId;
        
        String userId = Site.createPortalUser(u, accountId, password);
      
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                return Site.login(userName, password, ApexPages.currentPage().getParameters().get('startURL'));
            }
            else {
                PageReference page = System.Page.CommunitiesSelfRegConfirm;
                page.setRedirect(true);
                return page;
            }
        }
       
        
        return null;*/ 
    }