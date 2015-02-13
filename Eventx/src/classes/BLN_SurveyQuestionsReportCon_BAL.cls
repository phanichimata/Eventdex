/***********************************************************************************************
*   Controller Name : BLN_SurveyQuestionsReportCon_BAL
*   Date            : 01/12/2015
*   Author          : Manasa Gandham
*   Purpose         : This class is to get the list of Survey Questions
*   Change History  : 01/12/2015
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*    01/12/2015             Manasa Gandham                 To Create Page
*  
**************************************************************************************************/

public without sharing class BLN_SurveyQuestionsReportCon_BAL{

    public BLN_SurveyQuestionsReportCon_BAL(){
    
    }
    
    public BLN_Question_DAO questionDAOClass{get; set;}
    public BLN_Item_Question_DAO itemQuestionDAOClass{get; set;}
    public BLN_Item_DAO itemDAOClass{get; set;}
    
    public LIST<Item_Question__c> surveyQuestionsForEvent(String eventId){
    
        questionDAOClass= new BLN_Question_DAO();
        itemQuestionDAOClass= new BLN_Item_Question_DAO();
        LIST<Item_Question__c> itemQuestionsListDummy= new LIST<Item_Question__c>();
        LIST<Item_Question__c> itemQuestionsList= new LIST<Item_Question__c>();
        LIST<Question__c> questionsList= new LIST<Question__c>();
        MAP<Id, LIST<Answer__c>> answersListMAP= new MAP<Id, LIST<Answer__c>>();
        
        // To get Questions list along with User Answers
        itemQuestionsList= itemQuestionDAOClass.itmquestionslist(eventId, itemQuestionsListDummy);        
        system.debug(itemQuestionsList.size()+'  ITEM QUESTIONS LIST '+itemQuestionsList);
        // To get Questions list along with Answers
        questionsList= questionDAOClass.questionsForEvent(eventId);
        for(Question__c question: questionsList){
            LIST<Answer__c> ansList= new LIST<Answer__c>();
            ansList= question.Answers__r;
            answersListMAP.put(question.Id, ansList);
        }
        
        return itemQuestionsList;
    }
    
    
    
    public MAP<String, Decimal> bookedTickets(String itemId){
        Decimal bookedCount=0;
        Decimal responsesCount= 0;
        Decimal notGivenResponsesCount= 0;
        
        ticketDAOClass= new BLN_Ticket_DAO();
        MAP<String, Decimal> BookedTicketsMAP= new MAP<String, Decimal>();
        LIST<Ticket__c> bookedTickets= new LIST<Ticket__c>();
        bookedTickets= ticketDAOClass.bookedTicketsForItem(itemId);
        bookedCount= bookedTickets.size();
        for(Ticket__c tic: bookedTickets){
            if(tic.User_Answers__r.size() >0){
                responsesCount += responsesCount;
            }
            if(tic.User_Answers__r.size() <=0){
                notGivenResponsesCount += notGivenResponsesCount;
            }
        
        }
        BookedTicketsMAP.put('BookedCount', bookedCount);
        BookedTicketsMAP.put('ResponsesCount', responsesCount);
        BookedTicketsMAP.put('NotGivenResponsesCount', notGivenResponsesCount); 
        return BookedTicketsMAP;
    }
    
    
    public BLN_UserAnswers_DAO userAnswerDAOClass{get; set;}
    public LIST<AggregateResult> questionsResponses{get; set;}
    
    public Integer allUserAnswers(String itemQuestionId){
        userAnswerDAOClass= new BLN_UserAnswers_DAO();
        Integer allResponses= 0;
        allResponses= userAnswerDAOClass.allUserAnswersForItemQuestion(itemQuestionId);
        return allResponses;
    
    }
        
    public LIST<AggregateResult> userAnswersForItemQuestion(String itemQuestionId){
        questionsResponses= new LIST<AggregateResult>();
        userAnswerDAOClass= new BLN_UserAnswers_DAO();
        questionsResponses= userAnswerDAOClass.userAnswersForItemQuestion(itemQuestionId);
        return questionsResponses;
    }
    public LIST<User_Answer__c> userAnswersListForItemQuestion(String itemQuestionId){
        userAnswerDAOClass= new BLN_UserAnswers_DAO();
        LIST<User_Answer__c> userAnswersList= new LIST<User_Answer__c>();
        userAnswersList= userAnswerDAOClass.userAnswersList(itemQuestionId);
        return userAnswersList;
    }
    
    public LIST<BLN_Item__c> surveyQuestionsForItem(String eventId){
        itemDAOClass= new BLN_Item_DAO();
        LIST<BLN_Item__c> itemQuestionsList= new LIST<BLN_Item__c>();
        itemQuestionsList= itemDAOClass.getEventItems(eventId); 
        
        return itemQuestionsList;  
    }
    
    
    
    public BLN_Ticket_DAO ticketDAOClass{get; set;}
    
    public LIST<itemLevelSurvey> dataForItemSurvey(String itemId){
    
        itemDAOClass= new BLN_Item_DAO();
        ticketDAOClass= new BLN_Ticket_DAO();
        LIST<itemLevelSurvey> itemLevelSurveyList= new LIST<itemLevelSurvey>();
        LIST<BLN_Item__c> itemDetails= new LIST<BLN_Item__c>();
        itemDetails= itemDAOClass.itemDetailsForSurvey(itemId);
        LIST<Ticket__c> ticketsList= new LIST<Ticket__c>();
        LIST<Ticket__c> ticketsListToAdd= new LIST<Ticket__c>();
        ticketsList= ticketDAOClass.getTicketsforItem(itemId);            
            for(Ticket__c ticket: ticketsList){
               LIST<User_Answer__c> userAnswersList= new LIST<User_Answer__c>();
               userAnswersList= ticket.User_Answers__r;
               if(userAnswersList.size() != 0){
                   ticketsListToAdd.add(ticket);
               }
            }
        itemLevelSurveyList.add(new itemLevelSurvey(itemDetails[0], ticketsListToAdd));
        return itemLevelSurveyList;
    }
    
    public class itemLevelSurvey{
        public BLN_Item__c itemData{get; set;}
        public LIST<Ticket__c> ticketsData{get; set;}
        
        public itemLevelSurvey(BLN_Item__c itemData, LIST<Ticket__c> ticketsData){
            this.itemData= itemData;
            this.ticketsData= ticketsData;
        }
    }
    
    
    // Code For Survey By Attendee Tab
    
    public BLN_Gnuser_DAO gnUserDAOClass{get; set;}
    
    public LIST<surveyAttendeeInner> gnUsersForSurvey(String eventId){
        
        ticketDAOClass= new BLN_Ticket_DAO();
        gnUserDAOClass= new BLN_Gnuser_DAO();
        LIST<Ticket__c> ticketsList= new LIST<Ticket__c>();
        LIST<GN_User__c> gnUsersList= new LIST<GN_User__c>();
        MAP<Id, LIST<Ticket__c>> ticketsMAP= new MAP<Id, LIST<Ticket__c>>();
        SET<Id> gnUserIds= new SET<Id>();
        
        ticketsList= ticketDAOClass.ticketsListForEvent(eventId, NULL, NULL);        
        for(Ticket__c tic: ticketsList){
            LIST<Ticket__c> ticketsListToAdd= new LIST<Ticket__c>();
            gnUserIds.add(tic.Client_GN_User__c);
            if(ticketsMAP.containsKey(tic.Client_GN_User__c)){
                ticketsListToAdd= ticketsMAP.get(tic.Client_GN_User__c);
                ticketsListToAdd.add(tic);
                ticketsMAP.put(tic.Client_GN_User__c, ticketsListToAdd);
            }else if(! ticketsMAP.containsKey(tic.Client_GN_User__c)){
                ticketsListToAdd.add(tic);
                ticketsMAP.put(tic.Client_GN_User__c, ticketsListToAdd);
            }
        }
        gnUsersList= gnUserDAOClass.getGnuserList(gnUserIds);
        surveyAttendeeInnerList= new LIST<surveyAttendeeInner>();
        
        for(GN_User__c gnUser: gnUsersList){
            LIST<Ticket__c> ticketsListToAdd= new LIST<Ticket__c>();
            ticketsListToAdd= ticketsMAP.get(gnUser.Id);
            if(ticketsListToAdd.size() > 0){
                surveyAttendeeInnerList.add(new surveyAttendeeInner(gnUser, ticketsListToAdd));
            }
        }
        return surveyAttendeeInnerList;
    }
    
    public LIST<surveyAttendeeInner> surveyAttendeeInnerList{get; set;}
    public class surveyAttendeeInner{
        
        public GN_User__c gnUserData{get; set;}
        public LIST<Ticket__c> ticketsData{get; set;}
        
        public surveyAttendeeInner(GN_User__c gnUserData, LIST<Ticket__c> ticketsData){
            this.gnUserData= gnUserData;
            this.ticketsData= ticketsData;
        }
    
    }
    
    public LIST<itemQuestionsInner> allTypeQuestions(string eventId){
        itemDAOClass= new BLN_Item_DAO();
        LIST<BLN_Item__c> itemQuestionsList= new LIST<BLN_Item__c>();
        LIST<itemQuestionsInner> itemQuestionsInnerList= new LIST<itemQuestionsInner>();
        itemQuestionsList= itemDAOClass.getEventItems(eventId); 
        
        for(BLN_Item__c item: itemQuestionsList){
            if(item.Item_Question__r.size() >0){
                itemQuestionsInnerList.add(new itemQuestionsInner('Ticket Level', item, item.Item_Question__r)); 
            }       
        }
        
        itemQuestionDAOClass= new BLN_Item_Question_DAO();
        LIST<Item_Question__c> questionsList= new LIST<Item_Question__c>();
        questionsList= itemQuestionDAOClass.questionsForEvent(eventId);
        
        itemQuestionsInnerList.add(new itemQuestionsInner('Event Level', new BLN_Item__c(), questionsList));         
        
        return itemQuestionsInnerList;
    }    
    
    public LIST<Item_Question__c> itemQuestionsForItem(String itemId){
    
        itemQuestionDAOClass= new BLN_Item_Question_DAO();
        LIST<Item_Question__c> questionsList= new LIST<Item_Question__c>();
        questionsList= itemQuestionDAOClass.questionsForAnItem(itemId);
        
        return questionsList;
    }
    
    public LIST<Item_Question__c> eventLevelQuestions(String eventId){
        system.debug('  EVENT IN BAL '+eventId);
        itemQuestionDAOClass= new BLN_Item_Question_DAO();
        LIST<Item_Question__c> questionsList= new LIST<Item_Question__c>();
        questionsList= itemQuestionDAOClass.questionsForEvent(eventId);
        system.debug(questionsList.size()+'  QUESTION IN BAL '+questionsList);
        return questionsList;
    }
  
    public class itemQuestionsInner{
        public String levelType{get; set;}
        public BLN_Item__c itemData{get; set;}
        public LIST<Item_Question__c> itemQuestionsData{get; set;}
        
        public itemQuestionsInner(String levelType, BLN_Item__c itemData, LIST<Item_Question__c> itemQuestionsData){
            this.levelType= levelType;
            this.itemData= itemData;
            this.itemQuestionsData= itemQuestionsData;
        }
    
    }
}