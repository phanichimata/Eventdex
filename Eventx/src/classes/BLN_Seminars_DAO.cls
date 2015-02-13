public with sharing class BLN_Seminars_DAO {



    public LIST<Agenda__c> allSemiorItemsList(ID eventId){
        
            LIST<Agenda__c> seminors = [SELECT ID,Agenda_Type__c, NAME, BLN_Track__c, BLN_Track__r.Name, BLN_Track__r.Event__c, Agenda_Description__c, 
                        (SELECT ID, NAME, Agenda__c, Slot_End_date__c, Slot_Start_date__c,  Room__c, Room__r.NAME,room__r.Room_Number__c,Agenda__r.BLN_Track__c FROM Time_Slots__r ) FROM Agenda__c WHERE Event__c =: eventId ];
            
        return seminors;
        
    }

}