public class  BLN_SurveyQuestionsReportCon{
    
    public Decimal allResponses{get; set;}
    public Decimal notGivenResponses{get; set;}
    public Decimal bookedTickets{get; set;}
    public LIST<User_Answer__c> userAnswersList{get; set;}
    public String itemQuestionId{get; set;}
    public String itemId{get; set;}
    public String itemAnswerType{get; set;}
    public Integer summaryCount{get;set;}
    public Decimal responseGivenPercent{get; set;}
    public Decimal responseNotGivenPercent{get; set;}
    public MAP<Id, Item_Question__c> questionsForItemMAP{get; set;}
    public Integer attendeeNumber{get; set;}
    public String selectedItemName{get; set;}
    
    public PageReference surveyDataForQuestion(){
        
        showQuestionLevelSurvey= FALSE;
        showQuestionDetails= TRUE;
        showItemLevelSurvey= FALSE;
        showItemDetails= FALSE;
        showAttendeeLevelSurvey= FALSE;
        
        //itemLevelSurveyList= new LIST<BLN_SurveyQuestionsReportCon_BAL.itemLevelSurvey>();
        //surveyAttendeeInnerList= new LIST<BLN_SurveyQuestionsReportCon_BAL.surveyAttendeeInner>();
        responsesInnerList= new LIST<responsesInner>();
        userAnswersList= new LIST<User_Answer__c>();

        itemId= ApexPages.currentPage().getParameters().get('itemId');
        system.debug(ApexPages.currentPage().getParameters().get('itemId')+'   ITEM ID FROM LIST  '+itemId);

        LIST<Item_Question__c> questions= new LIST<Item_Question__c>();
        surveyQuestionBAL= new BLN_SurveyQuestionsReportCon_BAL();
        if(itemId != NULL && itemId != ''){
            questions= surveyQuestionBAL.itemQuestionsForItem(itemId);
        }else if(itemId == NULL || itemId == ''){
            system.debug('  SELECTED EVENT '+selectedEvent);
            questions= surveyQuestionBAL.eventLevelQuestions(selectedEvent);
        }
        system.debug('  QUESTIONS SIZE '+questions.size());
        
        questionsForItem= new LIST<selectoption>();
        questionsForItemMAP= new MAP<Id, Item_Question__c>();
        for(Item_Question__c itemQuestion: questions){
            questionsForItem.add(new SelectOption(itemQuestion.Id, itemQuestion.Question__r.Question_Text__c));
            questionsForItemMAP.put(itemQuestion.Id, itemQuestion);
            selectedQuestion= itemQuestion.Id;
        }
        summaryResponseData();
        
        return null;
    }
    
    public LIST<SelectOption> questionsForItem{get; set;}
    public String selectedQuestion{get; set;}    
    
    
    public pagereference summaryResponseData(){
        
        showAttendeeLevelSurvey= FALSE;
        surveyQuestionBAL= new BLN_SurveyQuestionsReportCon_BAL();
        
        //itemLevelSurveyList= new LIST<BLN_SurveyQuestionsReportCon_BAL.itemLevelSurvey>();
        //surveyAttendeeInnerList= new LIST<BLN_SurveyQuestionsReportCon_BAL.surveyAttendeeInner>();
        responsesInnerList= new LIST<responsesInner>();
        userAnswersList= new LIST<User_Answer__c>();
        
        LIST<AggregateResult> userAnswersResponses= new LIST<AggregateResult>();
        userAnswersResponses= surveyQuestionBAL.userAnswersForItemQuestion(selectedQuestion);
        itemAnswerType= questionsForItemMAP.get(selectedQuestion).Question__r.Answer_Type__c;
        selectedItemName= questionsForItemMAP.get(selectedQuestion).item__r.item_name__c;
        allResponses= 0;
        bookedTickets= 0;
        notGivenResponses=0;
        surveyQuestionBAL= new BLN_SurveyQuestionsReportCon_BAL();
        MAP<String, Decimal> BookedTicketsMAP= new MAP<String, Decimal>();
        BookedTicketsMAP= surveyQuestionBAL.bookedTickets(selectedQuestion);
        bookedTickets= BookedTicketsMAP.get('BookedCount');
        allResponses= BookedTicketsMAP.get('ResponsesCount');
        notGivenResponses= BookedTicketsMAP.get('NotGivenResponsesCount');
        
        system.debug(selectedQuestion+'  SELECTED QUESTION  '+allResponses+' BOOKED TICKETS  '+bookedTickets);
        if(allResponses != 0 && bookedTickets !=0){
            responseGivenPercent= (allResponses*100)/ bookedTickets; 
        }else{
            responseGivenPercent= 0;
        }
          
               
        responseNotGivenPercent= 100- responseGivenPercent;
        system.debug(responseGivenPercent+' RESPONSE NOT GIVEN PERCENTAGE  '+responseNotGivenPercent);
        system.debug('  ALL RESPONSES '+allResponses);
        for(AggregateResult agg: userAnswersResponses){
            String ansType= String.valueOf(agg.get('ansType'));
            String countString= String.valueOf(agg.get('selCount'));
            Integer ansCount= Integer.valueOf(countString);
            Decimal percent=0;
            if(ansCount != 0 && allResponses != 0){
                percent= ((ansCount*100)/allResponses); //
            }
            system.debug(ansCount+'   ANS STRING  '+allResponses+'   '+'   '+percent);
            responsesInnerList.add(new responsesInner(ansType, ansCount, percent));
        }
        detailResponseData();
        return null;
    }
    
