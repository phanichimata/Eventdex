/***********************************************************************************************
*   Controller Name : BLN_Reg_Settings_DAO
*   Date            : 06/10/2014
*   Author          : Phani Kumar Ch
*   Purpose         : This class is for insert,delete,update tickets
*   Change History  : 05/19/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*  06/10/2014          Phani Kumar ch                   To Create Page
*  
**************************************************************************************************/
  
public with sharing class BLN_Reg_Settings_DAO {
  
 // By Phani for delete set of settings
  public void deleteRegset(List<Reg_Setting__c> regs){
     dataBase.delete(regs,false);
  }
  
 // By Phani for delete set of settings
  public void insRegset(List<Reg_Setting__c> regs){
    dataBase.saveResult[] saveres = dataBase.insert(regs,false);
    system.debug('WWWWWWWWWWWW '+saveRes);
  }
  
  // By Phani for update set of settings
  public void updateSet(List<Reg_Setting__c> regs){
    dataBase.UpsertResult[] saveres = dataBase.upsert(regs,false);
    system.debug('WWWWWWWWWWWW '+saveRes);
  }
  
  // By Shruthi for retrieving list of settings based on setting type
  
  public List<Reg_Setting__c> getregsettingslist(String selectedeventid )
    {
        List<Reg_Setting__c> regsettingslist  = new List<Reg_Setting__c>();
        
       RETURN regsettingslist  = [SELECT  ID,NAME,Column_Name__c,Tag_Id__c,Create_Access__c,Sales_Message__c,Order__c,Delete_Access__c,Event__c,Group_Name__c,Group_Order__c,Included__c,Item__c,Item_Pool__c,Label_Name__c,Organizer__c,Read_Access__c,Required__c,Setting_Type__c,Table_Name__c,Update_Access__c  FROM Reg_Setting__c WHERE   Event__r.ID =:selectedeventid AND (Setting_Type__c =: 'Display'OR Setting_Type__c =: 'Registration Tab') AND Item_Pool__c=:NULL ORDER BY Order__c];
       // RETURN regsettingslist  =database.query('SELECT '+'ID,NAME,Column_Name__c,Create_Access__c,Sales_Message__c,Delete_Access__c,Event__c,Group_Name__c,Group_Order__c,Included__c,Item__c,Item_Pool__c,Label_Name__c,Order__c,Organizer__c,Read_Access__c,Required__c,Setting_Type__c,Table_Name__c,Update_Access__c'+' FROM Reg_Setting__c WHERE '+condition);
        
    }
  
  
  
  
  
  
}