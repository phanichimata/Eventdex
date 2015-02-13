public without sharing class BLN_Badge_DAO{

/**
* @author :Arindam Sarkar
* @date 05/15/2014
* @ This class is used for DML operations on Badge object
*/ 

//Getting Avalaible Badge By Passing Ticket ID
public String getBadgeForTicket(String ticketid)
{
STring badgeid;
try
      {
       Badge__c badge=[SELECT id,name,ticket_id__c FROM Badge__c where ticket_id__c=:ticketid and cancel_time__c=null and Exp_time__c=null];
       badgeid=badge.id;
       }catch(Exception e){badgeid='';}
       
       return badgeid;
}


public BLN_StatusMessage insertBadge(Badge__c bdg)
{
    dataBase.saveResult saveRes = dataBase.insert(bdg,false);
    return new BLN_StatusMessage(saveRes);
}

public BLN_StatusMessage updateBadge(Badge__c bdg)
{
    dataBase.saveResult saveRes = dataBase.update(bdg,false); 
       return new BLN_StatusMessage(saveRes);
}




}