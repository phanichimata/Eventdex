public class BLNUtility{

/***********************************************************************************************
*   Controller Name : BLNUtility
*   Date            : 05/05/2014
*   Author          : Naga Mallikarjuna Rao B
*   Purpose         : This class acts as util class for entire application, here we will maintain All DML operations.
*   Change History  : 05/05/2014 
*       Date                 Programmer                     Reason
*   --------------      -------------------           -------------------------
*   05/05/2014          Naga Mallikarjuna Rao B           To Create Page
**************************************************************************************************/

    public LIST<BLN_StatusMessage> successMsg{get; set;}
    
    
    public LIST<BLN_StatusMessage> createEvent(LIST<BLN_Event__c> events){
        // We are Upserted 2 objects 
        //    1) Event
        //    2) UC_Role
         
         
         successMsg = new LIST<BLN_StatusMessage>();
        
        LIST<Database.UpsertResult> dbr = DataBase.upsert(events , false);
        MAP<Id, Database.UpsertResult> eventSaveResult = new MAP<Id, Database.UpsertResult>();
        
        for(Database.UpsertResult r: dbr){
            if(r.isSuccess()){
                eventSaveResult.put(r.getId(), r);   
            }
        }
        
        LIST<USER> users = [SELECT ID, NAME, CompanyName FROM USER WHERE ID =: userinfo.getUserId()];
        String companyName = '';
        
        for(User u: users){
            if(u.CompanyName != null){
                companyName = u.CompanyName;
                break;
            } 
        }
        
        LIST<Company__c> companies =[SELECT ID, NAME FROM Company__c WHERE NAME =: companyName];
        LIST<Role__c> roles = [SELECT ID, NAME FROM Role__c WHERE Role_ShortName__c = 'EAD'];
        
        
        LIST<UC_Role__c> usercompanyRole = new LIST<UC_Role__c>();
       
       for(Database.UpsertResult rs :dbr){
           
           if(rs.isSuccess() && rs.isCreated()){
               if(companies.size() > 0 && roles.size() > 0 && users.size() > 0 ){
                   
                    UC_Role__c ucr = new UC_Role__c();
                    ucr.Company__c = companies[0].id ;
                    ucr.Event__c = rs.getId();
                    ucr.Invited_date__c = system.Today();
                    ucr.RoleId__c = roles[0].id ;
                   // ucr.User__c = users[0].id;
                    
                    usercompanyRole.add(ucr);
                } 
           
           }
       
       }
        
      List<Database.SaveResult> roleRes = DataBase.insert(usercompanyRole, FALSE);
       
      for(Database.UpsertResult r: dbr){
             successMsg.add(new BLN_StatusMessage(r)); 
      }
        
        
        return successMsg;
    }

    /*
    //This is Class for access records are created Successfully or Not.
    public class successMessage{
    
        public ID successId{get; set;}
        public Boolean successBool{get; set;}
        public Boolean iscreated{get; set;}
        public String errors{get; set;}
        
        public successMessage(Database.UpsertResult r){
            iscreated = FALSE;
            successBool = FALSE;
            errors = '';
            
            successId = r.getId();
            successBool = r.isSuccess();
            iscreated = r.isCreated();
            if(r.getErrors() != null){
                errors = String.valueOf(r.getErrors());
            }   
        }
    }
    */
    
    
    public LIST<Country__c> countries(){
        
        LIST<Country__c> country =  new LIST<Country__c>();
        
        country = [SELECT ID, NAME, Short_Name__c, Long_Name__c FROM Country__c ];
        
        return country;
    } 
    
    public LIST<State__c> stateOfCountry(id countryId){
        LIST<State__c> states = new LIST<State__c>();
        states = [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c FROM State__c WHERE Country__c =: countryId];
        
        return states;
    }
    
    
    //for multiple ticket just iterate this method
   /* public void AssignTagToItemPool(String EXISTINGItemPoolId,String TagName,String tcktid,String EventID)
    {
       //Create new Itempool with the parameter tagname
       String ItemPoolId=Create_new_Itempool(tcktid,TagName,EXISTINGItemPoolId,EventID);
       //if(ItemPoolID!='')
       //AssignTag(ItemPoolId, TagName,EventID);
       
    }
    
    
    public String Create_new_Itempool(String tcktid,String TagName,String EXISTINGItemPoolId,String EventID)
    {
       String successitpoolid='';
       BLN_ItemPool_DAO  itpooldao=new BLN_ItemPool_DAO();
       Item_Pool__c oldip=itpooldao.getItempool('where id=\''+EXISTINGItemPoolId+'\'');
       Item_Pool__c newip=oldip.clone();
       //newip.Item_Count__c=tcktids.size();
       newip.Item_Pool_Name__c=TagName;
       newip.Event__c=EventID;
       
       
       
          //Get ticket object based on id
        
          BLN_Ticket_DAO TicketDAO = new BLN_Ticket_DAO();
       List<Ticket__c> tckt = TicketDAO.getTickets('id,name,Item__r.Payment__c,Item__r.Event__c,Item__r.price__c,Item__r.item_name__c,Item_Type__r.name,item__r.Ticket_Settings__c,Ticket_Status__c,Parent_ID__c,Item_Pool__r.Badgable__c,Item_Pool__c,Item_Pool__r.Ticket_Settings__c,Event__c,Item__c','id =\''+tcktid+'\''); 
       
       integer itemmatchflag=0;  
      
       
       //if the tag exist in item pools
       List<ItemPool_Tag_Junction__c> itpjunc=[select id,name,Pool_Id__c,Tag_Id__c from ItemPool_Tag_Junction__c where Tag_Id__r.Tag_Text__c=:TagName];
       if(itpjunc.size()>0)
       {
       String idInClause = '(\'';
       for(ItemPool_Tag_Junction__c itp:itpjunc)
       {
          
          idInClause += itp.Pool_Id__c+ '\',\'';
       }
       idInClause  = idInClause.substring(0,idInClause.length()-2);
         idInClause += ')';
         
         //Now get all the items of that itempool
         
         List<BLN_Item__c> items=Database.query('select id,name,Item_Pool__c from BLN_Item__c where Item_Pool__c in'+idInClause);
       
       
       
       
       
      
        
       for(BLN_Item__c bl:items)
       {
          if(tckt[0].Item__c==bl.id)
          {
            Item_Pool__c ip=[select id,name,Item_Count__c from Item_Pool__c where id=:bl.Item_Pool__c ];
            ip.Item_Count__c=ip.Item_Count__c+1;//tcktids.size();
            update ip;
            
            successitpoolid= bl.Item_Pool__c ;
            itemmatchflag=1;
          }
          
       }
       
       }
       if(itemmatchflag==0)//create new itpool
         {
             
              newip.Item_Count__c=1;
              insert newip;
              successitpoolid=newip.id;
         }
           
            
        
      
          if(successitpoolid!=''){    //that means a new record is created with id
           //Assign tickets to the new itempool
          tckt[0].Item_Pool__c=successitpoolid;
          update tckt;
          
          
          //update the old pool quantity
       oldip.Item_Count__c=oldip.Item_Count__c-1;
       update oldip;
          }
       
       
       
       
      
       
       
       
       
       
        
        return successitpoolid;
    }
    */
    
    /*public void AssignTag(String ItemPoolId, String TagName,String EventID)
    {
        Hash_Tag__c htag;
        String eventagid;
    //serach if tag exist with that name otherwise create one
    try{
    htag=[select id,Tag_Text__c,Event__c,Table_Name__c from Hash_Tag__c where Event__c=:EventID and Tag_Text__c=:TagName limit 1];
    eventagid=htag.Id;
    }catch(Exception e){
    //create if record not found
    htag=new Hash_Tag__c();
    htag.Tag_Text__c=TagName;
    htag.Table_Name__c='Item_Pool__c';
    htag.Event__c=EventID;
    insert htag;
    eventagid=htag.Id;
    }
    
    //insert into itpooltagjunction
    //check whether already exist or not
    
    ItemPool_Tag_Junction__c itpljunc;
    try{
    itpljunc=[select id,name,Pool_Id__c,Tag_Id__c from ItemPool_Tag_Junction__c where Pool_Id__c=:ItemPoolId and Tag_Id__c=:eventagid];
    }
    catch(Exception e){itpljunc=new ItemPool_Tag_Junction__c();
      itpljunc.Pool_Id__c=ItemPoolId;
      itpljunc.Tag_Id__c=eventagid;
      insert itpljunc;
      }
   
    
    
    
    }
    */
    public void AssignTags(String tcktid,String TagName,String EventID,String TableName)
    {
      Hash_Tag__c htag;
       
    //serach if tag exist with that name otherwise create one
    try{
    htag=[select id,Tag_Text__c,Event__c,Table_Name__c,RowId__c from Hash_Tag__c where Event__c=:EventID and Tag_Text__c=:TagName and RowId__c=:tcktid and Table_Name__c=:TableName limit 1];
    
    }catch(Exception e){
    //create if record not found
    htag=new Hash_Tag__c();
    htag.Tag_Text__c=TagName;
    htag.Table_Name__c=TableName;
    htag.Event__c=EventID;
    htag.RowId__c=tcktid;
    insert htag;
    
    } 
    }
    
    
}