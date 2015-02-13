public with sharing class BLN_SuccessController{
/**********************************************************************************************************************************************************************************************
*   Author                  : Mahesh Sakunala
*   Date                    : 02/06/2014 
*   Purpose                 : This class is for Registration Page i.e. User picks Items and fills gives contact information and fills out survey questions and completes registration
*************************************************************************************************************************************************************************************************/

//------------------------------------------- Variables Declaration Start ---------------------------------------------- 
public String EventId{get;set;}
public String BookTicketLink{get;set;}
public Integer EventDaysRemaining{get; set;}
public BLN_Event__c registrationEvent{get; set;}
public Registration_Template__c registrationTemplate{get; set;}
public string orderId{get;set;}
public string error{get;set;}
public Cookie  counter {get;set;}
public order__c orders {get;set;}
//-------------------------------------------- Variables Declaration End ----------------------------------------------- 

//------------------------------------------------ Constructor Start --------------------------------------------------- 
public BLN_SuccessController(){
    
     ID RegId;
     
     try{
         
         string eveidBeforedecode= apexpages.currentpage().getparameters().get('id');
         if(eveidBeforedecode!=null && eveidBeforedecode!=''){
             eventId= EncodingUtil.base64Decode(eveidBeforedecode).toString();
        }
        
        system.debug('WWWWWWWWWWWWWWWWWWWWW '+eventId);
         try{
           string abd='';
            try{
             system.debug('eeeeeeeeeeeeeeeeeee ');
              abd = apexpages.currentpage().getparameters().get('OrdId');
              if(abd==null || abd==''){
                 counter = ApexPages.currentPage().getCookies().get('OrderId');
                if(counter != null){
                  abd = counter.getValue();
                }
              }
              
            }catch(exception er){
               counter = ApexPages.currentPage().getCookies().get('OrderId');
                system.debug('DDDDDDDDDDDDDDDD '+counter );
                if(counter != null){
                  abd = counter.getValue();
                   system.debug('DDDDDDDDDDDDDDDD '+abd );
                }
    
            }
           
           orderId  = EncodingUtil.base64Decode(abd).toString(); 
         
          }catch(exception e){}
           //for trustcommerceventid       
         if(EventId == NULL)  {     
           Cookie tcok=ApexPages.currentPage().getCookies().get('trustcommerceeventnid'); 
           if(tcok!= null){     
          EventId=tcok.getValue();}
          }
          
           system.debug('EEEEEEEEEEEEEEEE '+orderId+'WWWWWWWWWWWWWW '+eventId );  
          
         RegId = apexpages.currentpage().getparameters().get('rid');
         BLN_Quick_Registration_BAL QuickRegBAL = new BLN_Quick_Registration_BAL();
                
          if(orderId!=null && orderId!=''){
            // sendMail(orderId,eventId );           
          }      
        
                
        if(EventId != NULL){ 
            // Getting Event Details from Event DAO
            registrationEvent = QuickRegBAL.getEventDetails(EventId);   
    
            EventDaysRemaining = date.today().daysBetween(registrationEvent.End_Date__c);   
        }
        
       // Getting Registration Template from Registration Template DAO
        if(RegId != NULL){
            registrationTemplate = QuickRegBAL.getRegTempDetails(RegId);                   
        }else{
            if(registrationEvent.Registration_Template__c != NULL)
                registrationTemplate = QuickRegBAL.getRegTempDetails(registrationEvent.Registration_Template__c);
            else{
                List<Registration_Template__c> regtemp = [SELECT id From Registration_Template__c Where Owner.profile.Name =: 'System Administrator'];
                registrationTemplate = QuickRegBAL.getRegTempDetails(regtemp[0].id);
                }
        }   
        
              
    }
    catch(Exception pageloadException){
        system.debug('Exception is : '+ pageloadException.getMessage());
    }
    
    BookTicketLink = 'https://blnew-boothleads.cs14.force.com/BLN_Registrationnew?id='+eventId;
     
    
}

//------------------------------------------------- Constructor End ----------------------------------------------------- 

public void sendMail(){
//string orderidstr,string eveid
try{
       BLN_PromoCode_BAL PromotionBAL = new BLN_PromoCode_BAL();
         BLN_Promotion_DAO PromotionDAO = new BLN_Promotion_DAO();
         LIST<Promotion__c> promotionlist  = new LIST<Promotion__c>();
 
      orders =new order__c();
      orders =   [select owner.Name,createdDate,Events__r.Name,Events__r.Start_Date__c,Events__r.Venue_Name__c,Events__r.End_Date__c,Events__c,o.Fee_Amount__c,o.Order_Total__c, o.Order_Taxes__c, o.Order_Sub_Total__c, o.Order_Status__c, o.Order_Discount__c, o.Name, o.Id, o.Currency_Code__c, o.Client_GN_User__c, o.Client_Company__c, o.Amount_Paid__c,(Select Each_Ticket_Price__c,item__r.event__r.Name ,Promotion__c,Promotion__r.Name, Order__c, Name, Item__c, Item_Total__c,order__r.Client_GN_User__c, order__r.Client_GN_User__r.Email__c,Item_Quantity__c, Item_Price__c, Item_Discount__c, Id,Item__r.Event__r.End_Date__c,item__r.item_name__c,Status__c,Promotion__r.Promo_Code__c,Currency__c,item__r.price__c  From Order_Items__r ),(Select Order_Item__r.Each_Ticket_Price__c,Item_Pool__c,Item_Type__c,item__r.item_name__c,id,Client_Company__c,Client_Company__r.Name,Client_GN_User__r.Email__c,Client_GN_User__r.user__c,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.email,Client_GN_User__r.First_Name__c,Client_GN_User__r.Last_Name__c,Event__c,Order__c,Order_Item__c,Ticket_Status__c,Badge_Label__c,NAme,Item_Type__r.Name,Client_GN_User__r.user__r.MobilePhone,lastmodifiedDate from Tickets__r),(select Currency_Code__c,Pay_Address__c,event_paygateway_id__c,Payment_Ref_Number__c,Payment_Mode__c,Payment_Amount__c from Payments__r),Client_GN_User__r.user__r.Name,Client_GN_User__r.user__r.userName,Client_GN_User__r.user__r.MobilePhone,Client_Company__r.Name,Client_GN_User__r.Last_Name__c,Client_GN_User__r.First_Name__c,Client_GN_User__r.Email__c,Transaction_Status__c From Order__c o where Id=: orderId ];
     SET<id> ids  = new SET<id>();
     if(orders.Transaction_Status__c!='completed'){ 
      for(Order_Item__c  ord : orders.Order_Items__r ){
           if(ord.Promotion__c!=null){
              
               for(Promotion__c p : [select id,T_Used_Count__c from Promotion__c where id=:ord.Promotion__c ]){ 
                   p.T_Used_Count__c += 1;
                    if(!ids.contains(p.id)){ 
                       promotionlist.add(p);
                       ids.add(p.id);
                   }
                }
             }        
           } 
         
          if(promotionlist.size()>0){
          PromotionDAO.UpsertPromotion(promotionlist);
         }
     } 
      
       
      orders.Transaction_Status__c='completed';
      database.update(orders,false);
      
        try{
                     //Cookie orderIdvalue= ApexPages.currentPage().getCookies().get('OrderId');
                       if (counter != null) {
                            counter = new Cookie('OrderId',null,null,-1,false);
                        }
                        
                       ApexPages.currentPage().setCookies(new Cookie[]{counter });    
               }catch(exception rt){
               
               } 
 
 
  string promocode=''; 
 string  consrtuctTicbody ='<table style="width:100%" cellpadding="0" cellspacing="0" ><tr> <td height="30" bgcolor="#E7E5E5" style="padding-left:15px;border-bottom:1px solid #999;border-top:1px solid #999;background-color:#e7e5e5;border-left:1px solid #999"> <strong>Tickets/Items</strong></td><td width="115" align="right" bgcolor="#e7e5e5" style="font-weight:500;font-family:&#39;Helvetica Neue&#39;,Helvetica,Arial,sans-serif;padding-right:15px;border-top:1px solid #999;border-bottom:1px solid #999">Price</td> <td width="115" height="30" align="right" bgcolor="#e7e5e5" style="font-weight:500;font-family:&#39;Helvetica Neue&#39;,Helvetica,Arial,sans-serif;padding-right:15px;border-top:1px solid #999;border-bottom:1px solid #999"><strong>Quantity</strong></td><td align="right" bgcolor="#e7e5e5" style="border-top:1px solid #999;border-bottom:1px solid #999;font-family:&#39;Helvetica Neue&#39;,Helvetica,Arial,sans-serif;padding-right:15px;border-right:1px solid #999"><strong>Total</strong></td></tr>';
 
 string trvalues ='';
  for(Order_Item__c itOrd : orders.Order_Items__r){
     trvalues += '<tr><td height="30" bgcolor="#E7E5E5" style="padding-left:15px;border-bottom:1px solid #999;border-top:1px solid #999;background-color:#f1f1f1;border-left:1px solid #999">'+itOrd.item__r.item_name__c+'</td><td width="115" align="right" bgcolor="#f1f1f1" style="font-weight:500;padding-right:15px;border-top:1px solid #999;border-bottom:1px solid #999">'+itOrd.item__r.price__c+'</td><td width="115" height="30" align="right" bgcolor="#f1f1f1" style="font-weight:500;padding-right:15px;border-top:1px solid #999;border-bottom:1px solid #999">'+itOrd.Item_Quantity__c+'</td><td align="right" bgcolor="#f1f1f1" style="border-top:1px solid #999;border-bottom:1px solid #999;padding-right:15px;border-right:1px solid #999">'+(itOrd.Item_Quantity__c*itOrd.item__r.price__c)+'</td></tr>';  
  }
   consrtuctTicbody +=trvalues +'</table>';
   
  if(orders.Order_Items__r.size()>0){
  promocode =orders.Order_Items__r[0].Promotion__r.Name;
  }
  
  
  
  Payment__c pay = new Payment__c();
  pay = [select id,Currency_Code__c,Order__c,Payment_Amount__c,Pay_Address__c,Payment_Mode__c,Payment_Ref_Number__c,event_paygateway_id__c from Payment__c where order__c=:orderId];
  
  
  
 
   OrgWideEmailAddress Org ;
 
   LIST<BLN_Event__c> eventsList = new LIST<BLN_Event__c>();
         BLN_Event_DAO evDAO = new BLN_Event_DAO();
         eventsList =  evDAO.getEventDetails(eventId);
        
       try{
        if(eventsList.size()>0){
        registrationEvent  = new BLN_Event__c();
        registrationEvent = eventsList[0];
          Org =  [select id from OrgWideEmailAddress WHERE address=:eventsList[0].owner.username];
        }  
       }catch(exception rt){ 
          Org =  [select id from OrgWideEmailAddress WHERE address='support@boothleads.com'];
       }
       
        system.debug('QQQQQQQQQQQQQQQQQQ '+org);
        
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       List<Messaging.SingleEmailMessage> EmailsList = new List<Messaging.SingleEmailMessage>();
       email.setSubject('Your order confirmation for '+eventsList[0].Name);
         if( Org != null){  
              String[] toAddresses= new String[] { orders.Client_GN_User__r.User__r.username };
              email.setToAddresses(toAddresses);
              
            //String[] ccAddresses= new String[] { 'durga@globalnest.com','raj@globalnest.com' };
             //email.setccAddresses(ccAddresses);
              
              
             EmailTemplate E = new EmailTemplate();
             try{ 
                  E = [select Body,Subject,HtmlValue,Markup from EmailTemplate Where Name = 'BLN Order confirmation']; 
             }catch(exception fr){}
            
            String ReplaceContactName = E.HtmlValue;
            String replacedname ='';
            
             string orgid = UserInfo.getOrganizationId();
            string frd1 ='';
             try{
              if(eventsList[0].Logo_URL__c !=null){
              frd1 ='<a href="'+eventsList[0].Website_Url__c+'" style="cursor:pointer;">';
                 frd1 +='<img src="https://c.cs14.content.force.com/servlet/servlet.ImageServer?id='+eventsList[0].Logo_URL__c+'&oid='+orgid;
                 frd1 +='" style="max-width:150px;height:auto;"/></a>';
              }else{
               frd1 ='';
               }
            }catch(exception gr){}
            system.debug('WWWWWWWWWWWWWWWWWWWWWWWWWWWWWW '+frd1 );
            
            if(frd1!=''){
                  replacedname = ReplaceContactName.Replace('{!eventlogo}', frd1);
                 }else{
                 replacedname = ReplaceContactName.Replace('{!eventlogo}','');
                 }
           
             if(eventsList[0].Name!=null && eventsList[0].Name!=''){
                  replacedname = replacedname.Replace('{!eventname}',eventsList[0].Name);
                 }else{
                 replacedname = replacedname.Replace('{!eventname}','');
                 }      
                
                
                
             if(eventsList[0].Venue_Name__c!=null && eventsList[0].Venue_Name__c!=''){
                  replacedname = replacedname.Replace('{!eventlocation}',eventsList[0].Venue_Name__c);
               }else{
                 replacedname = replacedname.Replace('{!eventlocation}','');
               }
               
             String evestda = ''; 
               DateTime eventstdate=eventsList[0].Start_Date__c;
               system.debug('GGGGGGGGGGGGGGGGGGG '+string.valueOf(eventsList[0].Start_Date__c));
               
                if(eventsList[0].Start_Date__c != null ){
                  string[] strdee = string.valueOf(eventsList[0].Start_Date__c).split('-');
                  evestda = strdee[2]+'-'+strdee[1]+'-'+strdee[0];
                }
             
              
              String eveedda= ''; 
               if(eventsList[0].End_Date__c != null ){
                  string[] strdee1 = string.valueOf(eventsList[0].End_Date__c ).split('-');
                  eveedda= strdee1[2]+'-'+strdee1[1]+'-'+strdee1[0];
                }
             
             
               
               If(eventsList[0].Start_Time__c!=null && eventsList[0].End_Time__c!=null){
                  replacedname = replacedname.Replace('{!eventdate}',evestda+' '+eventsList[0].Start_Time__c+' - '+eveedda+' '+eventsList[0].End_Time__c);
               }else{
                replacedname = replacedname.Replace('{!eventdate}','');
               }
                 
             try{
                  replacedname = replacedname.Replace('{!username}',orders.Client_GN_User__r.First_Name__c+' '+orders.Client_GN_User__r.Last_Name__c);
               }catch(exception ed){
               replacedname = replacedname.Replace('{!username}','');
               }
              
                try{
                  replacedname = replacedname.Replace('{!useremail}',orders.Client_GN_User__r.User__r.username);
               }catch(exception ed){}
                try{
                  replacedname = replacedname.Replace('{!company}',orders.Client_Company__r.Name);
               }catch(exception ed){
                replacedname = replacedname.Replace('{!company}','');
               }
                try{
                  replacedname = replacedname.Replace('{!orderid}',orders.Name);
               }catch(exception ed){
                replacedname = replacedname.Replace('{!orderid}','');
               }
               
               
               Datetime myDatetime =orders.createddate;
               String myDatetimeStr = myDatetime.format('MM-dd-YYYY hh:mm a');
               
                try{
                  replacedname = replacedname.Replace('{!orderdate}',myDatetimeStr);
               }catch(exception ed){
                replacedname = replacedname.Replace('{!orderdate}','');
               }
                try{
                  replacedname = replacedname.Replace('{!ticket}',consrtuctTicbody );
               }catch(exception ed){
                replacedname = replacedname.Replace('{!ticket}','');
               }
                try{
                  replacedname = replacedname.Replace('{!totalamount}',string.valueOf(orders.Order_Sub_Total__c));
               }catch(exception ed){
                replacedname = replacedname.Replace('{!totalamount}','');
               }
               
               
               if(orders.Order_Taxes__c !=null && orders.Order_Taxes__c>0){
                  replacedname = replacedname.Replace('{!displaytax}','<tr><td height="30" colspan="3" align="left" bgcolor="#f3f3f3" style="font-family:&#39;Helvetica Neue&#39;,Helvetica,Arial,sans-serif;padding-left:15px;background-color:#e7e5e5;border-left:1px solid #999;border-bottom:1px solid #999">Tax @ '+registrationEvent.Tax_Rate__c+ '%</td><td align="right" bgcolor="#f3f3f3" style="padding-right:15px;color:#000000;font-weight:bold;background-color:#e7e5e5;border-right:1px solid #999;border-bottom:1px solid #999">$'+orders.Order_Taxes__c+'</td></tr> ' );
                   system.debug('$$$$$$$$$$$$$$$  '+replacedname );
                 } else{
                 replacedname = replacedname.Replace('{!displaytax}','');
                }
               
               
               
                /*
                try{
                  replacedname = replacedname.Replace('{!discount}',string.valueOf(orders.Order_Discount__c));
               }catch(exception ed){
                replacedname = replacedname.Replace('{!discount}','');
               }
              
                try{
                  replacedname = replacedname.Replace('{!tax}',string.valueOf(orders.Order_Taxes__c));
               }catch(exception ed){
                replacedname = replacedname.Replace('{!tax}','');
               }
               */
                try{
                  replacedname = replacedname.Replace('{!amountpaid}',string.valueOf(orders.Amount_Paid__c));
               }catch(exception ed){
                replacedname = replacedname.Replace('{!amountpaid}','');
               }
               
               
                 if(eventsList[0].Street1__c!=null && eventsList[0].Street1__c!='' ){
                  replacedname = replacedname.Replace('{!add1}',eventsList[0].Street1__c);
               }else{
                replacedname = replacedname.Replace('{!add1}','');
               }
               
                try{
                 if(eventsList[0].Street2__c!=null){   
                  replacedname = replacedname.Replace('{!add2}', ', '+eventsList[0].Street2__c);
                 }else{
                     replacedname = replacedname.Replace('{!add2}', '');
                 }
               }catch(exception ed){
                replacedname = replacedname.Replace('{!add2}','');
               }
            
            
               if(eventsList[0].City__c!=null && eventsList[0].City__c!=''){
                  replacedname = replacedname.Replace('{!city}',eventsList[0].City__c);
               }else{
                replacedname = replacedname.Replace('{!city}','');
               }
               
               if(eventsList[0].BLN_State__r.Short_Name__c!=null){
                  replacedname = replacedname.Replace('{!state}',', '+eventsList[0].BLN_State__r.Short_Name__c);
               }else{
                  replacedname = replacedname.Replace('{!state}','');
               }
             
                if(eventsList[0].ZipCode__c!=null){
                  replacedname = replacedname.Replace('{!zip}',' '+eventsList[0].ZipCode__c);
               }else{
                replacedname = replacedname.Replace('{!zip}','');
               }
               
                 try{
                  replacedname = replacedname.Replace('{!eventadminname}',eventsList[0].owner.Name);
               }catch(exception ed){
               replacedname = replacedname.Replace('{!eventadminname}','');
               }
                 try{
                  replacedname = replacedname.Replace('{!eventadminemail}',eventsList[0].owner.username);
               }catch(exception ed){
                 replacedname = replacedname.Replace('{!eventadminemail}','');
               } 
                  
                try{
                  replacedname = replacedname.Replace('{!paymenttype}',pay.Payment_Mode__c);
               }catch(exception ed){
                 replacedname = replacedname.Replace('{!paymenttype}','');
               } 
                  
               if(orders.Order_Discount__c!=null && orders.Order_Discount__c>0){
                  replacedname = replacedname.Replace('{!displaypromovalue}',' <tr><td height="30" colspan="3" align="left" style="font-family:&#39;Helvetica Neue&#39;,Helvetica,Arial,sans-serif;padding-left:15px;background-color:#e7e5e5;border-left:1px solid #999;border-bottom:1px solid #999">Promo Code:('+promocode+')</td> <td align="right" bgcolor="#f3f3f3" style="padding-right:15px;color:#000000;font-weight:bold;background-color:#e7e5e5;border-right:1px solid #999;border-bottom:1px solid #999">$'+orders.Order_Discount__c+'</td> </tr>' );
                   system.debug('$$$$$$$$$$$$$$$  '+replacedname );
                 } else{
                 replacedname = replacedname.Replace('{!displaypromovalue}','');
                }
               
               system.debug('^^^^^^^^^^^^^^^^^^ '+replacedname );
                
               try{
                  replacedname = replacedname.Replace('{!promocode}',promocode );
               }catch(exception ed){
                 replacedname = replacedname.Replace('{!promocode}','');
               }   
               
               string qr = '<img src="';
               qr+='https://chart.googleapis.com/chart?chs=120x120&cht=qr&chl='+orders.id;
               qr+='"  width="100" height="100" />';
             
                try{
                  replacedname = replacedname.Replace('{!qrcode}',qr);
               }catch(exception ed){
                 replacedname = replacedname.Replace('{!qrcode}','');
               } 
               
               
               
              string mapurl = 'http://maps.google.com/maps?q='+eventsList[0].Venue_Name__c+','+eventsList[0].Street1__c+','+eventsList[0].City__c+','+eventsList[0].BLN_State__r.Short_Name__c+' ' +eventsList[0].ZipCode__c+','+eventsList[0].BLN_Country__r.Short_Name__c;
               
                 try{
                  replacedname = replacedname.Replace('{!mapurl}',mapurl);
               }catch(exception ed){
                 replacedname = replacedname.Replace('{!mapurl}','');
               }
               
                email.setOrgWideEmailAddressId(org.Id);
              email.setHtmlBody(replacedname);            
              EmailsList.add(email); 
             if(EmailsList.size()>0){
               try{
                   Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email});
                      system.debug('AAAAAAAAAAAAAA '+r);  
               }catch(exception ecd){}
            }
         }
         
         
           
         
     }catch(exception rr){
       error =   rr.getMessage();      
     }
  }

}