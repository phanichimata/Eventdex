public with sharing class BLN_Gnuser_DAO {
/***********************************************************************************************
*   Controller Name : BLN_Gnuser_DAO
*   Date            : 07/01/2014
*   Author          : Phani Kumar Ch
*   Purpose         : This class has all queries and Dml oprations of GNuser Object
*   Change History  : 07/01/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
* 07/01/2014          Phani Kumar ch                    To Create Page
**************************************************************************************************/
   public List<GN_User__c > getGnuserList(SET<id> setOfgnusers){
      return [select id,First_Name__c,Last_Name__c,User__c,Address1__c,Address2__c,Age__c,City__c,Country__c,DOB__c,Eff_Date__c,Email__c,Gender__c,Home_Phone__c,Is_Active__c,Mobile__c,Zip_Code__c,User_Pic__c,State__c,Suffix__c,Prefix__c,Phone__c from GN_User__c where Id IN :setOfgnusers];
   }
   
   // This method is for updating gnuser
    public string updateGNUser(GN_User__c u,String Email,String ticketid,String sfuserid){
    
       //get gnuser of that ticket
       Ticket__c tc=[select id,name,Client_GN_User__c from Ticket__c where id=:ticketid];
       
        //Update user
        GN_User__c updateuser = [SELECT id,First_name__c,Last_name__c,Email__c,phone__c,User__c FROM GN_User__c 
                            WHERE id =: tc.Client_GN_User__c];
                            
        updateuser.First_Name__c=u.First_Name__c;
        updateuser.Last_Name__c=u.Last_Name__c ;
        //updateuser.title__c=u.title__c;
        updateuser.phone__c=u.phone__c;
        updateuser.Email__c =u.email__c;
        if(sfuserid!=null)
        updateuser.User__c=u.user__c;
        
        database.update(updateuser);    
        
        return updateuser.id;
    }
    
      public string InsertGNUser(GN_User__c u){
       DataBase.saveREsult saveRes =  DataBase.Insert(u,false);
       system.debug('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEE '+saveRes );
        if(saveRes.isSuccess()){
            return saveRes.getId();
        }else{
           return '';
        }
      }
      
      
       public void InsertGNUser(List<GN_User__c> u){
          DataBase.saveREsult[] saveRes =  DataBase.Insert(u,false);
       }
      
      
      
      public GN_User__c gettinggnuser(string uid){
      
      return [SELECT id,name,First_Name__c,Last_Name__c,Prefix__c,Suffix__c,Email__c,
                        Default_Company_ID__c,Default_Company_ID__r.Name,Phone__c,User_Pic__c,Mobile__c,Address1__c,Address2__c,
                            City__c,Country__c,State__c,Zip_Code__c,
                             State__r.Name,State__r.Long_Name__c,Country__r.Long_Name__c,Country__r.Name from GN_User__c where   User__c =: uid Limit 1];
      
      }
      
      public GN_User__c existingGnuser(string emailid){
      system.debug('ddddddddddddddddddddddddd'+emailid);
      return [SELECT id,name,First_Name__c,Last_Name__c,Prefix__c,Suffix__c,Email__c,
                        Phone__c,User_Pic__c,Mobile__c,Address1__c,Address2__c,
                            City__c,Country__c,State__c,Default_Company_ID__r.id,Default_Company_ID__r.Name,Zip_Code__c FROM GN_User__c WHERE Email__c =: emailid limit 1];
      
      }
      
    
    public List<GN_User__c> existingGnusers(SEt<string> emailid){
      system.debug('ddddddddddddddddddddddddd'+emailid);
      return [SELECT id,First_Name__c,Last_Name__c,Prefix__c,Suffix__c,Email__c,
                        Phone__c,User_Pic__c,Mobile__c,Address1__c,Address2__c,
                            City__c,Country__c,State__c,Default_Company_ID__r.id,Zip_Code__c FROM GN_User__c WHERE Email__c In : emailid ];
      
      }
      
    
    
    
    //return gnuserid
    public String insertGnUserprocess(String FirstName,String LastName,String email,String title,String phone,String address1,String address2,String city,String state,String country,String zipcode)
    {
        GN_User__c newu=new GN_User__c();
        newu.First_Name__c=FirstName;
        newu.Last_Name__c=LastName;
        newu.Email__c=email;
        //newu.Title__c=title;
        newu.Phone__c=phone;
        newu.Address1__c = address1;
        newu.Address2__c =  address2;
        newu.City__c = city;
        newu.State__c =state;
        newu.Country__c  = country;
        newu.Zip_Code__c = zipcode;
        //insert GNuser process
    
        BLN_StatusMessage userMsg;
        String userid;
    
         BLN_Quick_Registration_BAL quickbal = new BLN_Quick_Registration_BAL ();
        if(quickbal.checkUserEmail(newu.Email__c)!=null){
            
            for(GN_User__c gnup : [select id,First_Name__c,Last_Name__c,Email__c from GN_User__c where user__c =:quickbal.checkUserEmail(newu.Email__c) limit 1]){
                           userid= gnup.id;
                           
                            if(newu.Phone__c!=null){
                             gnup.Phone__c= newu.Phone__c;
                            }
                          if(newu.Address1__c!=null){
                             gnup.Address1__c = newu.Address1__c;
                            }
                            if(newu.Address2__c!=null){ 
                             gnup.Address2__c =  newu.Address2__c;
                            } 
                            if(newu.City__c!=null){
                             gnup.City__c = newu.City__c;
                            }
                            if(newu.State__c!=null){
                             gnup.State__c =newu.State__c;
                            }
                            if(newu.Country__c!=null){
                                gnup.Country__c  = newu.Country__c;
                            } 
                             if(newu.Zip_Code__c!=null){ 
                              gnup.Zip_Code__c = newu.Zip_Code__c;
                             }   
                       dataBase.update(gnup,false);
                      
            }      
                 
        }else{
            userMsg=quickbal.insertGNUser(newu);
            if(userMsg.successBool){
                userid=userMsg.successId;                  
            }else{
                
               userid=null;  
            }
        }
        
        return userid;
    }
    
    
    
}