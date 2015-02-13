public without sharing class BLN_Payment_DAO
{
/**
* @author :Arindam Sarkar
* @date 05/15/2014
* @ This class is used for DML operations on Payment object
*/ 

 // This will return payments of particular order 
  public List<Payment__c> paymentInfo(SET<id> ids)
  {
    return [select id,Currency_Code__c,Order__c,Payment_Amount__c,Payment_Ref_Number__c,Name,Payment_Mode__c from Payment__c where Order__c In :ids];
  }
  
  
   //Insering Order  
   public BLN_StatusMessage insertPayment(Payment__c pay){
       dataBase.saveResult saveRes = dataBase.insert(pay,false); 
       return new BLN_StatusMessage(saveRes);
    }
    
    
    //To Get All the Payments Belongs to An Event written By Manasa Gandham
    
    public List<AggregateResult> paymentsForEvent(String EventId){
        LIST<AggregateResult> paymentAggregateResult= new LIST<AggregateResult>(); 
        paymentAggregateResult= [SELECT SUM(Order__r.Amount_Paid__c) amt, event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name mode
                                 FROM Payment__c 
                                 WHERE Order__r.Events__c =: EventId
                                 AND Order__r.Transaction_Status__c  =: 'Completed'
                                 AND Order__r.Order_Status__c !=: 'Cancelled'
                                 AND event_paygateway_id__c != NULL
                                 GROUP BY event_paygateway_id__c, event_paygateway_id__r.Pay_Gateway__r.PGateway_Type__r.Name];
        return paymentAggregateResult;
    }
  
}