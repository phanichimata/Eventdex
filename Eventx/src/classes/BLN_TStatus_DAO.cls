public without sharing class BLN_TStatus_DAO{
/***********************************************************************************************
*   Controller Name : BLN_TStatus_DAO
*   Date            : 24/12/2014
*   Author          : Rajesh Kumar Ch
*   Purpose         : This class is DAO Class, includes necessary database operation.
**************************************************************************************************/

    public BLN_StatusMessage insertTStatus(List<Tstatus__c> TicketStatus){
        dataBase.saveResult[] saveRes = dataBase.insert(TicketStatus,false); 
        return new BLN_StatusMessage(saveRes);
    }
    
    public List<Tstatus__c> getTStatusByIds(List<Id> TstsIds){
        return [SELECT Id, Tstatus_name__c, Ticket__c,CreatedDate FROM Tstatus__c WHERE Id IN : TstsIds ];        
    }

}