@isTest
public class Test_BLN_Pay_Address_DAO {

    static testMethod void testmethod_BLN_Pay_Address_DAO(){
    
    BLN_Pay_Address_DAO bd = new BLN_Pay_Address_DAO();
    
    Pay_Address__c pc = new Pay_Address__c();
     
    bd.insertPayAddress(pc);
    
    List<Pay_Address__c> lc = new List<Pay_Address__c>();
    
    bd.getbillingAddress('test');
    
     string ed = pc.Event__c;
     string ab = pc.Company__c;
     string  cd = pc.GN_User__c;
     
    bd.insertPayAddressprocess(ed,ab,cd);
    
    }
    
  }