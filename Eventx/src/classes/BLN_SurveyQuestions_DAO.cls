public  without sharing class BLN_SurveyQuestions_DAO {

  
   //-------------- This method is to retrieve QuestionsList for the event------------.
    
    public LIST<Question__c> questionslist(String selectedeventid ,LIST<Question__c> questionslist ){  
        //LIST<Question__c> questionslistTemp=new LIST<Question__c>();
        return questionslist= [SELECT ID,NAME,Event__c,Answer_Type__c,Question_Text__c ,Question_Order__c, (SELECT ID,NAME,Answer_Text__c,Answer_Order__c,Answer_Default__c FROM Answers__r ORDER BY Answer_Order__c ),(SELECT ID,Item__r.item_name__c,Item__r.Id,isRequired__c,Visibility__c,IQ_Order__c,Event__c,Question_Level__c From Item_Question__r ORDER BY Item__r.item_name__c) FROM Question__c WHERE Event__c =:selectedeventid ORDER BY  Question_Order__c DESC];//DESC
    }
 
    //---------------------- This method is Insert/Update Question-------------------------  
  
    Public  List<Database.upsertResult> srList{get;set;}
   
    public List<Database.upsertResult> UpsertQuestion(List<Question__c> ques){
         system.debug('========questionslist ' +ques);
         srList = new List<Database.upsertResult>();
         return  srList = Database.upsert(ques, false);
         
     }
     
 //---------------------- This method is Delete Question-------------------------  

    public LIST<Database.DeleteResult> deleteque(LIST<Question__c> delquelist ){
        system.debug('=========delquelist ================ ' + delquelist );
        Database.DeleteResult[] DR_Dels = Database.Delete(delquelist,false);
        return  DR_Dels;
    }
   
   
// Edit by Mahesh Sakunala Start
//------------------------------------------- Method to retrieve QuestionsLists for the event based on Item Id Start ---------------------------------------------------------------

     public MAP<Id,LIST<Question__c>> getItemQuestions(SET<Id> ItemIds, String selectedeventid){ 
        
        MAP<Id,Question__c> QMap = new  MAP<Id,Question__c>();
        LIST<Question__c> Qlist = new LIST<Question__c>();
        
        Qlist = [SELECT ID,NAME,Event__c,Answer_Type__c,Question_Text__c ,Question_Order__c,(SELECT ID,NAME,Answer_Text__c,Answer_Order__c,Answer_Default__c FROM Answers__r ORDER BY Answer_Order__c ),
                 (SELECT ID,Item__r.item_name__c,Item__r.Id,isRequired__c,Visibility__c,IQ_Order__c,Question__c,Question__r.Event__c,Question__r.Answer_Type__c,Question__r.Question_Text__c,Question__r.Question_Order__c,Event__c,Question_Level__c From Item_Question__r WHERE Visibility__c=: TRUE AND Question_Level__c ='Ticket Level' ORDER BY Item__r.item_name__c) 
                 FROM Question__c 
                 WHERE Event__c =: selectedeventid 
                 ORDER BY Question_Order__c];
                 
        for(Question__c q: Qlist){
            QMap.put(q.id,q);
        }

        MAP<Id,LIST<Question__c>> QuestionsMap = new  MAP<Id,LIST<Question__c>>();
        
        for(Id ItemId: ItemIds){
            LIST<Question__c> QuestionList = new LIST<Question__c>();
            for(Item_Question__c Iq: [SELECT ID,Item__r.id,Item__r.item_name__c,isRequired__c,Visibility__c,IQ_Order__c,Event__c,Question_Level__c,Question__c,Question__r.Event__c,Question__r.Answer_Type__c,Question__r.Question_Text__c,Question__r.Question_Order__c
                                      FROM Item_Question__c 
                                      WHERE Visibility__c=: TRUE 
                                      AND Item__r.id =: ItemId
                                      ORDER BY Item__r.id,Question__r.Question_Order__c]){
                
                QuestionList.add(QMap.get(iq.Question__c));                       
            }
            QuestionsMap.put(ItemId,QuestionList);
        } 
        return QuestionsMap;
     }
//------------------------------------------- Method to retrieve QuestionsLists for the event based on Item Id End ---------------------------------------------------------------

//------------------------------------------------------------- Method to fetch Item Question Start --------------------------------------------------------------------------------          
public Id getItemQuestion(String ItemId, String QuestionId){
    Item_Question__c IQuestion = new Item_Question__c();
    IQuestion = [SELECT ID,Item__r.id,Item__r.item_name__c,isRequired__c,Visibility__c,IQ_Order__c,Event__c,Question_Level__c,Question__r.id,Question__c,Question__r.Event__c,Question__r.Answer_Type__c,Question__r.Question_Text__c,Question__r.Question_Order__c
                 FROM Item_Question__c  
                 WHERE Item__r.id =: ItemId
                 AND Question__r.id =: QuestionId];
    if(IQuestion != NULL){
        return IQuestion.Id;
    }else{
        return null;
    }
}
//------------------------------------------------------------- Method to fetch Item Question End --------------------------------------------------------------------------------          


public Id geteventQuestion(String eveid, String QuestionId){
    Item_Question__c IQuestion = new Item_Question__c();
    IQuestion = [SELECT ID,Item__r.id,Item__r.item_name__c,isRequired__c,Visibility__c,IQ_Order__c,Event__c,Question_Level__c,Question__r.id,Question__c,Question__r.Event__c,Question__r.Answer_Type__c,Question__r.Question_Text__c,Question__r.Question_Order__c
                 FROM Item_Question__c  
                 WHERE Event__c =: eveid
                 AND Question__r.id =: QuestionId AND Item__c =null];
    if(IQuestion != NULL){
        return IQuestion.Id;
    }else{
        return null;
    }
}





//------------------------------------------------------------- Method to fetch Event Question Start --------------------------------------------------------------------------------          
public Id getEventQuestion(String QuestionId){
    Item_Question__c IQuestion = new Item_Question__c();
    IQuestion = [SELECT ID,Item__r.id,Item__r.item_name__c,isRequired__c,Visibility__c,IQ_Order__c,Event__c,Question_Level__c,Question__r.id,Question__c,Question__r.Event__c,Question__r.Answer_Type__c,Question__r.Question_Text__c,Question__r.Question_Order__c
                 FROM Item_Question__c  
                 WHERE Question__r.id =: QuestionId LIMIT 1];
    if(IQuestion != NULL){
        return IQuestion.Id;
    }else{
        return null;
    }
}
//------------------------------------------------------------- Method to fetch Event Question End -------------------------------------------------------------------------------- 

//------------------------------------------------------------- Method to Event Level Questions Start --------------------------------------------------------------------------------          
public LIST<Question__c> getEventQuestions(String EventId){
    LIST<Question__c> Questionlist = new LIST<Question__c>();
    LIST<Item_Question__c> ItemQuestionlist = new LIST<Item_Question__c>();
    LIST<Id> QIds = new  LIST<Id>();    
    ItemQuestionlist =[SELECT ID,Item__r.id,Item__r.item_name__c,isRequired__c,Visibility__c,IQ_Order__c,Event__c,Question_Level__c,Question__c,Question__r.Event__c,Question__r.Answer_Type__c,Question__r.Question_Text__c,Question__r.Question_Order__c
                                              FROM Item_Question__c 
                                              WHERE Visibility__c=: TRUE 
                                              AND Event__r.id =: EventId
                                              AND Question_Level__c = 'Event Level'
                                              ORDER BY Item__r.id,Question__r.Question_Order__c];  
    for(Item_Question__c iq: ItemQuestionlist){
        QIds.add(iq.Question__r.Id);
    }    
        
    Questionlist = [SELECT ID,NAME,Event__c,Answer_Type__c,Question_Text__c ,Question_Order__c,(SELECT ID,NAME,Answer_Text__c,Answer_Order__c,Answer_Default__c FROM Answers__r ORDER BY Answer_Order__c ),
                   (SELECT ID,Item__r.item_name__c,Item__r.Id,isRequired__c,Visibility__c,IQ_Order__c,Question__c,Question__r.Event__c,Question__r.Answer_Type__c,Question__r.Question_Text__c,Question__r.Question_Order__c,Event__c,Question_Level__c From Item_Question__r WHERE Visibility__c=: TRUE ORDER BY Item__r.item_name__c) 
                    FROM Question__c 
                    WHERE Id IN: QIds
                    ORDER BY Question_Order__c];
                    
                    
    system.debug('DAO Event Level Questions'+Questionlist);
    return Questionlist;
}
//------------------------------------------------------------- Method to Event Level Questions End --------------------------------------------------------------------------------   
   
// Edit by Mahesh Sakunala End

}