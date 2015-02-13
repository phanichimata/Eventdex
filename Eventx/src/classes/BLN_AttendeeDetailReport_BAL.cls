/***********************************************************************************************
*   Controller Name : BLN_AttendeeDetailReport_BAL
*   Date            : 10/31/2014
*   Author          : Manasa Gandham
*   Purpose         : This class is to display the Attendee Details Report
*   Change History  : 10/31/2014
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*    10/31/2014              Manasa Gandham                 To Create Page
*  
**************************************************************************************************/

public without sharing class BLN_AttendeeDetailReport_BAL{

    public BLN_AttendeeDetailReport_BAL(){
    
    }  
    public BLN_Ticket_DAO ticketsDAOClass{get; set;}
    //public BLN_User_Ext_DAO userExtDAOClass{get; set;}
    public BLN_Company_Ext_DAO companyExtDAOClass{get; set;}
    public BLN_Company_DAO companyDiversityDAOClass{get; set;}
    public BLN_UserAnswers_DAO userAnswersDAOClass{get; set;}
    
    public LIST<LIST<AttendeeDetailInner>> ticketsListForEvent(String EventId, Date FromDate, Date ToDate, String SearchString){
        
        ticketsDAOClass= new BLN_Ticket_DAO();
        //userExtDAOClass= new BLN_User_Ext_DAO();
        companyExtDAOClass= new BLN_Company_Ext_DAO();
        companyDiversityDAOClass= new BLN_Company_DAO();
        userAnswersDAOClass= new BLN_UserAnswers_DAO();
        
        LIST<Ticket__c> ticksList= new LIST<Ticket__c>();
        ticksList= ticketsDAOClass.ticketsListForEvent(EventId, FromDate, ToDate);
        SET<Id> UserIds= new SET<Id>();
        SET<Id> CompanyIds= new SET<Id>();
        SET<Id> GNUserIds= new SET<Id>();
        SET<Id> itemIds= new SET<Id>();
       // MAP<String, User_Ext__c> UserExtsMAP= new MAP<String, User_Ext__c>();
        MAP<String, Company_Ext__c> CompanyExtsMAP= new MAP<String, Company_Ext__c>();        
        MAP<String, LIST<Company_Diversity__c>> diversityListMAP= new MAP<String, LIST<Company_Diversity__c>>();
        
        for(Ticket__c tic: ticksList){
            UserIds.add(tic.Client_GN_User__r.user__r.Id);
            CompanyIds.add(tic.Client_Company__r.Id);
            GNUserIds.add(tic.Client_GN_User__c);
            itemIds.add(tic.item__c);
        }
        
        /*
        LIST<User_Ext__c> UserExtsList= new LIST<User_Ext__c>();
        UserExtsList= userExtDAOClass.userExtsForUserIds(UserIds);
        for(User_Ext__c userExt: UserExtsList){
            UserExtsMAP.put(userExt.User__c, userExt);
        
        }
        */
        
        LIST<Company_Ext__c> companyExtsList= new LIST<Company_Ext__c>();
        companyExtsList= companyExtDAOClass.companyExtsForCompanyIds(CompanyIds);
        for(Company_Ext__c company: companyExtsList){
            CompanyExtsMAP.put(company.Company__c, company);
        }
        LIST<Company__c> companyDiversityList= new LIST<Company__c>();
        List<Id> compnaylist= new List<id>();
        compnaylist.addAll(CompanyIds);
        companyDiversityList= companyDiversityDAOClass.companiesForEvent(compnaylist);
        for(Company__c company: companyDiversityList){
            diversityListMAP.put(company.Id, company.Company_Diversity__r);
        }
        
        MAP<Id, LIST<User_Answer__c>> userAnswersMAP= new MAP<Id, LIST<User_Answer__c>>();
        LIST<User_Answer__c> userAnswersList= new LIST<User_Answer__c>();
        userAnswersList= userAnswersDAOClass.userAnswersForTickets(GNUserIds, itemIds, EventId);
        
        for(User_Answer__c ans: userAnswersList){
            LIST<User_Answer__c> userAnsList= new LIST<User_Answer__c>();
            if(userAnswersMAP.containsKey(ans.Item_Question__r.Item__c)){
                userAnsList= userAnswersMAP.get(ans.Item_Question__r.Item__c);
                userAnsList.add(ans);
                userAnswersMAP.put(ans.Item_Question__r.Item__c, userAnsList);
            }else{
                userAnsList.add(ans);
                userAnswersMAP.put(ans.Item_Question__r.Item__c, userAnsList);
            }
        }        
        system.debug(userAnswersMAP.size()+'   USER ANSWERS MAP  '+userAnswersMAP);
        LIST<LIST<AttendeeDetailInner>> AttendeeDetailInnerListOfList= new LIST<LIST<AttendeeDetailInner>>();        
        LIST<AttendeeDetailInner> AttendeeDetailInnerList999= new LIST<AttendeeDetailInner>();
        for(Ticket__c tic: ticksList){
            LIST<User_Answer__c> itemAnsList= new LIST<User_Answer__c>();
            LIST<User_Answer__c> userAnsList= new LIST<User_Answer__c>();  
            if(userAnswersMAP.get(tic.item__c) != NULL){ 
                itemAnsList= userAnswersMAP.get(tic.item__c);         
                for(User_Answer__c ans: itemAnsList){
                    if(tic.Client_GN_User__c == ans.User__c){
                        userAnsList.add(ans);
                    }
                }
            }
            //AttendeeDetailInnerList999.add(new AttendeeDetailInner(tic, UserExtsMAP.get(tic.Client_GN_User__r.user__r.Id), CompanyExtsMAP.get(tic.Client_Company__r.Id), diversityListMAP.get(tic.Client_Company__r.Id)));
            AttendeeDetailInnerList999.add(new AttendeeDetailInner(tic, CompanyExtsMAP.get(tic.Client_Company__r.Id), diversityListMAP.get(tic.Client_Company__r.Id), userAnsList));
            if(AttendeeDetailInnerList999.size() == 999){
                AttendeeDetailInnerListOfList.add(AttendeeDetailInnerList999);
                AttendeeDetailInnerList999= new LIST<AttendeeDetailInner>();
            }
        }
        if(AttendeeDetailInnerList999.size() != NULL){
                AttendeeDetailInnerListOfList.add(AttendeeDetailInnerList999);
                AttendeeDetailInnerList999= new LIST<AttendeeDetailInner>();
            }
        
        return AttendeeDetailInnerListOfList;
        }
        
        public Class AttendeeDetailInner{
            public LIST<User_Answer__c> uans{get;set;}
            public LIST<Question__c> qust{get;set;}
            public Ticket__c ticketData{get; set;}
            //public User_Ext__c userExtData{get; set;} User_Ext__c userExtData, 
            public Company_Ext__c companyExtData{get; set;}
            public LIST<Company_Diversity__c> companyDiversityData{get; set;}
            
            public AttendeeDetailInner(Ticket__c ticketData, Company_Ext__c companyExtData, LIST<Company_Diversity__c> companyDiversityData, LIST<User_Answer__c> uans){
                
                this.ticketData= ticketData;
                //this.userExtData= userExtData;
                this.companyExtData= companyExtData;
                this.companyDiversityData= companyDiversityData;
                this.uans= uans;
            }
        }
}