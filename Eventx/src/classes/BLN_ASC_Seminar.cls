@RestResource(urlMapping='/BLN_ASC_Seminar/*')
/***********************************************************************************************
*   Service Name : BLN_ASC_Seminar
*   Date            : 07/01/2015
*   Author          : Arindam Sarkar
*   Purpose         : This class is for getting all event seminars
* Reused classes    : BLN_SeminarsCon
************************************************************************************************/
  

    global with sharing class BLN_ASC_Seminar{
   
    @HttpPost  
    global static List<Container> doPost(){
        RestRequest req = RestContext.request;  
        String EventID = req.params.get('Event_Id');
        
             
        RestResponse response = RestContext.response; 
        BLN_SeminarsCon semcon=new BLN_SeminarsCon();
        semcon.selectedeventid=EventID;
        semcon.urlCheck = 'BLN_agenda';
        semcon.groupByoption='Track';
        semcon.gaterFields();
        semcon.onchangeAct();
        BLN_Event_DAO evdao=new BLN_Event_DAO();
        String timezone;
        List<BLN_Event__c> eve=evdao.getEventDetails(EventID);
        if(eve.size()>0)
        {
           timezone=eve[0].Time_Zone__c;
        }
        
        List<Container> conlist=new List<Container>();
        for(integer i=0;i<semcon.seminarInn.size();i++)
        {
           
           for(integer j=0;j<semcon.seminarInn[i].agendaList.size();j++){
           Container con=new Container();
           con.TrackName=semcon.seminarInn[i].trackName;
           for(Time_Slots__c tm:semcon.seminarInn[i].agendaList[j].Time_Slots__r)
           {
            con.AgendaID=semcon.seminarInn[i].agendaList[j].Id;
           con.ProgrammeName=semcon.seminarInn[i].agendaList[j].Name;
           Datetime startdate= tm.Slot_Start_date__c;
           String stringstartdate= startdate.format('yyyy-MM-dd', timezone); 
 
           con.ProgrammeDate=stringstartdate;
           String stringstarttime= startdate.format('hh:mm a',timezone);
           con.StartTime=stringstarttime;
           Datetime endtime= tm.Slot_End_date__c;
           String stringendtime= endtime.format('hh:mm a',timezone);
           con.EndTime=stringendtime;
           
           }
           
           con.GNUSERS=new List<GNUSER>();
           
           for(Participant__c pc:semcon.agendaParticipants.get(semcon.seminarInn[i].agendaList[j].id))
           {
              GNUSER gn=new GNUSER();
              gn.GNUSERID=pc.GN_User__c;
              gn.FirstName=pc.GN_User__r.First_Name__c;
              gn.LastName=pc.GN_User__r.Last_Name__c;
              gn.ParticipantRole=pc.Participant_Role__c==null?'':pc.Participant_Role__c;
              
              con.GNUSERS.add(gn);
           }
           
           con.ROOMS=new List<ROOM>();
           
           for(Time_Slots__c tm:semcon.seminarInn[i].agendaList[j].Time_Slots__r)
           {
           if(tm.Room__r.NAME!=null){
           ROOM r=new ROOM();
           r.ROOMNAME=tm.Room__r.NAME;
           r.ROOMNUMBER=tm.Room__r.Room_Number__c;
           con.ROOMS.add(r);}
           
           }
           
           
           
           conlist.add(con);
           }
        }
        
        return conlist;
        
        
      }
      
      
      
      global class Container
      {
        public String AgendaID{get;set;}
        public String ProgrammeName{get;set;}
        public String ProgrammeDate{get;set;}
        public String StartTime{get;set;}
        public String EndTime{get;set;}
        public List<GNUSER> GNUSERS{get;set;}
        public List<ROOM> ROOMS{get;set;}
        public String TrackName{get;set;}
        
      }
      
      global class GNUSER
      {
        public String GNUSERID{get;set;}
        public String FirstName{get;set;}
        public String LastName{get;set;}
        public String ParticipantRole{get;set;}
      }
      
      
      global class ROOM
      {
        public String ROOMNAME{get;set;}
        public String ROOMNUMBER{get;set;}
      }
      
      
    
      
      
      }