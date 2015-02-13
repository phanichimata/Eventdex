public with sharing class BLN_SpeakersCon {

    /***********************************************************************************************
    *   Controller Name         : BLN_SpeakersCon
    *   Date                    : 30/07/2014 
    *   Author                  : Mallikarjuna Rao
    *   Purpose                 : This class is for Creating Speakers.
    *
    *   Last Modified By           Date                    Purpose
    *   =============================================================================================
    *    Mallikarjuna Rao          30/07/2014            Create Page
    **************************************************************************************************/



     public LIST<Ticket__c> allAdminTickets{get; set;}
     Public ID selectedeventid{get;set;}
     public MAP<id, Ticket__c> GNUsersMAP{get; set;}
     public Participant__c participant{get; set;}
     public LIST<Participant__c> participantRolesList{get; set;}
     public BLN_UtillDisplayLinks speakerComponents{get; set;}
     
     
     // 
      public BLN_SpeakersCon(){
          allAdminTickets = new LIST<Ticket__c>();
          GNUsersMAP = new MAP<id, Ticket__c>();
          participant= new Participant__c();
          
          BLN_Ticket_DAO itemTypesTicDAO = new BLN_Ticket_DAO();
         
          
            Cookie k = ApexPages.currentPage().getCookies().get('counter');
            if(k!=null){
                selectedeventid = k.getValue();
            }
          
          speakerComponents = new BLN_UtillDisplayLinks();
           BLN_Event_DAO evDAO = new BLN_Event_DAO();
          List<BLN_Event__c> eventsList =  evDAO.getEventDetails(selectedeventid);
          if(eventsList.size() > 0){
             speakerComponents.EventName =eventsList[0].Name;
        }
     
        
         speakerComponents.isSpeackersPage = 'active';
         speakerComponents.isSeminorsPageExpand = 'expand';
         speakerComponents.tablabel='Speakers';
         speakerComponents.eventId = selectedeventid ;
         speakerComponents.userPermissions(userInfo.getUserId(),selectedeventid);
          
         //listOfSpeakers();
          
          allAdminTickets = itemTypesTicDAO.userOrderAndTickets (' WHERE Client_GN_User__c != null AND Item_Type__r.Item_Type_Number__c = \''+  BLN_Event_UtilityCon.speakerItemType()+'\' AND Event__c = \''+ selectedeventid+'\'');
                
                for(Ticket__c t: allAdminTickets){
                        GNUsersMAP.put(t.Client_GN_User__c, t );
                        // Client_GN_User__c , Client_Company__c
                }
          
          system.debug('SSSSSSSSSSSSSSSSSSSS        '+ allAdminTickets.size());
          
      }

   public MAP<id,Participant__c> mapIdwithPartis {get;set;}
   
   public List<Participant__c> getSpeakers(){
    BLN_Participant_DAO patDAO = new BLN_Participant_DAO();
    participantRolesList = new LIST<Participant__c>();
    participantRolesList = patDAO.allParticipants(selectedeventid);
    system.debug('databAse.upsertResult  '+ participantRolesList);  
    mapIdwithPartis  = new MAP<id,Participant__c>();
          for(Participant__c part :participantRolesList ){
             mapIdwithPartis.put(part.id,part);  
          }
       
     return participantRolesList;
   }



    public string selectedUsers{get; set;}
    public void updateAsSpeakers(){
        
        LIST<Participant__c> participant = new LIST<Participant__c>();
        
        string selectedGNUsers = apexpages.currentpage().getparameters().get('selectedUsers');
        string selectedUsers= apexpages.currentpage().getparameters().get('selectedUsers');
        string selectedUserRole = apexpages.currentpage().getparameters().get('selectedRole');
        
        system.debug(selectedUserRole+'RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR          '+ selectedUsers +'       '+selectedGNUsers);
        
        LIST<ID> selectedIdsList = new LIST<ID>();
       // selectedIdsList = selectedGNUsers.split(',');
       selectedIdsList = selectedUsers.split(',');
                
        for(id i: selectedIdsList){ 
                Participant__c p = new Participant__c();
        
                p.GN_User__c = i;
                p.Participant_Role__c = selectedUserRole;
               participant.add(p);
        }
        
        BLN_Participant_DAO patDAO = new BLN_Participant_DAO();
        
       LIST<databAse.upsertResult> patRes =  patDAO.insertParticipants(participant);
         system.debug('SSSSSSSSSSSSSSS '+patRes );
         
         // listOfSpeakers();
    }

         public string idforDelete{get;set;}
        public void deleteParticepent(){
          system.debug('ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ '+idforDelete);
          dataBase.delete(mapIdwithPartis.get(idforDelete),false);     
         // listOfSpeakers(); 
          BLN_Participant_DAO patDAO = new BLN_Participant_DAO();
          participantRolesList = new LIST<Participant__c>();
          participantRolesList = patDAO.allParticipants(selectedeventid);
             system.debug('XXXXXXXXXXXXXXXXXXXXXXXX '+participantRolesList );
        }
        
       public string roleid{get;set;} 
        public void ParticepentMoreOptions(){
           string selectedGNUsers = apexpages.currentpage().getparameters().get('selectedUsers');
           string selectedUserRole = apexpages.currentpage().getparameters().get('selectedRole');
          system.debug(selectedUserRole+'  USERS LIST '+apexpages.currentpage().getparameters().get('selectedRole'));
          system.debug(mapIdwithPartis.size()+'  MAP LIST '+mapIdwithPartis);
            Participant__c pp = new Participant__c();
             pp = mapIdwithPartis.get(selectedGNUsers);

             pp.Participant_Role__c =selectedUserRole  ;
             database.update(participantRolesList,false);
        }
        
        
}