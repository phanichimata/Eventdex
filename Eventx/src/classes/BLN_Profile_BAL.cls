public without sharing class BLN_Profile_BAL{
    public User userdetail{get ; set ;}
    public GN_User__c GNUSER {get ; set ;}
    public Company__c comp {get ; set ;}
    public List<Pay_Address__c>  addlist  {get ; set ;}
    
    public GN_User__c userdetails(string uid){
    GNUSER = new GN_User__c();
    BLN_User_DAO Udetails = new BLN_User_DAO();
    userdetail = Udetails.getUser(uid);
    system.debug('uuuuuuuuuuuuu'+userdetail.Email);
    BLN_Gnuser_DAO Gnuserdao = new BLN_Gnuser_DAO ();
    GNUSER = Gnuserdao.existingGnuser(userdetail.Email);
    system.debug('gggggggggggggggggggg'+GNUSER);
   
    return GNUSER;
    }
    public Company__c compdetails(string compname){
    BLN_Company_DAO comext = new BLN_Company_DAO();
    comp = comext.queryCompanyId(compname);
    return comp;  
    }
    
    public List<Company__c> comps {get ; set ;}
    public List<Company__c> compniesdetails(string gnid){
    BLN_Company_DAO comext = new BLN_Company_DAO();
    comps = comext.gnusercompanies(gnid);
    return comps;  
    
    }
    
    
    
    
    public List<Pay_Address__c> billingadd(string cid){
    addlist = new List<Pay_Address__c> ();
    BLN_Pay_Address_DAO paydao = new BLN_Pay_Address_DAO ();
    addlist = paydao.getbillingAddress(cid);
    return addlist;
    }
    public blob UserImage {get ; set ;}
    public string UserImageName {get ; set ;}
    public document mydoc {get ; set ;} 
    
    public GN_User__c updateGNUSER(GN_User__c GNUSER){
    List<folder> folderList =new List<folder>();
        folderList = [select id from folder where Name =: 'Shared Documents'];
    //system.debug(':::::::::::::::::pic val:::::::::'+UserImage.size()+'           '+UserImageName);
    if (UserImage != NULL && (UserImageName != '' || UserImageName != NULL)) {    
             if (UserImage.size() != null) {
                if (UserImage.size() <= 1024000) {
                     mydoc = new document();
                     mydoc.body = UserImage;
                   //  if(folderList.size()>0){
                       mydoc.folderid =folderList[0].id;
                    //  }
                     mydoc.ispublic = true;
                     mydoc.Name = UserImageName;
                     insert mydoc;
                     
                     GNUSER.User_Pic__c = mydoc.id;
                 } else {
                     
                 }
    
            }

        }
    update GNUSER;
    UserImage = null;
    
    return GNUSER;
    
    }
     



}