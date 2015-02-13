public without sharing class samplePhanicon {


 public contact gnuser{get;set;}
 
 public user u{get;set;}
 
  public samplePhanicon(){
  gnuser = new contact ();
  gnuser = [select id,name,owner.Name,owner.profileId from contact limit 1];
   u= new user();
  
  }
 public List<String>  getListOfUserLicences(){
List<string> Lt=new list<string>();
for(UserLicense a:[SELECT Name FROM UserLicense]){
lt.add(a.Name);
}
return lt;
}
 
   public void deleteusers(){
     
     /* List<user> users  = new List<user>();
        for(user u : [select id,userName,email,isActive  from user where profile.name ='Event Admin' and password__c=null and isactive=true limit 99]){
        string[] str = new string[]{};
       u.isActive = false;
        users.add(u);
         
        
        }
      database.update(users ,false); 
     */
   }


}