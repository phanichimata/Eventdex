public class BatchexeforSurveys implements Database.Batchable<BLN_Quick_Registration_BAL.surveyQuestions>
{
  
  public List<BLN_Quick_Registration_BAL.surveyQuestions> itsList{get;set;}
  public void iterateSurveys(List<BLN_Quick_Registration_BAL.surveyQuestions> ItS){
   system.debug('FFFFFFFFFFFFFF 1111111111'+ItS);
   itsList =ItS;
    
  }
   
  public Iterable<BLN_Quick_Registration_BAL.surveyQuestions> start(Database.BatchableContext info){
     system.debug('FFFFFFFFFFFFFF 2222222222222'+info);
     return itsList ;
  }
  
   
  public void execute(Database.BatchableContext BC, List<BLN_Quick_Registration_BAL.surveyQuestions> scope){
    // Inserting Survey Questions 
       BLN_SurveyQuestions_BAL SQBal = new BLN_SurveyQuestions_BAL();
       
           for(BLN_Quick_Registration_BAL.surveyQuestions sur :scope ){
                for(BLN_RegistrationnewCon.UserAnswerInnerClass UAnswer : sur.listinn){
                  Id ItemQuestionId;
                   id tcis ;
                   if(sur.iseventlevel){
                      ItemQuestionId = SQBal.geteventQuestion(sur.eventid,UAnswer.Question.id);
                      system.debug('WWWWWWWWWWWWWW '+ItemQuestionId);
                   }else{
                      ItemQuestionId  = SQBal.getItemQuestion(sur.tick.Id,UAnswer.Question.id);
                      tcis  = sur.ticket.id;
                      system.debug('WWWWWWWWWWWWWW 122222222'+ItemQuestionId);
                   }
                   
                   if(UAnswer.Question.Answer_Type__c=='Checkboxes'){
                         for(String s: UAnswer.SelectedAnswerCheck){
                           BLN_StatusMessage UAMsg = SQBal.insertUserAnswer(sur.UserId,s,ItemQuestionId,tcis );    
                          system.debug('PPPPPPPPPPP 111111 checkbox  '+UAMsg ); 
                     }    
                    }else{
                      BLN_StatusMessage UAMsg = SQBal.insertUserAnswer(sur.UserId,UAnswer.SelectedAnswer,ItemQuestionId,tcis  );        
                     system.debug('PPPPPPPPPPP 111111 Normal '+UAMsg ); 
                    }
                }
          }
   }
 
  
  public void finish(Database.BatchableContext BC)
  {
    //send completion email
  }
 }