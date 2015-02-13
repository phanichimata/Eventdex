@istest(SeeAllData= true)
public class Test_BLN_SpeakersCon{
    static testmethod void Testmethod_BLN_SpeakersCon(){
    
        User U= new User();
        globalForTestClass globalTest= new globalForTestClass();
        U= globalTest.createUser();
        
        system.runas(U){
        
           NAICS_Code__c naicsCodeInfo1= new NAICS_Code__c();
            naicsCodeInfo1= globalTest.createNaicsCode();
            
            NAICS_Code__c naicsCodeInfo2= new NAICS_Code__c();
            naicsCodeInfo2= globalTest.createNaicsCode();
            
            Currency__c currenyInfo= new Currency__c();
            currenyInfo= globalTest.createCurrency();      
            
            Country__c countryInfo= new Country__c();
            countryInfo= globalTest.createCountry(currenyInfo.Id);  
            
            State__c stateInfo= new State__c ();
            stateInfo= globalTest.createState(countryInfo.Id);     
            
            Company__c companyInfo= new Company__c();
            companyInfo= globalTest.createCompany(u.Companyname);
            
            Company_Ext__c companyExtInfo= new Company_Ext__c();
            companyExtInfo= globalTest.createCompanyExt(companyInfo.Id, naicsCodeInfo1.Id, naicsCodeInfo2.Id, countryInfo.Id, stateInfo.Id); 
                     
            BLN_Event__c eventInfo= new  BLN_Event__c();
            eventInfo= globalTest.createEvent(countryInfo.Id, Stateinfo.Id ,CompanyInfo.id);    
             
            User userInfo= new User();
            userInfo= globalTest.createUserForGNUser();            
            
            GN_User__c  gnUserInfo= new GN_User__c();
            gnUserInfo= globalTest.createGNUser(userInfo, countryInfo.Id, stateInfo.Id);
       
           
            BLN_Room__c roomInfo= new BLN_Room__c();
            roomInfo= globalTest.createRoom(eventInfo.Id);
            
            BLN_Track__c trackInfo= new BLN_Track__c();
            trackInfo= globalTest.createTrack(eventInfo.Id);
            
            Agenda__c agendaInfo= new Agenda__c();
            agendaInfo= globalTest.createAgenda(eventInfo.Id, trackInfo.Id);
            
            Time_Slots__c timeSlotInfo= new Time_Slots__c();
            timeSlotInfo= globalTest.createTimeSlot(agendaInfo.Id, roomInfo.Id);
          
            Participant__c participantInfo= new Participant__c();
            participantInfo= globalTest.createParticipant(GNUserInfo.Id, null);
            
            Company__c compInfo= new Company__c ();
            compInfo= globalTest.createCompany('compName');
            
            Role__c roleInfo= new Role__c();
            roleInfo= globalTest.createRole();
            
            
            UC_Role__c ucRoleInfo= new UC_Role__c();
            ucRoleInfo= globalTest.createUCRole(compInfo.Id, eventInfo.id, GNUserInfo.Id, userInfo.Id, roleInfo.Id);
            
            cookie  counter = new Cookie('counter',eventInfo.id,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});
            
            BLN_SpeakersCon speakerData= new BLN_SpeakersCon();
            speakerData.getSpeakers();
            speakerData.participant.Participant_Role__c= 'Speaker';
            
            ApexPages.CurrentPage().getParameters().put('selectedUsers',participantInfo.Id);
            ApexPages.CurrentPage().getParameters().put('selectedRole','Speaker');
            speakerData.updateAsSpeakers();
            
            ApexPages.CurrentPage().getParameters().put('selectedUsers',participantInfo.Id);
            ApexPages.CurrentPage().getParameters().put('selectedRole','Speaker');           
            speakerData.ParticepentMoreOptions();
            
            speakerData.idforDelete= participantInfo.Id;
            speakerData.deleteParticepent();

            
            
            
        }
  
    }
}