    public pagereference detailResponseData(){
                
        showAttendeeLevelSurvey= FALSE;
        
        //itemLevelSurveyList= new LIST<BLN_SurveyQuestionsReportCon_BAL.itemLevelSurvey>();
        //surveyAttendeeInnerList= new LIST<BLN_SurveyQuestionsReportCon_BAL.surveyAttendeeInner>();
        surveyQuestionBAL= new BLN_SurveyQuestionsReportCon_BAL();
        //responsesInnerList= new LIST<responsesInner>();
        userAnswersList= new LIST<User_Answer__c>();
        
        userAnswersList= surveyQuestionBAL.userAnswersListForItemQuestion(selectedQuestion);       
        return null;
    }
    
    
    
    public PageReference surveyDataForItem() {
    
        system.debug('  ITEM ID FOR SURVEY  '+ApexPages.currentPage().getParameters().get('itemId'));
        String itemId= ApexPages.currentPage().getParameters().get('itemId');
        itemLevelSurveyList= new LIST<BLN_SurveyQuestionsReportCon_BAL.itemLevelSurvey>();
        //surveyAttendeeInnerList= new LIST<BLN_SurveyQuestionsReportCon_BAL.surveyAttendeeInner>();
        //responsesInnerList= new LIST<responsesInner>();
        //userAnswersList= new LIST<User_Answer__c>();
        itemLevelSurveyList= surveyQuestionBAL.dataForItemSurvey(itemId);
        
        showQuestionLevelSurvey= FALSE;
        showQuestionDetails= FALSE;
        showItemLevelSurvey= FALSE;
        showItemDetails= TRUE;
        showAttendeeLevelSurvey= FALSE;
        return null;
    }



    public BLN_SurveyQuestionsReportCon(){
        
        EventDates= new BLN_Event__c();
        Cookie k = ApexPages.currentPage().getCookies().get('counter');
        if(k!=null){ 
            selectedEvent= k.getValue();
            surveyQuestionsList(); 
            surveyQuestionsListWithItem();
            surveyQuestionsWithAttendee();
        } 
    }
    
    public Boolean showQuestionLevelSurvey{get; set;}
    public Boolean showQuestionDetails{get; set;}
    public Boolean showItemLevelSurvey{get; set;}
    public Boolean showItemDetails{get; set;}
    public BLN_Event__c EventDates{get; set;}
    public String selectedEvent{get; set;}
    public LIST<Item_Question__c> questionsList{get; set;}
    public LIST<BLN_Item__c> itemQuestionsList{get; set;}
    public BLN_SurveyQuestionsReportCon_BAL surveyQuestionBAL{get; set;}
    public LIST<BLN_SurveyQuestionsReportCon_BAL.itemLevelSurvey> itemLevelSurveyList{get; set;}
    
    public pagereference surveyQuestionsList(){
        
        showQuestionLevelSurvey= TRUE;
        showQuestionDetails= FALSE;
        showItemLevelSurvey= FALSE;
        showItemDetails= FALSE;
        showAttendeeLevelSurvey= FALSE;
        
        surveyQuestionBAL= new BLN_SurveyQuestionsReportCon_BAL();
        itemQuestionsList= new LIST<BLN_Item__c>();
        system.debug('  SELECTED EVENT ID '+selectedEvent);
        itemQuestionsList= surveyQuestionBAL.surveyQuestionsForItem(selectedEvent);
        system.debug(itemQuestionsList.size()+'  QUESTIONS LIST '+itemQuestionsList);
        /*
            surveyQuestionBAL= new BLN_SurveyQuestionsReportCon_BAL();        
            questionsList= new LIST<Item_Question__c>();
            system.debug('  SELECTED EVENT ID '+selectedEvent);
            questionsList= surveyQuestionBAL.surveyQuestionsForEvent(selectedEvent);
            system.debug(questionsList.size()+'  QUESTIONS LIST '+questionsList);        
        */
        return null;
    }
    
