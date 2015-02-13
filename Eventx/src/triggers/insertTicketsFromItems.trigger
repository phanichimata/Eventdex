trigger insertTicketsFromItems on BLN_Item__c (after delete, after insert, after undelete, after update) {

system.debug('RRRRRRRRRRRRRRRRRRR '+BLN_ReUse_EventsEditCon.isFirstRun());
 if(BLN_ReUse_EventsEditCon.isFirstRun()){

         BLN_ReUse_EventsEditCon.setFirstRunFalse();
    if(trigger.isAfter){
        if(trigger.isInsert){
             LIST<Id> newItemIds = new LIST<ID>(); //Not Used  
              LIST<Id> newPackageItemIds = new LIST<ID>(); //Storing Package ids
             
             MAP<ID, BLN_Item__c> newitemsMAP = new MAP<ID, BLN_Item__c>();
             newitemsMAP = trigger.newMap;
             system.debug(newitemsMAP.size()+'  ITEM MAP SIZE '+newitemsMAP); 
        MAP<ID, BLN_Item__c> newItems = new MAP<ID, BLN_Item__c>([Select b.service_fee__c, b.sale_start__c, b.sale_end__c, b.price__c, b.min_per_order__c, b.max_per_order__c, 
                        b.item_type__c, b.item_name__c, b.item_count__c, b.image_url__c, b.addon_parent_id__c, b.addon_only__c, b.Visibility__c,  
                        b.Taxable__c, b.Show_Expired__c, b.Payment__c, b.Name, b.Item_Pool__c, b.Id, b.Event__c, b.Discountable__c, b.Description__c, 
                        b.Item_Type__r.Item_Type_Number__c, b.Currency_Code__c, Item_Pool__r.Badge_Label__c  From BLN_Item__c b WHERE ID IN: newitemsMAP.Keyset() for update]);
                
            LIST<Ticket__c> insertIndividualTickets = new LIST<Ticket__c>();
            LIST<Ticket__c> insertMainPackageTickets = new LIST<Ticket__c>();
            
             system.debug(newItems.size()+'  ITEM SIZE '+newItems);             
            //We are inserting only IndividualTickets and main Package Items..................................    
            for(BLN_Item__c ite: trigger.new){
              
              if(newItems.containsKey(ite.id)){
                
                    if(newItems.get(ite.id).item_type__r.Item_Type_Number__c !=  BLN_Event_UtilityCon.packageItemType()){
                        
                        for(Integer i=1; i <= ite.item_count__c; i++){
                            Ticket__c singleTicket = new Ticket__c();
                        
                            singleTicket.Event__c = ite.Event__c;
                            singleTicket.Item__c = ite.id;
                            singleTicket.Item_Pool__c = ite.Item_Pool__c;
                            singleTicket.Item_Type__c = ite.item_type__c;
                            
                            if(newItems.get(ite.id).Item_Pool__c != null){
                                singleTicket.Badge_Label__c =  newItems.get(ite.id).Item_Pool__r.Badge_Label__c;
                            }
                            
                            
                            insertIndividualTickets.add(singleTicket);
                        }
                        
                        // END of individual Tickets Items inserting.............................
                        //Starting Package Tickets bthrough  Item inserting....................
                     }else if(newItems.get(ite.id).item_type__r.Item_Type_Number__c ==  BLN_Event_UtilityCon.packageItemType()){
                        
                        newPackageItemIds.add(ite.Item_Pool__c);
                        for(Integer i=1; i <= ite.item_count__c; i++){
                            Ticket__c singleTicket = new Ticket__c();
                        
                            singleTicket.Event__c = ite.Event__c;
                            singleTicket.Item__c = ite.id;
                            singleTicket.Item_Pool__c = ite.Item_Pool__c;
                            singleTicket.Item_Type__c = ite.item_type__c;
                            
                            if(newItems.get(ite.id).Item_Pool__c != null){
                                singleTicket.Badge_Label__c =  newItems.get(ite.id).Item_Pool__r.Badge_Label__c;
                            }
                            
                            insertMainPackageTickets.add(singleTicket);
                        }
                        
                     }// END of Package Items inserting.............................
              }
                    
            }//End of Items Loop................
            //Insert individual
            LIST<DataBase.Saveresult> individualTicketsResult = DataBase.insert(insertIndividualTickets, FALSE);
            
            LIST<DataBase.Saveresult> packageTicketsResult =    DataBase.insert(insertMainPackageTickets, FALSE);
        
            //Get All Package Tickets to fill ID for Package LineItems .................
            LIST<ID> savedPackagesTicketsId = new LIST<ID>();
            for(DataBase.Saveresult r: packageTicketsResult){
                savedPackagesTicketsId.add(r.getId() );
            }
            
            system.debug('1111111111111111      '+ savedPackagesTicketsId.size()+'      '+savedPackagesTicketsId);
            MAP<String, LIST<Ticket__c>> itemBasedTickets =  new MAP<String,  LIST<Ticket__c>>();
            LIST<Ticket__c> savedPackageTickets = [SELECT ID, NAME,Item__r.Name, Item__c, Item_Pool__c, Item_Pool__r.Name , Item_Type__c, Parent_ID__c, Parent_ID__r.Name,  Event__c, Badge_Label__c FROM Ticket__c WHERE ID IN: savedPackagesTicketsId for update];
            //maintain MAP for Package related Tickets by useing following type..................
            // MAP<Item-000088(Item Name), LIST<Tickets related Packages>>
            
            system.debug('22222222222222222   '+ savedPackageTickets.size() );
            
            for(Ticket__c t: savedPackageTickets){
                
                if(itemBasedTickets.containsKey(t.Item__r.Name)){
                    LIST<Ticket__c> alreadyHavingTickates = new LIST<Ticket__c>();
                    alreadyHavingTickates.addAll(itemBasedTickets.get(t.Item__r.Name));
                    alreadyHavingTickates.add(t);
                    
                    itemBasedTickets.put(t.Item__r.Name,alreadyHavingTickates);
                }else{
                    LIST<Ticket__c> freshTickates = new LIST<Ticket__c>();
                    freshTickates.add(t);
                    
                    itemBasedTickets.put(t.Item__r.Name, freshTickates);
                }
                
            }
            system.debug('3333333333333333333333333333   '+ itemBasedTickets.size() +'       '+itemBasedTickets);
            
            system.debug('44444444444444444444444444444   '+ newPackageItemIds.size() +'       '+newPackageItemIds); 
            //Here we will Qury Package line Items by using package Ids....................
            MAP<String, LIST<Item_Pool__c>> packageItemPoolLineItems =  new MAP<String,  LIST<Item_Pool__c>>();
            LIST<Item_Pool__c> packageLineItems = [SELECT ID, NAME,Addon_Parent__r.Name, Addon_Parent__c, Addon_Count__c, Item_Count__c, Badge_Label__c FROM Item_Pool__c WHERE Addon_Parent__c IN: newPackageItemIds for update];
            
            for(Item_Pool__c ip: packageLineItems){
                
                if(packageItemPoolLineItems.containsKey(ip.Addon_Parent__r.Name)){
                    LIST<Item_Pool__c> packageBasedItemPools = new LIST<Item_Pool__c>();
                    packageBasedItemPools.addAll(packageItemPoolLineItems.get(ip.Addon_Parent__r.Name));
                    packageBasedItemPools.add(ip);
                    
                    packageItemPoolLineItems.put(ip.Addon_Parent__r.Name, packageBasedItemPools);
                }else{
                    LIST<Item_Pool__c> packageBasedItemPools = new LIST<Item_Pool__c>();
                    packageBasedItemPools.add(ip);
                    
                    packageItemPoolLineItems.put(ip.Addon_Parent__r.Name, packageBasedItemPools);
                }
            }
            
            system.debug('555555555555555555555555555555555   '+ packageItemPoolLineItems.size() +'       '+packageItemPoolLineItems); 
            
            // we are inserting Package Line Items............. by 
            // In 1st For loop ITEMS will rotate 
            // in 2nd For loop we will loop inserted Item related Package Tickets...................
            // In 3rd For Loop we will loop ItemPool Items related to that tickets................
            // In 4th For Loop we will do for loop How many Item Pool tickets will rotate...............
             
             LIST<Ticket__c> packageLineItemsTickets = new LIST<Ticket__c>();
             
            for(BLN_Item__c ite: trigger.new){
                    system.debug('6666666666666666666666  '+ itemBasedTickets.containsKey(ite.Name) +'       '+ite.Name); 
                if(itemBasedTickets.containsKey(ite.Name)){
                    for(Ticket__c pakTic: itemBasedTickets.get(ite.Name)){
                        
                        system.debug('777777777777777777777777  '+ packageItemPoolLineItems.containsKey(pakTic.Item_Pool__r.Name)+'       '+pakTic.Item_Pool__r.Name); 
                    
                        if(packageItemPoolLineItems.containsKey(pakTic.Item_Pool__r.Name)){
                            for(Item_Pool__c packageLineItemPool: packageItemPoolLineItems.get(pakTic.Item_Pool__r.Name)){
                                
                                system.debug('888888888888888888888888888888  '+ packageLineItemPool.Addon_Count__c); 
                                
                                if(packageLineItemPool.Addon_Count__c > 0){
                                    for(integer i= 1; i<= packageLineItemPool.Addon_Count__c ; i++){
                                        
                                        Ticket__c singleTicket = new Ticket__c();
                                    /*
                                        singleTicket.Event__c = ite.Event__c;
                                        singleTicket.Item__c = ite.id;
                                        singleTicket.Item_Pool__c = ite.Item_Pool__c;
                                        singleTicket.Item_Type__c = ite.item_type__c;
                                        singleTicket.Parent_ID__c = pakTic.Id;
                                        singleTicket.Badge_Label__c = packageLineItemPool.Badge_Label__c;
                                    */  
                                    
                                        singleTicket.Event__c = ite.Event__c;
                                        singleTicket.Item__c = ite.id;
                                        singleTicket.Item_Pool__c = packageLineItemPool.id;
                                        singleTicket.Item_Type__c = ite.item_type__c;
                                        singleTicket.Parent_ID__c = pakTic.Id;
                                        singleTicket.Badge_Label__c = packageLineItemPool.Badge_Label__c;
                                    
                                        packageLineItemsTickets.add(singleTicket);
                                        
                                         
                                        system.debug('999999999999999999999999999999         '+ packageLineItemsTickets.size()); 
                                    }
                                    
                                }
                            }
                        }   
                    }
                     
                }
                
                
            }
            
            LIST<dataBase.Saveresult> packageLineItemsTicketsResult = DataBase.insert(packageLineItemsTickets, false);
            system.debug('%%%%%%%%%%%%%%%%%%%&&&&&&&&&&&&&&&&77 '+ packageLineItemsTicketsResult);    
        }// end of Trigger.new Loop
        
        
        
        //update trigger code
        if(trigger.isUpdate){
        MAP<ID, BLN_Item__c> newitemsMAP = new MAP<ID, BLN_Item__c>();
             newitemsMAP = trigger.newMap;
 MAP<ID, BLN_Item__c> newItems = new MAP<ID, BLN_Item__c>([Select b.service_fee__c, b.sale_start__c, b.sale_end__c, b.price__c, b.min_per_order__c, b.max_per_order__c, 
                        b.item_type__c, b.item_name__c, b.item_count__c, b.image_url__c, b.addon_parent_id__c, b.addon_only__c, b.Visibility__c,  
                        b.Taxable__c, b.Show_Expired__c, b.Payment__c, b.Name, b.Item_Pool__c, b.Id, b.Event__c, b.Discountable__c, b.Description__c, 
                        b.Item_Type__r.Item_Type_Number__c, b.Currency_Code__c, Item_Pool__r.Badge_Label__c  From BLN_Item__c b WHERE ID IN: newitemsMAP.Keyset() for update]);
              LIST<Id> newPackageItemIds = new LIST<ID>(); //Storing Package ids   
            LIST<Ticket__c> insertIndividualTickets = new LIST<Ticket__c>();
            List<Ticket__c> deleteIndividualTickets=new LIST<Ticket__c>();
            
            LIST<Ticket__c> insertMainPackageTickets = new LIST<Ticket__c>();
            List<Ticket__c> deleteMainPackageTickets=new LIST<Ticket__c>();
            Set<Ticket__c> deleteChildPackageTickets=new Set<Ticket__c>();

    
    //We are inserting only IndividualTickets and main Package Items..................................    
            for(BLN_Item__c ite: trigger.new){
              
              if(newItems.containsKey(ite.id)){
                
                    if(newItems.get(ite.id).item_type__r.Item_Type_Number__c !=  BLN_Event_UtilityCon.packageItemType()){
                        BLN_Item__c blitem = Trigger.oldMap.get(ite.id);
                        Decimal remquantity=(ite.item_count__c-blitem.item_count__c);
                        if(remquantity>0){
                        for(Integer i=1; i <= remquantity; i++){
                            Ticket__c singleTicket = new Ticket__c();
                        
                            singleTicket.Event__c = ite.Event__c;
                            singleTicket.Item__c = ite.id;
                            singleTicket.Item_Pool__c = ite.Item_Pool__c;
                            singleTicket.Item_Type__c = ite.item_type__c;
                            
                            if(newItems.get(ite.id).Item_Pool__c != null){
                                singleTicket.Badge_Label__c =  newItems.get(ite.id).Item_Pool__r.Badge_Label__c;
                            }
                            
                            
                            insertIndividualTickets.add(singleTicket);
                        }


           

                        }
                        else if(remquantity<0)
                        {
                        Integer delqty=Integer.valueOf(remquantity)*-1;
                           deleteIndividualTickets.addAll([select id,name,Item__c,Ticket_Status__c from Ticket__c where Item__c=:ite.id and Event__c=:ite.Event__c and Ticket_Status__c='Available' limit :delqty for update]);
                                     
                        }
                        // END of individual Tickets Items inserting.............................
                        //Starting Package Tickets bthrough  Item inserting....................
                     }
                     else if(newItems.get(ite.id).item_type__r.Item_Type_Number__c ==  BLN_Event_UtilityCon.packageItemType()){
                        
                        newPackageItemIds.add(ite.Item_Pool__c);
                        BLN_Item__c blitem = Trigger.oldMap.get(ite.id);
                        Decimal remquantity=(ite.item_count__c-blitem.item_count__c);
                        if(remquantity>0){
                        for(Integer i=1; i <= remquantity; i++){
                            Ticket__c singleTicket = new Ticket__c();
                        
                            singleTicket.Event__c = ite.Event__c;
                            singleTicket.Item__c = ite.id;
                            singleTicket.Item_Pool__c = ite.Item_Pool__c;
                            singleTicket.Item_Type__c = ite.item_type__c;
                            
                            if(newItems.get(ite.id).Item_Pool__c != null){
                                singleTicket.Badge_Label__c =  newItems.get(ite.id).Item_Pool__r.Badge_Label__c;
                            }
                            
                            insertMainPackageTickets.add(singleTicket);
                             }
                             }
                        else if(remquantity<0)
                        {
                        Integer delqty=Integer.valueOf(remquantity)*-1;
                           deleteMainPackageTickets.addAll([select id,name,Item__c,Ticket_Status__c from Ticket__c where Item__c=:ite.id and Event__c=:ite.Event__c and Ticket_Status__c='Available' and Parent_ID__c=null limit :delqty for update]);
                           LIST<ID> deletemainTicketsId = new LIST<ID>();
            for(Ticket__c t: deleteMainPackageTickets){
                deletemainTicketsId .add(t.id);
            }
                         deleteChildPackageTickets.addAll([select id,name,Parent_ID__c from Ticket__c where Parent_ID__c IN :deletemainTicketsId for update]);
                        }
                        
                     }// END of Package Items inserting.............................
                     }
                     }
                     //Insert individual
            LIST<DataBase.Saveresult> individualTicketsResult = DataBase.insert(insertIndividualTickets, FALSE);
              LIST<DataBase.Deleteresult> deleteTicketsResult = DataBase.delete(deleteIndividualTickets, FALSE);
                      LIST<DataBase.Saveresult> packageTicketsResult =    DataBase.insert(insertMainPackageTickets, FALSE);
                             LIST<DataBase.Deleteresult> deletePackageTicketsResult = DataBase.delete(deleteMainPackageTickets, FALSE);
                             List<Ticket__c> deleteChildPackageTicketslist=new List<Ticket__c>();
                             deleteChildPackageTicketslist.addAll(deleteChildPackageTickets);
                            LIST<DataBase.Deleteresult> deleteChildPackageTicketsResult = DataBase.delete(deleteChildPackageTicketslist, FALSE); 
                     
                    
                     
                            
                            //start of adding package line items
                            //Get All Package Tickets to fill ID for Package LineItems .................
            List<ID> savedPackagesTicketsId = new List<ID>();
            /*for(DataBase.Saveresult r: packageTicketsResult){
                savedPackagesTicketsId.add(r.getId() );
            }*/
            
            //get all old and new tickets to update line items
            for(Ticket__c tc:[select id,name,Ticket_Status__c,Parent_ID__c,Item__c from Ticket__c where Ticket_Status__c='Available' and Parent_ID__c=null and Item__c=:trigger.newmap.keyset() for update])
            {
               savedPackagesTicketsId.add(tc.id);
            }
            
            List<Ticket__c> delchild=[select id,name,Ticket_Status__c,Parent_ID__c,Item__c from Ticket__c where Ticket_Status__c='Available' and Parent_ID__c IN:savedPackagesTicketsId for update];
             LIST<DataBase.Deleteresult> delchildTicketsResult = DataBase.delete(delchild, FALSE); 
            
            
            system.debug('1111111111111111      '+ savedPackagesTicketsId.size()+'      '+savedPackagesTicketsId);
            MAP<String, LIST<Ticket__c>> itemBasedTickets =  new MAP<String,  LIST<Ticket__c>>();
            LIST<Ticket__c> savedPackageTickets = [SELECT ID, NAME,Item__r.Name, Item__c, Item_Pool__c, Item_Pool__r.Name , Item_Type__c, Parent_ID__c, Parent_ID__r.Name,  Event__c, Badge_Label__c FROM Ticket__c WHERE ID IN: savedPackagesTicketsId for update];
            //maintain MAP for Package related Tickets by useing following type..................
            // MAP<Item-000088(Item Name), LIST<Tickets related Packages>>
            
            system.debug('22222222222222222   '+ savedPackageTickets.size() );
            
            for(Ticket__c t: savedPackageTickets){
                
                if(itemBasedTickets.containsKey(t.Item__r.Name)){
                    LIST<Ticket__c> alreadyHavingTickates = new LIST<Ticket__c>();
                    alreadyHavingTickates.addAll(itemBasedTickets.get(t.Item__r.Name));
                    alreadyHavingTickates.add(t);
                    
                    itemBasedTickets.put(t.Item__r.Name,alreadyHavingTickates);
                }else{
                    LIST<Ticket__c> freshTickates = new LIST<Ticket__c>();
                    freshTickates.add(t);
                    
                    itemBasedTickets.put(t.Item__r.Name, freshTickates);
                }
                
            }
            system.debug('3333333333333333333333333333   '+ itemBasedTickets.size() +'       '+itemBasedTickets);
            
            system.debug('44444444444444444444444444444   '+ newPackageItemIds.size() +'       '+newPackageItemIds); 
            //Here we will Qury Package line Items by using package Ids....................
            MAP<String, LIST<Item_Pool__c>> packageItemPoolLineItems =  new MAP<String,  LIST<Item_Pool__c>>();
            LIST<Item_Pool__c> packageLineItems = [SELECT ID, NAME,Addon_Parent__r.Name, Addon_Parent__c, Addon_Count__c, Item_Count__c, Badge_Label__c FROM Item_Pool__c WHERE Addon_Parent__c IN: newPackageItemIds for update];
            
            for(Item_Pool__c ip: packageLineItems){
                
                if(packageItemPoolLineItems.containsKey(ip.Addon_Parent__r.Name)){
                    LIST<Item_Pool__c> packageBasedItemPools = new LIST<Item_Pool__c>();
                    packageBasedItemPools.addAll(packageItemPoolLineItems.get(ip.Addon_Parent__r.Name));
                    packageBasedItemPools.add(ip);
                    
                    packageItemPoolLineItems.put(ip.Addon_Parent__r.Name, packageBasedItemPools);
                }else{
                    LIST<Item_Pool__c> packageBasedItemPools = new LIST<Item_Pool__c>();
                    packageBasedItemPools.add(ip);
                    
                    packageItemPoolLineItems.put(ip.Addon_Parent__r.Name, packageBasedItemPools);
                }
            }
            
            system.debug('555555555555555555555555555555555   '+ packageItemPoolLineItems.size() +'       '+packageItemPoolLineItems); 
            
            // we are inserting Package Line Items............. by 
            // In 1st For loop ITEMS will rotate 
            // in 2nd For loop we will loop inserted Item related Package Tickets...................
            // In 3rd For Loop we will loop ItemPool Items related to that tickets................
            // In 4th For Loop we will do for loop How many Item Pool tickets will rotate...............
             
             LIST<Ticket__c> packageLineItemsTickets = new LIST<Ticket__c>();
             
            for(BLN_Item__c ite: trigger.new){
                    system.debug('6666666666666666666666  '+ itemBasedTickets.containsKey(ite.Name) +'       '+ite.Name); 
                if(itemBasedTickets.containsKey(ite.Name)){
                    for(Ticket__c pakTic: itemBasedTickets.get(ite.Name)){
                        
                        system.debug('777777777777777777777777  '+ packageItemPoolLineItems.containsKey(pakTic.Item_Pool__r.Name)+'       '+pakTic.Item_Pool__r.Name); 
                    
                        if(packageItemPoolLineItems.containsKey(pakTic.Item_Pool__r.Name)){
                            for(Item_Pool__c packageLineItemPool: packageItemPoolLineItems.get(pakTic.Item_Pool__r.Name)){
                                
                                system.debug('888888888888888888888888888888  '+ packageLineItemPool.Addon_Count__c); 
                                
                                if(packageLineItemPool.Addon_Count__c > 0){
                                    for(integer i= 1; i<= packageLineItemPool.Addon_Count__c ; i++){
                                        
                                        Ticket__c singleTicket = new Ticket__c();
                                   
                                    
                                        singleTicket.Event__c = ite.Event__c;
                                        singleTicket.Item__c = ite.id;
                                        singleTicket.Item_Pool__c = packageLineItemPool.id;
                                        singleTicket.Item_Type__c = ite.item_type__c;
                                        singleTicket.Parent_ID__c = pakTic.Id;
                                        singleTicket.Badge_Label__c = packageLineItemPool.Badge_Label__c;
                                    
                                        packageLineItemsTickets.add(singleTicket);
                                        
                                         
                                        system.debug('999999999999999999999999999999         '+ packageLineItemsTickets.size()); 
                                    }
                                    
                                }
                            }
                        }   
                    }
                     
                }
                
                
            }
            
            LIST<dataBase.Saveresult> packageLineItemsTicketsResult = DataBase.insert(packageLineItemsTickets, false);
                            
                            //end of adding package line items
                            
                            
                            
                            
                        }
                       
         
        //end of update trigger code
        
        
        
        
    }






}



}