/******************************************************
*   Author                  : Mythily Nagandla
*   Date                    : 14/12/2014 
*   Purpose                 : This is Web Service class for Update Profile.
********************************************************/
@RestResource(urlMapping='/BLN_ASC_UpdateProfile/*')
global class BLN_ASC_UpdateProfile{
global static maincontainer  Mc {get;set;}
//global static BLN_Profile_BAL procon{get ; set ;}
@HttpPost  
  global static maincontainer  doPost(){ //Post Mthod
  
   RestRequest req = RestContext.Request;
    string Fname = req.params.get('Firstname');
     string Lname = req.params.get('Lastname');
      string Cname= req.params.get('Companyname');
      string Comid = req.params.get('DefaultcompanyId');
       string Email = req.params.get('Email');
        string Mobile = req.params.get('Mobile');
        string city = req.params.get('City');
        string State= req.params.get('State');
        string Country= req.params.get('Country');
        string Uid= req.params.get('Userid');
        Mc = new maincontainer();
        
        //For getting GNUSER record to save updates
        BLN_Gnuser_DAO gndao = new BLN_Gnuser_DAO ();
        Company__c comp = new Company__c();
        comp.id = Comid;
        comp.Name = Cname;
        BLN_Company_DAO comdao = new BLN_Company_DAO();
        string companyid = comdao.updateCompany(comp);
          Blob jSONRequestBody=req.requestBody;
         GN_User__c  GNUID = gndao.gettinggnuser(uid);
         GNUID.First_Name__c = Fname ; 
         GNUID.Last_Name__c  = Lname ;
       //  GNUID.Company_Name__c = Cname;
         GNUID.City__c = city ;         
         GNUID.Country__c = Country;
         GNUID.State__c = State;
         GNUID.Mobile__c = Mobile;
         GNUID.Default_Company_ID__c = companyid;
        //or fUpdating image assiging blob from parameter to profile class blob
         BLN_Profile_BAL procon = new BLN_Profile_BAL();
          //procon.uid = uid;
          //procon.GNUSER = GNUID;
           procon.UserImage  = jSONRequestBody;
           procon.UserImageName  = GNUID.id;
          //UPdating profile Using profile class of portal
          procon.updateGNUSER(GNUID);
          GN_User__c  GNUID1 = gndao.gettinggnuser(uid);
         Mc.Profile = GNUID1;
            string orgid = UserInfo.getOrganizationId();  
         Mc.profileimage=  'https://c.cs14.content.force.com/servlet/servlet.ImageServer?id='+GNUID1.User_Pic__c+'&oid='+orgid;
         Mc.profilestate = GNUID1.State__r.Long_Name__c;
         Mc.profilecountry = GNUID1.Country__r.Long_Name__c;
        
         return Mc;
  
  }

  global class maincontainer{
  
  public GN_User__c Profile {get ; set ;}
  public string profileimage {get ; set ;}
  public string profilestate {get ; set ;}
  public string profilecountry {get ; set ;}
  public maincontainer(){} 
  
  
  }






}