    public LIST<BLN_SurveyQuestionsReportCon_BAL.itemQuestionsInner> itemQuestionsInnerList{get; set;}
    public pagereference surveyQuestionsListWithItem(){
        
        showQuestionLevelSurvey= TRUE;
        showQuestionDetails= FALSE;
        showItemLevelSurvey= TRUE;
        showItemDetails= FALSE;
        showAttendeeLevelSurvey= FALSE;
        
        itemQuestionsInnerList= new LIST<BLN_SurveyQuestionsReportCon_BAL.itemQuestionsInner>();
        surveyQuestionBAL= new BLN_SurveyQuestionsReportCon_BAL();
        //itemQuestionsList= new LIST<BLN_Item__c>();
        system.debug('  SELECTED EVENT ID '+selectedEvent);
        itemQuestionsInnerList= surveyQuestionBAL.allTypeQuestions(selectedEvent);
        system.debug(itemQuestionsList.size()+'  QUESTIONS LIST '+itemQuestionsList);
        showItemLevelSurvey= TRUE;
        showItemDetails= FALSE;
        return null;
    }
    
    public LIST<BLN_SurveyQuestionsReportCon_BAL.surveyAttendeeInner> surveyAttendeeInnerList{get; set;}
    public Boolean showAttendeeLevelSurvey{get; set;}

    public pagereference surveyQuestionsWithAttendee(){
    
        showQuestionLevelSurvey= TRUE;
        showQuestionDetails= FALSE;
        showItemLevelSurvey= FALSE;
        showItemDetails= FALSE;
        showAttendeeLevelSurvey= TRUE;
    
        surveyQuestionBAL= new BLN_SurveyQuestionsReportCon_BAL();
        
        //itemLevelSurveyList= new LIST<BLN_SurveyQuestionsReportCon_BAL.itemLevelSurvey>();
        surveyAttendeeInnerList= new LIST<BLN_SurveyQuestionsReportCon_BAL.surveyAttendeeInner>();
        //responsesInnerList= new LIST<responsesInner>();
        //userAnswersList= new LIST<User_Answer__c>();
        
        surveyAttendeeInnerList= surveyQuestionBAL.gnUsersForSurvey(selectedEvent);
        return null;
    }
    
    
    
    public BLN_UtillDisplayLinks   myticket { get; set; }
    public boolean isEventAdmin{get;set;}
    public boolean isBoothadmin{get;set;}
  
    public PageReference hideEventsTab() {
      Cookie k = ApexPages.currentPage().getCookies().get('counter');
     if(k!=null){ 
      selectedEvent = k.getValue();
       }
   
     BLN_PromoCode_BAL blneventdetailbal = New BLN_PromoCode_BAL();
     BLN_Event__c  se = new BLN_Event__c  ();
      try{
    se = blneventdetailbal.eventdetails(selectedEvent );
     }catch(exception e){}
      
     myticket = new BLN_UtillDisplayLinks();


     myticket.isReportsPageExpand='expand';
    myticket.isSurveyQuestionReportPage='active';
    myticket.tablabel='SurveyQuestion Report';
    myticket.EventId = selectedEvent ;
    
   try{
     myticket.eventName=se.NAme;
     myticket.userPermissions(userInfo.getUserId(),selectedEvent);
    }catch(exception e){}
     
     
        return null;
    }
    
    public LIST<responsesInner> responsesInnerList{get; set;}
    public Class responsesInner{
        public String answerType{get; set;}
        public Integer answerCount{get; set;}
        public Decimal answerPercentage{get; set;}
        
        public responsesInner(String answerType, Integer answerCount, Decimal answerPercentage){
            this.answerType= answerType;
            this.answerCount= answerCount;
            this.answerPercentage= answerPercentage;
        }
    }
    
    public pagereference exportSurveyQuestions(){
        
        system.debug(responsesInnerList.size()+'  '+userAnswersList.size()+'  QUESTION LEVEL SURVEY  '+showQuestionLevelSurvey);
        pageReference pg = page.BLN_SurveyQuestionsExport;
        return pg;
    }
    
    public BLN_EventDetails eventInfo{get; set;}
    public pagereference printSurveyQuestions(){
        
        BLN_Event_DAO eventDAOClass= new BLN_Event_DAO();
        eventInfo= new BLN_EventDetails();
        eventInfo.eventDetailsToDisplay(selectedEvent);
        pageReference pg = page.BLN_SurveyQuestionsPrint;    
        return pg;
    
    }
    
    
}