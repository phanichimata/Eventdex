public without sharing class sample2 {

public BLN_StaffCustomSettings seingttingscon {get ; set;}
public Event_staff_settings__c se {get ; set ;}
public sample2(){
seingttingscon = new BLN_StaffCustomSettings();
se = seingttingscon.getstaffsettings('Full Admin');
system.debug('sssssssssssssssssssssssss'+se);
}
}