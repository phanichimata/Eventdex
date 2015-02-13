trigger insertDefaultSettings on BLN_Event__c (after insert) {
    List<Reg_Setting__c>  GlobalEventSettings = new List<Reg_Setting__c>();
    List<Reg_Setting__c>  GlobalEventSettingsnew = new List<Reg_Setting__c>();
    GlobalEventSettings =[select Column_Name__c,Event__c,Group_Name__c,Included__c,Item__c,Item_Pool__c,Order__c,Organizer__c,Required__c,Setting_Type__c,Table_Name__c,Label_Name__c,Group_Order__c,Sales_Message__c from Reg_Setting__c where Event__r.Name='Default Event(Boothleads)' and (Group_Name__c='Basic Information' OR Setting_Type__c ='Event Staff' OR Setting_Type__c ='Display' OR Setting_Type__c ='Quick')];
    for(BLN_Event__c eve : trigger.new){
        for(Reg_Setting__c regs:GlobalEventSettings){
            Reg_Setting__c  reg = new Reg_Setting__c ();
            reg = regs.clone();
            if(eve.Description__c != NULL && reg.Column_Name__c == 'Sales Message'){
                reg.Sales_Message__c = eve.Description__c;
            }
            reg.event__c = eve.id;
            GlobalEventSettingsnew.add(reg);
        }
        
       for(Reg_Setting__c rg:[select id,name,Event__c,Table_Name__c,Column_Name__c,Label_Name__c,Setting_Type__c,Included__c from Reg_Setting__c where Event__r.Name='Default Event(Boothleads)' and Table_Name__c='Item_Type__c'])
       {
          Reg_Setting__c  reg = new Reg_Setting__c ();
            reg = rg.clone();
            reg.event__c = eve.id;
            GlobalEventSettingsnew.add(reg);
       }   
        
    }
    DataBase.insert(GlobalEventSettingsnew,false);
}