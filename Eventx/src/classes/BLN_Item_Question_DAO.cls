public  without sharing class BLN_Item_Question_DAO {

 
 
 
   //-------------- This method is to retrieve ItemQuestionsList for the event------------.
    
    Public LIST<Item_Question__c> itmquestionslist(String selectedeventid ,LIST<Item_Question__c> itmquestionslist )
     
     {
         //LIST<Item_Question__c> itmquestionslistTemp=new LIST<Item_Question__c> ();
        return itmquestionslist = [Select Id, Question_Level__c, item__c, item__r.item_name__c,IQ_Order__c,Question__c, Question__r.Event__c, Question__r.Id, Question__r.Name, Question__r.Answer_Type__c, Question__r.Question_Order__c, Question__r.Question_Text__c, (SELECT ID,NAME,Item_Question__c,Answer__c,UAnswer_Text__c,User__c FROM User_Answers__r ) FROM Item_Question__c WHERE Question__r.Event__c =: selectedeventid];
     }
     
     // Item Questions Belongs to an Item
    Public LIST<Item_Question__c> questionsForAnItem(String itemId){
        return [Select Id, Question_Level__c, item__c, item__r.item_name__c,IQ_Order__c,Question__c, Question__r.Event__c, Question__r.Id, Question__r.Name, Question__r.Answer_Type__c, Question__r.Question_Order__c, Question__r.Question_Text__c, (SELECT ID,NAME,Item_Question__c,Answer__c,UAnswer_Text__c,User__c FROM User_Answers__r ) FROM Item_Question__c WHERE item__c =: itemId];
    }
    
      // Item Questions Belongs to an Event
    Public LIST<Item_Question__c> questionsForEvent(String eventId){
        system.debug('  EVENT ID IN DAO '+eventId);
        return [Select Id, Question_Level__c, item__c, item__r.item_name__c,IQ_Order__c,Question__c, Question__r.Event__c, Question__r.Id, Question__r.Name, Question__r.Answer_Type__c, Question__r.Question_Order__c, Question__r.Question_Text__c, (SELECT ID,NAME,Item_Question__c,Answer__c,UAnswer_Text__c,User__c FROM User_Answers__r ) FROM Item_Question__c WHERE Event__c =: eventId AND Question_Level__c =: 'Event Level' AND Item__c =: NULL];
    }

 
 //---------------------- This method is Insert/Update Question-------------------------  

 Public  List<Database.upsertResult> srList{get;set;}
   
    Public List<Database.upsertResult> UpsertItemQuestion(List<Item_Question__c> itmque)
     {
    
         system.debug('========ItemQuestionlist' +itmque);
         srList = new List<Database.upsertResult>();
         return  srList = Database.upsert(itmque, false);
         
     }
     
    


     //----------------------------Method to delete ItemQuestions-------------------------------------------
        
        public LIST<Database.DeleteResult> deleteitmque(LIST<Item_Question__c> delitemquelist ){
        
            Database.DeleteResult[] DR_Dels = Database.Delete(delitemquelist,false);
            return  DR_Dels ;
        
        }
        
        
         




}