public with sharing class SiteLoginController {
    public String authProviderURL { get; set; }
    public String username {get; set;}
    public String password {get; set;}
    public String siteURL  {get; set;}
    public String startURL {get; set;}
 
    public SiteLoginController () {
        // Auth Provider URL hard coded here for clarity; better to load from a custom setting!
        authProviderURL = 'https://login.salesforce.com/services/auth/sso/00Dd0000000e1KYEAY/FacebookProvider';
      siteURL         = Site.getBaseUrl();
         // siteURL = 'blnew-eventdex.cs14.force.com';
        startURL        = System.currentPageReference().getParameters().get('startURL');
    }
    
    public PageReference login() {
        return Site.login(username, password, startUrl);
    }
}