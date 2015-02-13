public without sharing class BLN_Profilecon {
    public User Udetails {get ; set ;}
    public string selectedcompany {get ; set ;}
    public Company__c compdetails{get ; set ;}
    public List<Company__c> compdetails1{get ; set ;}
    public GN_User__c GNUSER {get ; set ;}
    public LIST<Company_Ext__c> comext {get ; set ;}
    //public User_Ext__c Userext {get ; set ;}
    public string UserImageName {get ; set ;}
    public string companyImageName {get ; set ;}
    public string naics1 {get ; set ;}
    public string naics2 {get ; set ;}
    public string UdetailsCompanyname {get ; set ;}//Created to store company name of user if his existed company name is his firstname and last name
    public blob UserImage {get ; set ;}
    public blob companyImage {get ; set ;}
    public document mydoc {get ; set ;}
    public LIST<Country__c> country {get ; set ;}
    public LIST<SelectOption> countryOptions {get ; set ;}
    public LIST<SelectOption> NaicsList { get ; set ;}//To collect all naics codes from naics object 
    public LIST<LIST<SelectOption>> NaicsListOfList { get ; set ;}//To collect all naics codes from naics object 
    public LIST<SelectOption> stateOptions{get; set;}
    public LIST<SelectOption> HomestateOptions{get ; set ;}
    public LIST<SelectOption> BillstateOptions{get ; set ;}
    public string selectedCountry {get ; set ;}
    public List<Pay_Address__c> billingadd {get ; set ;}
    public string billingaddId {get ; set ;}
    public List<NAICS_Code__c> naicscodeslist {get ; set ;}
    public LIST<LIST<NAICS_Code__c>> listOfnaicscodes{get; set;}
    public String checkNAICSforEdit{get; set;}
    public List<selectoption> selopt {get ; set ;}
    public List<selectoption> seloptcurrent {get ; set ;}
    public string Currentcompany {get ; set ;}
    public string uid {get ; set ;}
    public Company_Ext__c  comextnew {get;set;}
    public boolean detailsbool {get ; set ;}
    
    //CONSTRUCTOR
    public BLN_Profilecon(){
        
        detailsToget();
        
        }
        
        public void detailsToget(){
        UdetailsCompanyname = '' ;
        Currentcompany = '' ;
        selectedcompany = '';
        uid = Userinfo.getuserid();    
        Udetails = new User();
        GNUSER = new GN_User__c();
        //Userext  = new User_Ext__c();
        compdetails = new Company__c ();
        comextnew  = new Company_Ext__c  ();
        compdetails1 = new List<Company__c> ();
        selopt = new LIST<selectoption>();
        seloptcurrent =  new LIST<selectoption>();
        comext = new LIST<Company_Ext__c>();       
        billingaddId = '';
        BLN_Profile_BAL profilebal = new BLN_Profile_BAL();
        GNUSER = profilebal.userdetails(uid);
        
        compdetails1 = profilebal.compniesdetails(GNUSER.id);
        system.debug('::::::::::::::;;comp details:::::::::::'+compdetails1 );
        selopt.add(new selectoption('none','none'));
        if(compdetails1.size() != 0  ){
            for(Company__c comp : compdetails1 ){
                system.debug(':::::::::::::::::comp::::::'+comp);  
                //if(comp.name != comp.id){
                selopt.add(new selectoption(comp.id,comp.name));
                seloptcurrent.add(new selectoption(comp.id,comp.name));
                system.debug(':::::::::::::::::comp::::::'+selopt);
                //}
                if(GNUSER.Default_Company_ID__r.id == comp.id){
                    Currentcompany = comp.id; 
                    selectedcompany = comp.id;
                    
                }
            }
        }
        if(selopt.size() == 1){
            detailsbool =  true;
            
        }
        system.debug(':::::::::::::Currentcompany:::::::::'+Currentcompany ); 
        
        // billingadd = profilebal.billingadd(compdetails.id);
        NaicsList = new LIST<SelectOption> ();
        NaicsListOfList = new LIST<LIST<SelectOption>> ();
        listOfnaicscodes= new LIST<LIST<NAICS_Code__c>>();
        naicscodeslist = new List<NAICS_Code__c>();
        for(NAICS_Code__c naics : [SELECT id,Name,Description__c FROM NAICS_Code__c]){
            naicscodeslist.add(naics); 
            if(naicscodeslist.size() == 999){
                listOfnaicscodes.add(naicscodeslist);
                
                naicscodeslist= new LIST<NAICS_Code__c>();
            }
        }
        if(naicscodeslist.size() != 0){
            listOfnaicscodes.add(naicscodeslist);
        } 
        for(LIST<NAICS_Code__c> na : listOfnaicscodes){
            for(NAICS_Code__c na1 : na){
                NaicsList.add(new selectoption(na1.Name , na1.Name));
                if(NaicsList.size() == 999){
                    NaicsListOfList.add(NaicsList);
                    NaicsList  = new LIST<selectoption> ();
                }
            }
        }
        checkNAICSforEdit= '$$$$';
        if(NaicsList.size() != 0){
            NaicsListOfList.add(NaicsList);
        }
        
        
        if(selectedcompany != null && selectedcompany != ''){
        cpmdetails();
        }
        countryStates();
    }
    
   //TO Get comapany details
    public void cpmdetails(){
        
        if(selectedcompany != 'none'){
            detailsbool =  true;}
        else{
            detailsbool =  false;
        }
        comextnew  = new Company_Ext__c  ();
        system.debug('ssssssssssssssssssssssssssssss'+selectedcompany);
        comext = new LIST<Company_Ext__c>();
        compdetails = new Company__c ();
        comext = [SELECT ID, NAME, Business_Address1__c, Business_Address2__c, Business_City__c, BLN_Business_Country__c, BLN_Business_Country__r.Short_Name__c, BLN_Business_State__c,BLN_Business_State__r.Short_Name__c, Business_Zipcode__c, Work_Phone__c,Company__c,Duns_Number__c,
                  Established_Date__c,Keywords__c,Number_Of_Employees__c,Primary_NAICS_Code__c,Revenue__c,Secondary_NAICS_Code__c,Tax_Id__c FROM Company_Ext__c where Company__c =: selectedcompany];
        if(comext.size() > 0){
            comextnew  =comext[0]; 
            
            if(comext[0].Primary_NAICS_Code__c != NULL){
                checkNAICSforEdit += comextnew.Primary_NAICS_Code__c;
            }
            if(comext[0].Secondary_NAICS_Code__c != NULL){
                checkNAICSforEdit += comextnew.Secondary_NAICS_Code__c;
            } 
            
            countryStates();
            
        }
        
        try{
            if(selectedcompany != null && selectedcompany != ''){
                compdetails = [select  ID, NAME,Website_URL__c,Description__c, Company_Logo__c from Company__c where id =: selectedcompany];
            }else{
                compdetails = new Company__c();
            }
            
        }catch(exception ex){}
        
        
    }
    
    
    
    
    public void countryStates(){   
        country = new LIST<Country__c>();
        countryOptions= new LIST<SelectOption>();
        
        // countryOptions.add(new SelectOption('none' ,'Choose Country'));
        for(Country__c c: [SELECT ID, NAME, Short_Name__c, Long_Name__c FROM Country__c ]){
            countryOptions.add(new SelectOption(c.id, c.Long_Name__c));
        }        
        stateOptions= new LIST<SelectOption> ();
        // stateOptions.add(new SelectOption('none' ,'Choose Country'));
        statesBasedOnCountry();
        HomestatesBasedOnCountry();
    }
    
    public void statesBasedOnCountry(){    
        system.debug('STATESSSSSSSSSSSSSSSSSSS '+ selectedCountry );    
        stateOptions= new LIST<SelectOption> ();
        // stateOptions.add(new SelectOption('none' ,'Choose State'));       
        for(State__c s: [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c FROM State__c WHERE Country__c =: comextnew.BLN_Business_Country__c]){
            stateOptions.add(new SelectOption(s.id,s.Long_Name__c));
        }   
        system.debug('STATESSSSSSSSSSSSSSSSSSS '+ stateOptions);    
    }
    //HOme state options
    
    public void HomestatesBasedOnCountry(){    
        system.debug('STATESSSSSSSSSSSSSSSSSSS '+ selectedCountry );    
        HomestateOptions= new LIST<SelectOption> ();
        // stateOptions.add(new SelectOption('none' ,'Choose State')); 
        
        
        for(State__c s: [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c FROM State__c WHERE Country__c =: GNUSER.Country__c]){
            HomestateOptions.add(new SelectOption(s.id,s.Long_Name__c));
        }   
        system.debug('STATESSSSSSSSSSSSSSSSSSS '+ stateOptions);    
    }
    
    public void Addcompany(){
        comext = new LIST<Company_Ext__c>();
        compdetails = new Company__c ();
        detailsbool =  true;
        countryStates();
    }
    //Billing State option
    public void BillstatesBasedOnCountry(){    
        
        BillstateOptions= new LIST<SelectOption> ();
        // stateOptions.add(new SelectOption('none' ,'Choose State'));  
        string bid = Apexpages.Currentpage().getparameters().get('billid'); 
        system.debug('------------------------------------------------------billing id-------- '+ bid);  
        Pay_Address__c bcountry= [select id,City__c,Company__c,BLN_Country__c from Pay_Address__c where id=: bid]; 
        for(State__c s: [SELECT ID, NAME, Short_Name__c,Long_Name__c, Country__c FROM State__c WHERE Country__c =: bcountry.BLN_Country__c]){
            HomestateOptions.add(new SelectOption(s.id,s.Long_Name__c));
        }   
        system.debug('STATESSSSSSSSSSSSSSSSSSS '+ stateOptions);    
    }
    public void updatedetails(){    
        
        if (companyImage != NULL && (companyImageName != '' || companyImageName != NULL)) {    
            if (companyImage.size() != null) {
                if (companyImage.size() <= 1024000) {
                    mydoc = new document();
                    mydoc.body = companyImage ;
                    //if(folderList.size()>0){
                    mydoc.folderid ='00lF0000001VI7Y';
                    // }
                    mydoc.ispublic = true;
                    mydoc.Name = companyImageName;
                    insert mydoc;
                    compdetails.Company_Logo__c = mydoc.id;
                } else {
                    
                }
                
            }
            
        }
        system.debug('ssssssssssssssssssssssss'+UdetailsCompanyname );
        IF(UdetailsCompanyname != '' && UdetailsCompanyname != null){
            Udetails.Companyname = UdetailsCompanyname ;
        }
        system.debug('ssssssssssssssssssssssss'+Udetails.Companyname);
        
        system.debug(comext+'  ssssssssssssssssssssssss  '+naicsCodesString);
        
        if(comextnew != NULL){
            
            if(naicsCodesString != NULL){
                checkNAICSforEdit= '';
                checkNAICSforEdit= '$$$$';
                LIST<String> naicsCodes= new LIST<String>(naicsCodesString.split('-'));
                system.debug(naicsCodes.size()+' NAICS CODES '+naicsCodes);
                if(naicsCodes.size() >1){
                    comextnew.Primary_NAICS_Code__c= naicsCodes[1];
                    comextnew.Secondary_NAICS_Code__c= NULL;
                    checkNAICSforEdit += comextnew.Primary_NAICS_Code__c;
                    system.debug(' NAICS CODE 1111111  '+comextnew.Primary_NAICS_Code__c);
                }
                if(naicsCodes.size() >2){
                    comextnew.Secondary_NAICS_Code__c= naicsCodes[2];
                    checkNAICSforEdit += comextnew.Secondary_NAICS_Code__c;
                }
                
            }
        }
        GNUSER.Default_Company_ID__c = Currentcompany;
        BLN_Profile_BAL profilebal = new BLN_Profile_BAL();
        profilebal.UserImage =UserImage;
        profilebal.UserImageName = UserImageName;
        GN_User__c GNU = profilebal.updateGNUSER(GNUSER);
        //update GNUSER;
        Database.upsertResult res = database.upsert(compdetails,false);   
        system.debug('cccccccccccccccccccccccccccccccccc'+compdetails);
        if(res.isCreated()){
            
            UC_Role__c ucrnew = new UC_Role__c();
            ucrnew.Company__c = compdetails.id;
            ucrnew.RoleId__c = 'a1Vc0000000vift';
            ucrnew.GN_User__c=GNUSER.id;
            ucrnew.User_Type__c = 'Business';
            insert ucrnew;
            
        }
        
        comextnew.Company__c=compdetails.id;
        database.upsert(comextnew);
        detailsToget();
    }
    /**
public GN_User__c updateGNUSER(GN_User__c GNUSER){

if (UserImage != NULL && (UserImageName != '' || UserImageName != NULL)) {    
if (UserImage.size() != null) {
if (UserImage.size() <= 1024000) {
mydoc = new document();
mydoc.body = UserImage;
//  if(folderList.size()>0){
mydoc.folderid ='00lF0000001VI7Y';
//  }
mydoc.ispublic = true;
mydoc.Name = UserImageName;
insert mydoc;
UserImage = null; 
GNUSER.User_Pic__c = mydoc.id;
} else {

}

}

}
update GNUSER;
return GNUSER;

}
*/
    
    
    Public pagereference cancel(){
        pagereference pf = new pagereference('/apex/BLN_Userevents');
        return pf;
        
    }
    
    public String naicsCodesString{get; set;}
    public pagereference sendNaicsCodes(){
        
        IF(ApexPages.currentPage().getParameters().get('naicsCodes') != ''){
            naicsCodesString=ApexPages.currentPage().getParameters().get('naicsCodes');
        }ELSE{
            naicsCodesString= NULL;
            
        }
        system.debug(ApexPages.currentPage().getParameters().get('naicsCodes')+' NAICS CODES STRING '+naicsCodesString);
        return null;
    }
}