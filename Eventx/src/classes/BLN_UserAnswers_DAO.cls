public with sharing class BLN_UserAnswers_DAO{

/***************************************************************************************************************************************************************************************************
*   Author                  : Mahesh Sakunala
*   Date                    : 28/07/2014 
*   Purpose                 : This class is for inserting and fetching User Answers for Survey Questions.
*   Last Modified           : Mahesh Sakunala - 28/07/2014
*****************************************************************************************************************************************************************************************************/

//------------------------------------------------------------- Method to insert User Answer Start --------------------------------------------------------------------------------     
     public BLN_StatusMessage insertUserAnswer(Id UserId,String AnswerId, Id ItemQuestionId,id tid){
         
         // Fetching Answer Details using Answer Id
         LIST<Answer__c> Answer = new LIST<Answer__c>();
         Answer = [SELECT ID,NAME,Answer_Text__c,Answer_Order__c,Answer_Default__c 
                   FROM Answer__c 
                   WHERE ID =: AnswerId];
         
         User_Answer__c UAnswer = new User_Answer__c();
         
         UAnswer.User__c = UserId;
          UAnswer.Ticket__c = tid; // phani added this
         UAnswer.Item_Question__c = ItemQuestionId;
         if(Answer.size() > 0){
             UAnswer.Answer__c =  Answer[0].Id;
             UAnswer.UAnswer_Text__c = Answer[0].Answer_Text__c;
         }
         else{
             UAnswer.UAnswer_Text__c = AnswerId;
         }
         
         Database.Saveresult Response = Database.Insert(UAnswer,false);
         return new BLN_StatusMessage(Response);
     }
//------------------------------------------------------------- Method to insert User Answer End --------------------------------------------------------------------------------    

//------------------------------------------------------------- Method to Fetch User Answer Start --------------------------------------------------------------------------------     
     public LIST<User_Answer__c> fetchUserAnswer(Id UserId){
         
         // Fetching User Answer Details using User Id
         LIST<User_Answer__c> UserAnswer = [SELECT ID,NAME,User__c,Item_Question__c,Answer__c,Answer__r.Answer_Text__c,UAnswer_Text__c 
                                            FROM User_Answer__c
                                            WHERE User__c =: UserId];
         return UserAnswer;
     }
//------------------------------------------------------------- Method to Fetch User Answer End --------------------------------------------------------------------------------  
    
    // To fetch the User Answers based on the users and items written by Manasa Gandham 
    public LIST<User_Answer__c> userAnswersForTickets(SET<Id> GNUserIds,SET<Id> itemIds, String EventId){
        LIST<User_Answer__c> userAnswersList= new LIST<User_Answer__c>();
        userAnswersList= [SELECT Id, Item_Question__r.Item__c, Item_Question__c, Item_Question__r.Question__r.Question_Text__c, UAnswer_Text__c, Answer__c, Answer__r.Answer_Text__c, User__c
                          FROM User_Answer__c 
                          WHERE User__c IN :GNUserIds 
                          AND Item_Question__r.Item__c IN: itemIds 
                          AND Item_Question__r.Item__r.Event__c =: EventId];
        return userAnswersList;
    }
    
    public LIST<AggregateResult> userAnswersForItemQuestion(String itemQuestionId){
        LIST<AggregateResult> answersAggregateResult= new LIST<AggregateResult>();
        answersAggregateResult= [SELECT COUNT(Id) selCount, UAnswer_Text__c ansType
                                 FROM User_Answer__c 
                                 WHERE Item_Question__c =: itemQuestionId
                                 GROUP BY UAnswer_Text__c];
        return answersAggregateResult;
    }
    
    public Integer allUserAnswersForItemQuestion(String itemQuestionId){
        LIST<AggregateResult> answersAggregateResult= new LIST<AggregateResult>();
        Integer allResponses= 0;
        answersAggregateResult= [SELECT COUNT(Id)
                               FROM User_Answer__c 
                               WHERE Item_Question__c =: itemQuestionId];
        allResponses= Integer.valueOf(answersAggregateResult[0].get('expr0'));
        return allResponses;
    }
    
    public LIST<User_Answer__c> userAnswersList(String itemQuestionId){
        LIST<User_Answer__c> answersList= new LIST<User_Answer__c>();
        answersList= [SELECT Id, UAnswer_Text__c, User__c, User__r.First_Name__c, User__r.Last_Name__c, User__r.Email__c,  User__r.Phone__c, Ticket__r.name
                      FROM User_Answer__c 
                      WHERE Item_Question__c =: itemQuestionId
                      ORDER BY UAnswer_Text__c];
        return answersList;
    }
}