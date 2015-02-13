trigger copyEventLevelFeeOptionToItems on BLN_Event__c (after update) {

BLN_Event__c eve=[select id,name,Service_Fee__c,Event_Ticket_Options__c from BLN_Event__c where id=:Trigger.newmap.keyset() limit 1];
List<BLN_Item__c> items=[select id,name,service_fee__c,Ticket_Settings__c,Event__c from BLN_Item__c where Event__c=:eve.id];

for(integer i=0;i<items.size();i++)
{
  items[i].service_fee__c =eve.Service_Fee__c ;
  items[i].Ticket_Settings__c=eve.Event_Ticket_Options__c;
}

if(items.size()>0)
update items;

}